import 'package:e_comm_user/core/local_cart_database.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:injectable/injectable.dart';

abstract class CartLocalDataSource {
  Future<int> addToCart(CartItem item);

  Future<List<CartItem>> getCartItems();

  Future<int> updateQuantity(int productId, int quantity);

  Future<int> removeItem(int productId);

  Future<int> clearCart();

  Future<bool> isProductInCart(int productId);

  Future<int> getCartItemCount();

  Future<int> getCartTotal();
  Future<int> getDiscountCartTotal();
  Future<List<CartItem>> getUnsyncedCartItems();
  Future<void> markAllCartItemsSynced();
}

@Injectable(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final LocalCartDatabase _database;

  CartLocalDataSourceImpl(this._database);

  @override
  Future<int> addToCart(CartItem item) async {
    return await _database.addToCart(item);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return await _database.getCartItems();
  }

  @override
  Future<int> updateQuantity(int productId, int quantity) async {
    return await _database.updateQuantity(productId, quantity);
  }

  @override
  Future<int> removeItem(int productId) async {
    return await _database.removeItem(productId);
  }

  @override
  Future<int> clearCart() async {
    return await _database.clearCart();
  }

  @override
  Future<bool> isProductInCart(int productId) async {
    return await _database.isProductInCart(productId);
  }

  @override
  Future<int> getCartItemCount() async {
    return await _database.getCartItemCount();
  }

  @override
  Future<int> getCartTotal() async {
    return await _database.getCartTotal();
  }

  @override
  Future<int> getDiscountCartTotal() async {
    return await _database.getDiscountCartTotal();
  }

  @override
  Future<List<CartItem>> getUnsyncedCartItems() async {
    return await _database.getUnsyncedCartItems();
  }

  @override
  Future<void> markAllCartItemsSynced() async {
    return await _database.markAllCartItemsSynced();
  }
}
