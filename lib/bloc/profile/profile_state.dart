import 'package:e_comm_user/models/profile_response_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}
class ProfileLoadingState extends ProfileState {}
class ProfileSuccessState extends ProfileState {
  ProfileResponseModel profileResponseModel;
  final bool isEditing;
  ProfileSuccessState(this.profileResponseModel,{this.isEditing=false});
}
class ProfileUpdatingState extends ProfileState {}
class ProfileUpdatedState extends ProfileState {
  final String message;

  ProfileUpdatedState(this.message);
}
class ProfileErrorState extends ProfileState {
  final String error;
  ProfileErrorState(this.error);
}
