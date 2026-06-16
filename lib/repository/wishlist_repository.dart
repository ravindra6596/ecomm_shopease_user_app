import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/data/wishlist_data_source/wishlist_local_data_source.dart';
import 'package:e_comm_user/data/wishlist_data_source/wishlist_remote_data_source.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:e_comm_user/repository/product_repository.dart';
import 'package:injectable/injectable.dart';

abstract class WishlistRepository {
  Future<Result<void, Exception>> addToWishlist(
      int productId,
      String productName,
      int productPrice,
      int discount,
      int discountPrice,
      {
        String? productImageUrl,
      });

  Future<Result<List<WishlistItem>, Exception>>
  getWishlistItems();

  Future<Result<void, Exception>> removeFromWishlist(
      int productId, {
        int? wishlistItemId,
      });

  Future<Result<void, Exception>> clearWishlist();

  Future<Result<void, Exception>>
  syncWishlistToServer();

  Future<bool> isProductInWishlist(int productId);

  Future<int> getWishlistItemCount();
}
@Injectable(as: WishlistRepository)
class WishlistRepositoryImpl
    implements WishlistRepository {
  final WishlistLocalDataSource _localDataSource;

  final WishlistRemoteDataSource _remoteDataSource;

  final ProductRepository _productRepository;

  final Map<int, String> _productImageCache = {};

  bool _isSyncing = false;

  WishlistRepositoryImpl(
      this._localDataSource,
      this._remoteDataSource,
      this._productRepository,
      );

  Future<bool> get _isLoggedIn =>
      SharedPrefHelper.isLoggedIn();

  // ───────────────── LOCAL ─────────────────

  Future<Result<void, Exception>> _addToLocalWishlist(
      int productId,
      String productName,
      int productPrice,
      int discount,
      int discountPrice,
      {
        String? productImageUrl,
      }) async {
    final item = WishlistItem(
      product_id: productId,
      product_name: productName,
      product_price: productPrice,
      discount: discount,
      discount_price: discountPrice,
      product_image_url: productImageUrl,
    );

    await _localDataSource.addToWishlist(item);

    return Success(null);
  }

  Future<String?> _fetchProductImageUrl(
      int productId,
      ) async {
    if (_productImageCache.containsKey(productId)) {
      return _productImageCache[productId];
    }

    final result =
    await _productRepository.getProductDetails(
      productId,
    );

    if (result
    is Success<ProductDetailsResponseModel,
        Exception>) {
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

  Future<List<WishlistItem>>
  _enrichItemsWithImages(
      List<WishlistItem> items,
      ) async {
    final enriched = <WishlistItem>[];

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

      final url =
      await _fetchProductImageUrl(productId);

      enriched.add(
        item.copyWith(
          product_image_url: url,
        ),
      );
    }

    return enriched;
  }

  Future<Result<List<WishlistItem>, Exception>>
  _getLocalWishlistData() async {
    final items =
    await _localDataSource.getWishlistItems();

    final enriched =
    await _enrichItemsWithImages(items);

    return Success(enriched);
  }

  // ───────────────── REMOTE ─────────────────

  Future<List<WishlistItem>>
  _fetchRemoteWishlistItems() async {
    final result =
    await _remoteDataSource.getWishlistItems();

    switch (result) {
      case Success<WishlistResponseModel,
          Exception>(
          :final data
      ):
        return data.data ?? <WishlistItem>[];

      case Failure<WishlistResponseModel,
          Exception>():
        return <WishlistItem>[];
    }
  }

  WishlistItem? _findRemoteItem(
      List<WishlistItem> items,
      int productId,
      ) {
    for (final item in items) {
      if (item.product_id == productId &&
          (item.id ?? 0) > 0) {
        return item;
      }
    }

    return null;
  }

  int? _resolveWishlistItemId(
      List<WishlistItem> remoteItems,
      int productId,
      int? wishlistItemId,
      ) {
    if (wishlistItemId != null &&
        wishlistItemId > 0) {
      return wishlistItemId;
    }

    return _findRemoteItem(
      remoteItems,
      productId,
    )
        ?.id;
  }

  // ───────────────── ADD ─────────────────

  @override
  Future<Result<void, Exception>> addToWishlist(
      int productId,
      String productName,
      int productPrice,
      int discount,
      int discountPrice,
      {
        String? productImageUrl,
      }) async {
    try {
      if (productImageUrl != null &&
          productImageUrl.isNotEmpty) {
        _productImageCache[productId] =
            productImageUrl;
      }

      if (await _isLoggedIn) {
        final result =
        await _remoteDataSource.addToWishlist(
          productId,
        );

        if (result
        is Failure<
            AddToWishlistResponseModel,
            Exception>) {
          return Failure(result.error);
        }

        await _addToLocalWishlist(
          productId,
          productName,
          productPrice,
          discount,
          discountPrice,
          productImageUrl: productImageUrl,
        );

        return Success(null);
      }

      return await _addToLocalWishlist(
        productId,
        productName,
        productPrice,
        discount,
        discountPrice,
        productImageUrl: productImageUrl,
      );
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  // ───────────────── GET ─────────────────

  @override
  Future<Result<List<WishlistItem>, Exception>>
  getWishlistItems() async {
    try {
      if (await _isLoggedIn) {
        final result =
        await _remoteDataSource.getWishlistItems();

        switch (result) {
          case Success<WishlistResponseModel,
              Exception>(
              :final data
          ):
            final items =
            await _enrichItemsWithImages(
              data.data ?? [],
            );

            return Success(items);

          case Failure<WishlistResponseModel,
              Exception>(
              :final error
          ):
            return Failure(error);
        }
      }

      return await _getLocalWishlistData();
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  // ───────────────── REMOVE ─────────────────

  @override
  Future<Result<void, Exception>>
  removeFromWishlist(
      int productId, {
        int? wishlistItemId,
      }) async {
    try {
      if (!await _isLoggedIn) {
        await _localDataSource.removeItem(
          productId,
        );

        return Success(null);
      }

      final lineId = wishlistItemId != null &&
          wishlistItemId > 0
          ? wishlistItemId
          : _resolveWishlistItemId(
        await _fetchRemoteWishlistItems(),
        productId,
        null,
      );

      if (lineId == null) {
        return Failure(
          'Item not found in wishlist',
        );
      }

      final result =
      await _remoteDataSource
          .removeFromWishlist(lineId);

      if (result is Failure<void, Exception>) {
        return Failure(result.error);
      }

      await _localDataSource.removeItem(
        productId,
      );

      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  // ───────────────── CLEAR ─────────────────

  @override
  Future<Result<void, Exception>>
  clearWishlist() async {
    try {
      if (await _isLoggedIn) {
        final result =
        await _remoteDataSource
            .clearWishlist();

        if (result is Failure<void, Exception>) {
          return Failure(result.error);
        }

        await _localDataSource.clearWishlist();

        return Success(null);
      }

      await _localDataSource.clearWishlist();

      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

  // ───────────────── SYNC ─────────────────

  @override
  Future<Result<void, Exception>>
  syncWishlistToServer() async {
    try {
      if (_isSyncing) {
        return Success(null);
      }

      _isSyncing = true;

      if (!await _isLoggedIn) {
        return Success(null);
      }

      final localItems =
      await _localDataSource
          .getUnsyncedWishlistItems();

      if (localItems.isEmpty) {
        return Success(null);
      }

      var remoteItems =
      await _fetchRemoteWishlistItems();

      for (final localItem in localItems) {
        final productId =
            localItem.product_id ?? 0;

        if (productId <= 0) continue;

        final exists = _findRemoteItem(
          remoteItems,
          productId,
        );

        if (exists == null) {
          final addResult =
          await _remoteDataSource
              .addToWishlist(productId);

          if (addResult
          is Failure<
              AddToWishlistResponseModel,
              Exception>) {
            return Failure(addResult.error);
          }
        }

        remoteItems =
        await _fetchRemoteWishlistItems();
      }

      await _localDataSource
          .markAllWishlistItemsSynced();

      await _syncLocalWishlistFromServer();

      return Success(null);
    } on Exception catch (e) {
      return Failure(e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  // ───────────────── LOCAL REFRESH ─────────────────

  Future<void>
  _syncLocalWishlistFromServer() async {
    final remoteItems =
    await _fetchRemoteWishlistItems();

    await _localDataSource.clearWishlist();

    for (final remote in remoteItems) {
      final productId = remote.product_id;

      if (productId == null) continue;

      final localItem = WishlistItem(
        product_id: productId,
        product_name:
        remote.product_name ?? '',
        product_price:
        remote.product_price ?? 0,
        discount: remote.discount ?? 0,
        discount_price: remote.discount_price ?? 0,
        product_image_url:
        remote.product_image_url,
        is_synced: 1,
      );

      await _localDataSource.addToWishlist(
        localItem,
      );
    }
  }

  // ───────────────── HELPERS ─────────────────

  @override
  Future<bool> isProductInWishlist(
      int productId,
      ) async {
    if (await _isLoggedIn) {
      final items =
      await _fetchRemoteWishlistItems();

      return items.any(
            (item) => item.product_id == productId,
      );
    }

    return _localDataSource
        .isProductInWishlist(productId);
  }

  @override
  Future<int> getWishlistItemCount() async {
    if (await _isLoggedIn) {
      final result =
      await _remoteDataSource
          .getWishlistItems();

      if (result
      is Success<
          WishlistResponseModel,
          Exception>) {
        return result.data.data?.length ?? 0;
      }

      return 0;
    }

    return _localDataSource
        .getWishlistItemCount();
  }
}
