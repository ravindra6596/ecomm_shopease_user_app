import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/login_request_model.dart';
import 'package:e_comm_user/models/login_response_model.dart';
import 'package:e_comm_user/models/logout_response_model.dart';
import 'package:e_comm_user/models/register_request_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRepository {
  final ApiClient apiClient = getIt<ApiClient>();

  Future<Result<LoginResponseModel, Exception>> loginUser(
      LoginRequestModel loginRequestModel) async {
    try {
      final response = await apiClient.loginUser(loginRequestModel);
      return Success(response);
    } on Exception catch(e){
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message']
          .toString()
          .isNotEmpty) {
        return Failure(res['message'], );
      } else {
        return Failure(e.toString() );
      }
    }
  }

  Future<Result<LoginResponseModel, Exception>> registerUser(
      RegisterRequestModel registerRequestModel) async {
    try {
      final response = await apiClient.registerUser(registerRequestModel);
      return Success(response);
    } on Exception catch(e){
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message'], );
      } else {
        return Failure(e.toString() );
      }
    }
  }
  Future<Result<LogoutResponseModel, Exception>> logoutUser(String accessToken) async {
    try {
      final response = await apiClient.logoutUser('Bearer $accessToken');
      return Success(response);
    } on Exception catch(e){
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message']
          .toString().isNotEmpty) {
        return Failure(res['message'], );
      } else {
        return Failure(e.toString() );
      }
    }
  }

}
