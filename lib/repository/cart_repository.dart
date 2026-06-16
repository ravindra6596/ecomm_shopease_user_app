import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/data/cart_data_sources/cart_remote_data_source.dart';
import 'package:e_comm_user/data/cart_data_sources/cart_local_data_source.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/repository/product_repository.dart';

import 'package:injectable/injectable.dart';

/// Cart storage strategy:
/// - **Guest** → SQLite CRUD via [CartLocalDataSource]
/// - **Logged in** → API CRUD via [CartRemoteDataSource]
/// - **On login** → [syncCartToServer] merges local cart into server (SQLite kept for logout)
abstract class CartRepository {
  Future<Result<void, Exception>> addToCart(
    int productId,
    String productName,
    int productPrice, {
    String? productImageUrl,
  });
  Future<Result<CartData, Exception>> getCartItems();
  Future<Result<void, Exception>> updateQuantity(
    int productId,
    int quantity, {
    int? cartLineId,
  });
  Future<Result<void, Exception>> removeFromCart(
    int productId, {
    int? cartLineId,
  });
  Future<Result<void, Exception>> clearCart();
  Future<Result<void, Exception>> syncCartToServer();
  Future<bool> isProductInCart(int productId);
  Future<int> getCartItemCount();
  Future<int> getCartTotal();
}

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  final CartRemoteDataSource _remoteDataSource;
  final ProductRepository _productRepository;
  final Map<int, String> _productImageCache = {};
  bool _isSyncing = false;
  CartRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._productRepository,
  );

  Future<bool> get _isLoggedIn => SharedPrefHelper.isLoggedIn();

  // ─── Guest: SQLite CRUD ───────────────────────────────────────────────────

  Future<Result<void, Exception>> _addToLocalCart(
    int productId,
    String productName,
    int productPrice, {
    String? productImageUrl,
  }) async {
    final cartItem = CartItem(
      product_id: productId,
      product_name: productName,
      product_price: productPrice,
      product_image_url: productImageUrl,
      quantity: 1,
      total_price: productPrice,
    );
    await _localDataSource.addToCart(cartItem);
    return Success(null);
  }

  Future<String?> _fetchProductImageUrl(int productId) async {
    if (_productImageCache.containsKey(productId)) {
      return _productImageCache[productId];
    }
    final result = await _productRepository.getProductDetails(productId);
    if (result is Success<ProductDetailsResponseModel, Exception>) {
      final images = result.data.data?.images;
      if (images != null && images.isNotEmpty) {
        final url = images.first.image_url;
        if (url != null && url.isNotEmpty) {
          _productImageCache[productId] = url;
          return url;
        }
      }
    }
    return null;
  }

  Future<List<CartItem>> _enrichItemsWithImages(List<CartItem> items) async {
    final enriched = <CartItem>[];
    for (final item in items) {
      if (item.product_image_url != null &&
          item.product_image_url!.isNotEmpty) {
        enriched.add(item);
        continue;
      }
      final productId = item.product_id;
      if (productId == null) {
        enriched.add(item);
        continue;
      }
      final url = await _fetchProductImageUrl(productId);
      enriched.add(item.copyWith(product_image_url: url));
    }
    return enriched;
  }

  Future<CartData> _finalizeCartData(CartData data) async {
    final normalized = _normalizeCartData(data);
    final items = await _enrichItemsWithImages(normalized.items ?? []);
    return CartData(
      grand_total: normalized.grand_total,
      total_items: normalized.total_items,
      items: items,
    );
  }

  Future<Result<CartData, Exception>> _getLocalCartData() async {
    final items = await _localDataSource.getCartItems();
    final totalItems = await _localDataSource.getCartItemCount();
    final grandTotal = await _localDataSource.getCartTotal();
    final data = await _finalizeCartData(
      CartData(
        grand_total: grandTotal,
        total_items: totalItems,
        items: items,
      ),
    );
    return Success(data);
  }

  // ─── Logged in: API CRUD ──────────────────────────────────────────────────

  Future<List<CartItem>> _fetchRemoteCartItems() async {
    final result = await _remoteDataSource.getCartItems();
    switch (result) {
      case Success<CartResponseModel, Exception>(:final data):
        return _normalizeCartData(
          data.data ??
              CartData(
                grand_total: 0,
                total_items: 0,
                items: const [],
              ),
        ).items ??
            <CartItem>[];
      case Failure<CartResponseModel, Exception>():
        return <CartItem>[];
    }
  }

  CartItem? _findRemoteItem(List<CartItem> items, int productId) {
    for (final item in items) {
      if (item.product_id == productId && (item.id ?? 0) > 0) {
        return item;
      }
    }
    return null;
  }

  /// Stable list order (by cart line id, then product id).
  CartData _normalizeCartData(CartData data) {
    final items = List<CartItem>.from(data.items ?? []);
    items.sort((a, b) {
      final aKey = a.id ?? a.product_id ?? 0;
      final bKey = b.id ?? b.product_id ?? 0;
      return aKey.compareTo(bKey);
    });
    return CartData(
      grand_total: data.grand_total,
      total_items: data.total_items,
      items: items,
    );
  }

  int? _resolveCartLineId(
    List<CartItem> remoteItems,
    int productId,
    int? cartLineId,
  ) {
    if (cartLineId != null && cartLineId > 0) {
      return cartLineId;
    }
    return _findRemoteItem(remoteItems, productId)?.id;
  }

  @override
  Future<Result<void, Exception>> addToCart(
    int productId,
    String productName,
    int productPrice, {
    String? productImageUrl,
  }) async {
    try {
      if (productImageUrl != null && productImageUrl.isNotEmpty) {
        _productImageCache[productId] = productImageUrl;
      }
      if (await _isLoggedIn) {
        final result = await _remoteDataSource.addToCart(productId);
        if (result is Failure<AddToCartResponseModel, Exception>) {
          return Failure<void, Exception>(result.error);
        }
        await _addToLocalCart(
          productId,
          productName,
          productPrice,
          productImageUrl: productImageUrl,
        );
        return Success(null);
      }
      return await _addToLocalCart(
        productId,
        productName,
        productPrice,
        productImageUrl: productImageUrl,
      );
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<CartData, Exception>> getCartItems() async {
    try {
      if (await _isLoggedIn) {
        final result = await _remoteDataSource.getCartItems();
        switch (result) {
          case Success<CartResponseModel, Exception>(:final data):
            final cartData = await _finalizeCartData(
              data.data ??
                  CartData(
                    grand_total: 0,
                    total_items: 0,
                    items: const [],
                  ),
            );
            return Success<CartData, Exception>(cartData);
          case Failure<CartResponseModel, Exception>(:final error):
            return Failure<CartData, Exception>(error);
        }
      }
      return await _getLocalCartData();
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> updateQuantity(
    int productId,
    int quantity, {
    int? cartLineId,
  }) async {
    try {
      if (!await _isLoggedIn) {
        await _localDataSource.updateQuantity(productId, quantity);
        return Success(null);
      }

      final lineId = cartLineId != null && cartLineId > 0
          ? cartLineId
          : _resolveCartLineId(
              await _fetchRemoteCartItems(),
              productId,
              null,
            );

      if (lineId == null) {
        return Failure<void, Exception>('Item not found in cart');
      }

      final result = await _remoteDataSource.updateCartQuantity(
        lineId,
        quantity,
      );
      if (result is Failure<UpdateQuantityResponseModel, Exception>) {
        return Failure<void, Exception>(result.error);
      }
      await _localDataSource.updateQuantity(productId, quantity);
      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> removeFromCart(
    int productId, {
    int? cartLineId,
  }) async {
    try {
      if (!await _isLoggedIn) {
        await _localDataSource.removeItem(productId);
        return Success(null);
      }

      final lineId = cartLineId != null && cartLineId > 0
          ? cartLineId
          : _resolveCartLineId(
              await _fetchRemoteCartItems(),
              productId,
              null,
            );

      if (lineId == null) {
        return Failure<void, Exception>('Item not found in cart');
      }

      final result = await _remoteDataSource.removeFromCart(lineId);
      if (result is Failure<void, Exception>) {
        return Failure<void, Exception>(result.error);
      }
      await _localDataSource.removeItem(productId);
      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void, Exception>> clearCart() async {
    try {
      if (await _isLoggedIn) {
        final result = await _remoteDataSource.clearCart();
        if (result is Failure<void, Exception>) {
          return Failure<void, Exception>(result.error);
        }
        await _localDataSource.clearCart();
        return Success(null);
      }

      await _localDataSource.clearCart();
      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  /// After login/register: merge SQLite cart into server. Local DB is kept for guest mode after logout.
  @override
  Future<Result<void, Exception>> syncCartToServer() async {
    try {
      if (_isSyncing) {
        return Success(null);
      }

      _isSyncing = true;

      if (!await _isLoggedIn) {
        return Success(null);
      }

      // ONLY UNSYNCED ITEMS
      final localItems =
      await _localDataSource.getUnsyncedCartItems();

      if (localItems.isEmpty) {
        return Success(null);
      }

      var remoteItems = await _fetchRemoteCartItems();

      for (final localItem in localItems) {
        final productId = localItem.product_id ?? 0;

        if (productId <= 0) continue;

        final localQty = localItem.quantity ?? 1;

        final existing = _findRemoteItem(
          remoteItems,
          productId,
        );

        if (existing != null) {
          final mergedQty = localQty;

          final updateResult =
          await _remoteDataSource.updateCartQuantity(
            existing.id ?? 0,
            mergedQty.toInt(),
          );

          if (updateResult
          is Failure<UpdateQuantityResponseModel, Exception>) {
            return Failure(updateResult.error);
          }
        } else {
          final addResult =
          await _remoteDataSource.addToCart(
            productId,
          );

          if (addResult
          is Failure<AddToCartResponseModel, Exception>) {
            return Failure(addResult.error);
          }

          if (localQty > 1) {
            remoteItems = await _fetchRemoteCartItems();

            final added = _findRemoteItem(
              remoteItems,
              productId,
            );

            if (added?.id != null) {
              final updateResult =
              await _remoteDataSource.updateCartQuantity(
                added!.id!,
                localQty,
              );

              if (updateResult
              is Failure<UpdateQuantityResponseModel, Exception>) {
                return Failure(updateResult.error);
              }
            }
          }
        }

        remoteItems = await _fetchRemoteCartItems();
      }

      // MARK ITEMS AS SYNCED
      await _localDataSource.markAllCartItemsSynced();

      // REFRESH LOCAL FROM SERVER
      await _syncLocalCartFromServer();

      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Updates SQLite to match server after login merge (no wipe — guest cart stays on logout).
  Future<void> _syncLocalCartFromServer() async {
    final remoteItems = await _fetchRemoteCartItems();

    await _localDataSource.clearCart();

    for (final remote in remoteItems) {
      final productId = remote.product_id;

      if (productId == null) continue;

      final localItem = CartItem(
        product_id: productId,
        product_name: remote.product_name ?? '',
        product_price: remote.product_price ?? 0,
        product_image_url: remote.product_image_url,
        quantity: remote.quantity ?? 1,
        total_price: remote.total_price ??
            ((remote.product_price ?? 0) *
                (remote.quantity ?? 1)),

        // IMPORTANT
        is_synced: 1,
      );

      await _localDataSource.addToCart(localItem);
    }
  }

  @override
  Future<bool> isProductInCart(int productId) async {
    if (await _isLoggedIn) {
      final items = await _fetchRemoteCartItems();
      return items.any((item) => item.product_id == productId);
    }
    return _localDataSource.isProductInCart(productId);
  }

  @override
  Future<int> getCartItemCount() async {
    if (await _isLoggedIn) {
      final result = await _remoteDataSource.getCartItems();
      if (result is Success<CartResponseModel, Exception>) {
        return result.data.data?.total_items ?? 0;
      }
      return 0;
    }
    return _localDataSource.getCartItemCount();
  }

  @override
  Future<int> getCartTotal() async {
    if (await _isLoggedIn) {
      final result = await _remoteDataSource.getCartItems();
      if (result is Success<CartResponseModel, Exception>) {
        return result.data.data?.grand_total ?? 0;
      }
      return 0;
    }
    return _localDataSource.getCartTotal();
  }
}
