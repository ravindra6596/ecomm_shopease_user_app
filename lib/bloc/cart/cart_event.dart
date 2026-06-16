abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int productId;
  final String productName;
  final int productPrice;
  final int discount;
  final int discountPrice;
  final String? productImageUrl;
  AddToCartEvent(
    this.productId,
    this.productName,
    this.productPrice,
      this.discount,
      this.discountPrice,
      {
    this.productImageUrl,
  });
}

class GetCartItemsEvent extends CartEvent {}

class UpdateQuantityEvent extends CartEvent {
  final int productId;
  final int quantity;
  /// Server cart line id (CartItem.id). Required for logged-in API updates.
  final int? cartLineId;
  UpdateQuantityEvent(
    this.productId,
    this.quantity, {
    this.cartLineId,
  });
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  /// Server cart line id (CartItem.id). Required for logged-in API delete.
  final int? cartLineId;
  RemoveFromCartEvent(
    this.productId, {
    this.cartLineId,
  });
}

class ClearCartEvent extends CartEvent {}

class SyncCartEvent extends CartEvent {}

class UserLoggedInEvent extends CartEvent {}

class UserLoggedOutEvent extends CartEvent {}
