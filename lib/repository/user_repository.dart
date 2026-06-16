import 'package:e_comm_user/models/user_details_model.dart';
import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/user_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class UserRepository {
  Future<Result<UserResponseModel, Exception>> getUserList(int page, int limit);
  Future<Result<UserDetailsModel, Exception>> getUserDetails(int userId);
}

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.apiClient);

  ApiClient apiClient;

  // user data
  @override
  Future<Result<UserResponseModel, Exception>> getUserList(int page, int limit) async {
    try {
      UserResponseModel userResponseModel = await apiClient.getUserList(page, limit);
      if (userResponseModel.statusCode == 200) {
        return Success(userResponseModel);
      }
      else {
        return Failure(userResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }
  // user details data
  @override
  Future<Result<UserDetailsModel, Exception>> getUserDetails(int userId) async {
    try {
      UserDetailsModel userDetailsModel = await apiClient.getUserDetails(userId);
      if (userDetailsModel.statusCode == 200) {
        return Success(userDetailsModel);
      }
      else {
        return Failure(userDetailsModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message'], );
      } else {
        return Failure(e.toString(),  );
      }
     }
  }
}