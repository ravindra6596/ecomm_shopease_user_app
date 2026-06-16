import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/profile_response_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRepository {
  Future<Result<ProfileResponseModel, Exception>> getProfile();
  Future<Result<ProfileResponseModel, Exception>> updateProfile(
      UpdateProfileRequestModel request,
      );
}
@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Result<ProfileResponseModel, Exception>> getProfile() async {
    try {
      final profileResponseModel = await apiClient.getProfile();
      if (profileResponseModel.statusCode == 200) {
        return Success(profileResponseModel);
      } else {
        return Failure(profileResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
  @override
  Future<Result<ProfileResponseModel, Exception>> updateProfile(
      UpdateProfileRequestModel request,
      ) async {
    try {
      final response = await apiClient.updateProfile(request);

      if (response.statusCode == 200) {
        return Success(response);
      } else {
        return Failure(response.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);

      if ((res['message']) != null &&
          res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }

}