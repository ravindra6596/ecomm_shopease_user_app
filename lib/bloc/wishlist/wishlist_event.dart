abstract class WishlistEvent {}

class AddToWishlistEvent extends WishlistEvent {
  final int productId;
  final String productName;
  final int productPrice;
  final int discount;
  final int discountPrice;
  final String? productImageUrl;

  AddToWishlistEvent(
      this.productId,
      this.productName,
      this.productPrice,
      this.discount,
      this.discountPrice,
      {
        this.productImageUrl,
      });
}

class GetWishlistItemsEvent extends WishlistEvent {}

class RemoveFromWishlistEvent extends WishlistEvent {
  final int productId;

  /// Server wishlist item id
  final int? wishlistItemId;

  RemoveFromWishlistEvent(
      this.productId, {
        this.wishlistItemId,
      });
}

class ClearWishlistEvent extends WishlistEvent {}

class SyncWishlistEvent extends WishlistEvent {}

class UserLoggedInWishlistEvent extends WishlistEvent {}
class UserLoggedOutWishlistEvent extends WishlistEvent {}