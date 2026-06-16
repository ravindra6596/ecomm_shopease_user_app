import 'package:e_comm_user/models/login_response_model.dart';
import 'package:e_comm_user/models/logout_response_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final LoginResponseModel loginResponseModel;
  AuthSuccessState(this.loginResponseModel);
}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}

class LogoutSuccessState extends AuthState {
  final LogoutResponseModel logoutResponseModel;
  LogoutSuccessState(this.logoutResponseModel);
}
class LogoutErrorState extends AuthState {
  final String error;
  LogoutErrorState(this.error);
}
class AuthPasswordVisibilityState extends AuthState {
  final bool isPasswordVisible;
  AuthPasswordVisibilityState(this.isPasswordVisible);
}
class AuthenticatedState extends AuthState {
  final int userId;
  final String email;
  final String role;

  AuthenticatedState({
    required this.userId,
    required this.email,
    required this.role,
  });
}
class UnAuthenticatedState extends AuthState {}
class RememberMeState extends AuthState {
  final bool rememberMe;

  RememberMeState(this.rememberMe);
}
class RememberMeCredentialsLoadedState extends AuthState {
  final bool rememberMe;
  final String email;
  final String password;

  RememberMeCredentialsLoadedState(
      this.rememberMe,
      this.email,
      this.password,
  );
}