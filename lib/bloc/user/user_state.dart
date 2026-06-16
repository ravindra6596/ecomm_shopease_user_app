import 'package:e_comm_user/models/user_details_model.dart';
import 'package:e_comm_user/models/user_model.dart';

abstract class UserState {}

class UserInitialState extends UserState {}
class UserLoadingState extends UserState{}
class UserSuccessState extends UserState{
  final UserResponseModel userResponseModel;
  final bool hasMore;
  UserSuccessState(this.userResponseModel,this.hasMore);
}
class UserErrorState extends UserState{
  final String error;
  UserErrorState(this.error);
}
class UserDetailState extends UserState{
  final UserDetailsModel userDetailsModel;
  UserDetailState(this.userDetailsModel);
}
class UserDetailsLoadedState extends UserState{
  final UserDetailsModel userDetailsModel;
  UserDetailsLoadedState(this.userDetailsModel);
}
class UserDetailErrorState extends UserState{
  final String error;
  UserDetailErrorState(this.error);
}