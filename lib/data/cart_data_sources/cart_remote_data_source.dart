import 'package:dio/dio.dart';
import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:injectable/injectable.dart';

abstract class CartRemoteDataSource {
  Future<Result<AddToCartResponseModel, Exception>> addToCart(int productId);
  Future<Result<CartResponseModel, Exception>> getCartItems();
  Future<Result<UpdateQuantityResponseModel, Exception>> updateCartQuantity(
    int cartItemId,
    int quantity,
  );
  Future<Result<void, Exception>> removeFromCart(int cartItemId);
  Future<Result<void, Exception>> clearCart();
}

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSourceImpl(this._apiClient);

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
  Future<Result<AddToCartResponseModel, Exception>> addToCart(
    int productId,
  ) async {
    try {
      final request = AddToCartRequestModel(product_id: productId);
      final response = await _apiClient.addToCart(request);
      if (_isSuccessStatus(response.statusCode)) {
        return Success(response);
      }
      return Failure(response.message ?? 'Failed to add to cart');
    } on DioException catch (e) {
      return Failure(_dioMessage(e, 'Failed to add to cart'));
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<CartResponseModel, Exception>> getCartItems() async {
    try {
      final response = await _apiClient.getCartItems();
      if (_isSuccessStatus(response.statusCode)) {
        return Success(response);
      }
      return Failure(response.message ?? 'Failed to get cart items');
    } on DioException catch (e) {
      return Failure(_dioMessage(e, 'Failed to get cart items'));
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<UpdateQuantityResponseModel, Exception>> updateCartQuantity(
    int cartItemId,
    int quantity,
  ) async {
    try {
      final request = UpdateQuantityRequestModel(quantity: quantity);
      final response =
          await _apiClient.updateCartQuantity(cartItemId, request);
      if (_isSuccessStatus(response.statusCode)) {
        return Success(response);
      }
      return Failure(response.message ?? 'Failed to update quantity');
    } on DioException catch (e) {
      return Failure(_dioMessage(e, 'Failed to update quantity'));
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> removeFromCart(int cartItemId) async {
    try {
      // DELETE often returns 204 with empty body — Dio success means deleted.
      await _apiClient.removeFromCart(cartItemId);
      return Success(null);
    } on DioException catch (e) {
      return Failure(_dioMessage(e, 'Failed to remove from cart'));
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> clearCart() async {
    try {
      await _apiClient.clearCart();
      return Success(null);
    } on DioException catch (e) {
      return Failure(_dioMessage(e, 'Failed to clear cart'));
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
