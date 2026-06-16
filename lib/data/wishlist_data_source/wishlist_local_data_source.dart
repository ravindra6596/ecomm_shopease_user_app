import 'package:e_comm_user/core/local_cart_database.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:injectable/injectable.dart';

abstract class WishlistLocalDataSource {
  Future<int> addToWishlist(WishlistItem item);

  Future<List<WishlistItem>> getWishlistItems();

  Future<int> removeItem(int productId);

  Future<int> clearWishlist();

  Future<bool> isProductInWishlist(int productId);

  Future<int> getWishlistItemCount();

  Future<List<WishlistItem>> getUnsyncedWishlistItems();

  Future<void> markAllWishlistItemsSynced();
}

@Injectable(as: WishlistLocalDataSource)
class WishlistLocalDataSourceImpl
    implements WishlistLocalDataSource {
  final LocalCartDatabase _database;

  WishlistLocalDataSourceImpl(this._database);

  @override
  Future<int> addToWishlist(WishlistItem item) async {
    return await _database.addToWishlist(item);
  }

  @override
  Future<List<WishlistItem>> getWishlistItems() async {
    return await _database.getWishlistItems();
  }

  @override
  Future<int> removeItem(int productId) async {
    return await _database.removeWishlistItem(productId);
  }

  @override
  Future<int> clearWishlist() async {
    return await _database.clearWishlist();
  }

  @override
  Future<bool> isProductInWishlist(int productId) async {
    return await _database.isProductInWishlist(productId);
  }

  @override
  Future<int> getWishlistItemCount() async {
    return await _database.getWishlistItemCount();
  }

  @override
  Future<List<WishlistItem>> getUnsyncedWishlistItems() async {
    return await _database.getUnsyncedWishlistItems();
  }

  @override
  Future<void> markAllWishlistItemsSynced() async {
    return await _database.markAllWishlistItemsSynced();
  }
}
