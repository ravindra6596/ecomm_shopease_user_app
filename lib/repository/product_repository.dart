import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class ProductRepository {
  Future<Result<ProductResponseModel, Exception>> getProductList(
      int page, int limit, String search, int? categoryId,ProductFilterModel? filter);
  Future<Result<ProductDetailsResponseModel, Exception>> getProductDetails(int id);
}

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Result<ProductResponseModel, Exception>> getProductList(
      int page, int limit, String search, int? categoryId,ProductFilterModel? filter,) async {
    try {
      final productResponseModel = await apiClient.getProductsList(page, limit, search, categoryId, filter?.min_price, filter?.max_price, filter?.sort_by, filter?.order);
      if (productResponseModel.statusCode == 200) {
        return Success(productResponseModel);
      } else {
        return Failure(productResponseModel.message ?? '');
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
  Future<Result<ProductDetailsResponseModel, Exception>> getProductDetails(int id) async {
    try {
      final productResponseModel = await apiClient.getProductDetails(id);
      if (productResponseModel.statusCode == 200) {
        return Success(productResponseModel);
      } else {
        return Failure(productResponseModel.message ?? '');
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
