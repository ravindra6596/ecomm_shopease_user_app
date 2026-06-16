import 'package:dio/dio.dart';
import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:injectable/injectable.dart';

abstract class WishlistRemoteDataSource {
  Future<Result<WishlistResponseModel, Exception>>
  getWishlistItems();

  Future<Result<AddToWishlistResponseModel, Exception>>
  addToWishlist(int productId);

  Future<Result<void, Exception>> removeFromWishlist(
      int wishlistItemId,
      );

  Future<Result<void, Exception>> clearWishlist();
}

@Injectable(as: WishlistRemoteDataSource)
class WishlistRemoteDataSourceImpl
    implements WishlistRemoteDataSource {
  final ApiClient _apiClient;

  WishlistRemoteDataSourceImpl(this._apiClient);

  bool _isSuccessStatus(int? code) =>
      code == null || code == 200 || code == 201 || code == 204;

  String _dioMessage(DioException e, String fallback) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    return e.message ?? fallback;
  }

  @override
  Future<Result<AddToWishlistResponseModel, Exception>>
  addToWishlist(int productId) async {
    try {
      final request =
      AddToWishlistRequestModel(product_id: productId);

      final response =
      await _apiClient.addToWishlist(request);

      if (_isSuccessStatus(response.statusCode)) {
        return Success(response);
      }

      return Failure(
        response.message ?? 'Failed to add wishlist',
      );
    } on DioException catch (e) {
      return Failure(
        _dioMessage(e, 'Failed to add wishlist'),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<WishlistResponseModel, Exception>>
  getWishlistItems() async {
    try {
      final response = await _apiClient.getWishlistItems();

      if (_isSuccessStatus(response.statusCode)) {
        return Success(response);
      }

      return Failure(
        response.message ?? 'Failed to get wishlist',
      );
    } on DioException catch (e) {
      return Failure(
        _dioMessage(e, 'Failed to get wishlist'),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> removeFromWishlist(
      int wishlistItemId,
      ) async {
    try {
      await _apiClient.removeFromWishlist(wishlistItemId);

      return Success(null);
    } on DioException catch (e) {
      return Failure(
        _dioMessage(e, 'Failed to remove wishlist'),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> clearWishlist() async {
    try {
      await _apiClient.clearWishlist();

      return Success(null);
    } on DioException catch (e) {
      return Failure(
        _dioMessage(e, 'Failed to clear wishlist'),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
