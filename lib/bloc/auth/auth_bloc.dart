import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/bloc/cart/cart_event.dart';
import 'package:e_comm_user/bloc/home/home_bloc.dart';
import 'package:e_comm_user/bloc/home/home_event.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_bloc.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_event.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/login_response_model.dart';
import 'package:e_comm_user/models/logout_response_model.dart';
import 'package:e_comm_user/repository/auth_repository.dart';
import 'package:e_comm_user/repository/cart_repository.dart';
import 'package:e_comm_user/repository/wishlist_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final CartBloc cartBloc;
  final WishlistBloc wishlistBloc;
  final HomeBloc homeBloc;
  bool rememberMe = false;
  var prefs = getIt<SharedPreferences>();
  AuthBloc()
      : authRepository = getIt<AuthRepository>(),
        homeBloc = getIt<HomeBloc>(),
        cartBloc = getIt<CartBloc>(),
        wishlistBloc = getIt<WishlistBloc>(),
        super(AuthInitialState()) {
    on<LoginEvent>(loginUser);
    on<RegisterEvent>(registerUser);
    on<LogoutEvent>(logoutUser);
    on<TogglePasswordVisibilityEvent>(togglePasswordVisibility);
    on<CheckAuthStatusEvent>(checkAuthStatus);
    on<ToggleRememberMeEvent>(toggleRememberMe);
    on<LoadRememberMeEvent>(loadRememberMe);
  }

  loginUser(LoginEvent event, emit) async {
    CartRepository cartRepository = getIt<CartRepository>();
    WishlistRepository wishlistRepository = getIt<WishlistRepository>();
    emit(AuthLoadingState());
    final result = await authRepository.loginUser(event.loginRequestModel);
    switch (result) {
      case Success<LoginResponseModel, Exception>():
        final loginData = result.data;
        await SharedPrefHelper.saveTokens(
          loginData.data?.access_token ?? '',
          loginData.data?.refresh_token ?? '',
        );
        await SharedPrefHelper.saveUserInfo(
          loginData.data?.user?.id ?? 0,
          loginData.data?.user?.email ?? '',
          loginData.data?.user?.role ?? '',
        );
        await SharedPrefHelper.saveRememberMe(
          rememberMe: rememberMe,
          email: event.loginRequestModel.email ?? '',
          password: event.loginRequestModel.password ?? '',
        );
        await cartRepository.syncCartToServer();
        await wishlistRepository.syncWishlistToServer();
        cartBloc.add(GetCartItemsEvent());
        wishlistBloc.add(GetWishlistItemsEvent());
        await prefs.setBool(SharedPrefHelper.isLoginPref, true);
        await prefs.setBool(SharedPrefHelper.guestUser, false);
        emit(AuthSuccessState(result.data));
        add(CheckAuthStatusEvent());
        break;
      case Failure<LoginResponseModel, Exception>():
        emit(AuthErrorState(result.error.toString()));
        break;
    }
  }

  registerUser(RegisterEvent event, emit) async {
    emit(AuthLoadingState());
    final result = await authRepository.registerUser(event.registerRequestModel);
    switch (result) {
      case Success<LoginResponseModel, Exception>():
        final loginData = result.data;
        await SharedPrefHelper.saveTokens(
          loginData.data?.access_token ?? '',
          loginData.data?.refresh_token ?? '',
        );
        await SharedPrefHelper.saveUserInfo(
          loginData.data?.user?.id ?? 0,
          loginData.data?.user?.email ?? '',
          loginData.data?.user?.role ?? '',
        );
        emit(AuthSuccessState(result.data));
        cartBloc.add(UserLoggedInEvent());
        // emit(
        //   AuthenticatedState(
        //     userId: loginData.data?.user?.id ?? 0,
        //     email: loginData.data?.user?.email ?? '',
        //     role: loginData.data?.user?.role ?? '',
        //   ),
        // );
        break;
      case Failure<LoginResponseModel, Exception>():
        emit(AuthErrorState(result.error.toString()));
        break;
    }
  }

  logoutUser(LogoutEvent event, emit) async {
    await SharedPrefHelper.clearUserData();
    await SharedPrefHelper.saveGuestId(const Uuid().v4());
    if (!homeBloc.isClosed) {
      homeBloc.add(GetHomeEvent(0));
    }

    if (!cartBloc.isClosed) {
      cartBloc.add(UserLoggedOutEvent());
    }

    if (!wishlistBloc.isClosed) {
      wishlistBloc.add(UserLoggedOutWishlistEvent());
    }

    cartBloc.add(GetCartItemsEvent());
    wishlistBloc.add(GetWishlistItemsEvent());
    final result = await authRepository.logoutUser(event.accessToken);
    switch (result) {
      case Success<LogoutResponseModel, Exception>():
        emit(LogoutSuccessState(result.data));
        homeBloc.add(ClearHomeEvent());
        homeBloc.add(GetHomeEvent(0));
        break;
      case Failure<LogoutResponseModel, Exception>():
        emit(LogoutErrorState(result.error.toString()));
        break;
    }
  }

  togglePasswordVisibility(TogglePasswordVisibilityEvent event, emit) {
    if (state is AuthPasswordVisibilityState) {
      final currentState = state as AuthPasswordVisibilityState;
      emit(AuthPasswordVisibilityState(!currentState.isPasswordVisible));
    } else {
      emit(AuthPasswordVisibilityState(true));
    }
  }
  Future<void> checkAuthStatus(CheckAuthStatusEvent event,emit) async {
    final isLoggedIn = await SharedPrefHelper.isLoggedIn();
    if (isLoggedIn) {
      final user = await SharedPrefHelper.getUserInfo();
      emit(AuthSuccessState(LoginResponseModel()));
    } else {
      // emit(UnAuthenticatedState());
      emit(LogoutSuccessState(LogoutResponseModel()));
    }
  }

  void toggleRememberMe(ToggleRememberMeEvent event, emit) {
    rememberMe = event.value;
    emit(RememberMeState(rememberMe));
  }

  Future<void> _loadRememberMe(LoadRememberMeEvent event,emit) async {
    final data = await SharedPrefHelper.getRememberMeData();
    rememberMe = data['rememberMe'];
    emit(RememberMeState(rememberMe));
  }
  Future<void> loadRememberMe(
      LoadRememberMeEvent event,
      Emitter<AuthState> emit,
      ) async {
    final data = await SharedPrefHelper.getRememberMeData();

    rememberMe = data['rememberMe'];

    emit(
      RememberMeCredentialsLoadedState(
         rememberMe,
          data['email'],
          data['password'],
      ),
    );
  }
}
