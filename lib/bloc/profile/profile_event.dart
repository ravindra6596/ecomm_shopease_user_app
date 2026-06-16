import 'package:e_comm_user/models/profile_response_model.dart';

abstract class ProfileEvent {}
class LoadProfileEvent extends ProfileEvent {}
class ToggleEditProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UpdateProfileRequestModel request;

  UpdateProfileEvent(this.request);
}