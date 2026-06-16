import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/home_response_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class HomeRepository {
  Future<Result<HomeResponseModel, Exception>> getHome(int categoryId);
}

@Injectable(as: HomeRepository)
class AddressRepositoryImpl implements HomeRepository {
  AddressRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Result<HomeResponseModel, Exception>> getHome(int categoryId) async {
    try {
      final homeResponseModel = await apiClient.getHome(categoryId);
      if (homeResponseModel.statusCode == 200) {
        return Success(homeResponseModel);
      } else {
        return Failure(homeResponseModel.message ?? '');
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
}
