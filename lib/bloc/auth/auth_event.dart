import 'package:e_comm_user/models/login_request_model.dart';
import 'package:e_comm_user/models/register_request_model.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final LoginRequestModel loginRequestModel;
  LoginEvent(this.loginRequestModel);
}

class RegisterEvent extends AuthEvent {
  final RegisterRequestModel registerRequestModel;
  RegisterEvent(this.registerRequestModel);
}

class LogoutEvent extends AuthEvent {
  final String accessToken;
  LogoutEvent(this.accessToken);
}

class TogglePasswordVisibilityEvent extends AuthEvent {}
class CheckAuthStatusEvent extends AuthEvent {}
class ToggleRememberMeEvent extends AuthEvent {
  final bool value;

  ToggleRememberMeEvent(this.value);
}

class LoadRememberMeEvent extends AuthEvent {}