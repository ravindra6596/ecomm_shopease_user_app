import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/category_model.dart';
import 'package:e_comm_user/utils/functions.dart';

abstract class CategoryRepository {
  Future<Result<TopCategoryResponseModel, Exception>> getTopCategories();

  Future<Result<CategoriesResponseModel, Exception>> getCategoryList(
      int page, int limit, int? categoryId);

  Future<Result<CategoryDetailsResponseModel, Exception>> getCategoryDetails(
      int id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Result<TopCategoryResponseModel, Exception>> getTopCategories() async {
    try {
      final TopCategoryResponseModel = await apiClient.getTopCategories();
      if (TopCategoryResponseModel.statusCode == 200) {
        return Success(TopCategoryResponseModel);
      } else {
        return Failure(TopCategoryResponseModel.message ?? '');
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
  Future<Result<CategoriesResponseModel, Exception>> getCategoryList(
      int page, int limit, int? categoryId) async {
    try {
      final categoriesResponseModel =
          await apiClient.getCategories(page, limit, categoryId);
      if (categoriesResponseModel.statusCode == 200) {
        return Success(categoriesResponseModel);
      } else {
        return Failure(categoriesResponseModel.message ?? '');
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
  Future<Result<CategoryDetailsResponseModel, Exception>> getCategoryDetails(
      int id) async {
    try {
      final categoryDetailsResponseModel =
          await apiClient.getCategoryDetails(id);
      if (categoryDetailsResponseModel.statusCode == 200) {
        return Success(categoryDetailsResponseModel);
      } else {
        return Failure(categoryDetailsResponseModel.message ?? '');
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
