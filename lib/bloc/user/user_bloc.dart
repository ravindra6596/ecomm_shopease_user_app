import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/user_details_model.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/user_model.dart';
import 'package:e_comm_user/repository/user_repository.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:injectable/injectable.dart';

import 'user_event.dart';
import 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository? userRepository;
  List<Users> allUsers = [];

  UserBloc()
      : userRepository = getIt<UserRepository>(),
        super(UserInitialState()) {
    on<UserEvent>(userListData);
    on<UserDetailEvent>(getUserDetails);
  }

  userListData(UserEvent event, emit) async {
    if (event is UserListEvent) {
      await userListMethod(event, emit);
    } else if (event is UserSearchEvent) {
      await userListSearch(event, emit);
    }
  }

  userListMethod(UserListEvent event, emit) async {
    if (event.page == 1) {
      emit(UserLoadingState());
      allUsers.clear();
      hasMoreData = true;
    }
    final userList = await userRepository!.getUserList(event.page, event.limit);

    switch (userList) {
      case Success<UserResponseModel, Exception>():
        final newUsers = userList.data.data?.users ?? [];
        if (newUsers.length < event.limit) {
          hasMoreData = false;
        }
        allUsers.addAll(newUsers);
        final updatedResponse = UserResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: UserData(users: allUsers),
        );

        emit(UserSuccessState(updatedResponse, hasMoreData));
        break;

      case Failure<UserResponseModel, Exception>():
        emit(UserErrorState(userList.error));
        break;
    }
  }

  userListSearch(UserSearchEvent event, emit) async {
    if (event.search.isEmpty) {
      emit(UserSuccessState(userResponseModel, hasMoreData));
    } else {
      final searchData = userResponseModel.data?.users
          ?.where((element) =>
              element.name!.toLowerCase().contains(event.search.toLowerCase()))
          .toList();
      final userResponseData = UserResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: UserData(users: searchData));
      emit(UserSuccessState(userResponseData, false));
    }
  }

  getUserDetails(UserDetailEvent event, emit) async {
    emit(UserLoadingState());
    final userDetails = await userRepository!.getUserDetails(event.userId);
    switch (userDetails) {
      case Success<UserDetailsModel, Exception>():
        emit(UserDetailsLoadedState(userDetails.data));
      case Failure<UserDetailsModel, Exception>():
        emit(UserDetailErrorState(userDetails.error));
    }
  }
}
