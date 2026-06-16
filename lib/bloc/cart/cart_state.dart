import 'package:e_comm_user/models/cart_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItem> items;
  final int totalItems;
  final int grandTotal;
  final int discountTotal;
  /// One-shot message for snackbar (e.g. after add to cart). Cart tab ignores this.
  final String? snackbarMessage;

  CartLoadedState(
    this.items,
    this.totalItems,
    this.grandTotal,
    this.discountTotal,
      {
    this.snackbarMessage,
  });
}

class CartErrorState extends CartState {
  final String error;
  CartErrorState(this.error);
}

class AddToCartSuccessState extends CartState {
  final String message;
  AddToCartSuccessState(this.message);
}

class UpdateQuantitySuccessState extends CartState {}

class RemoveFromCartSuccessState extends CartState {}

class ClearCartSuccessState extends CartState {}

class SyncCartLoadingState extends CartState {}

class SyncCartSuccessState extends CartState {
  final String message;
  SyncCartSuccessState(this.message);
}

class SyncCartFailureState extends CartState {
  final String error;
  SyncCartFailureState(this.error);
}
