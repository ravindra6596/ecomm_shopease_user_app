import 'package:e_comm_user/models/wishlist_model.dart';

abstract class WishlistState {}

class WishlistInitialState extends WishlistState {}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {
  final List<WishlistItem> items;

  final String? snackbarMessage;

  WishlistLoadedState(
      this.items, {
        this.snackbarMessage,
      });
}

class WishlistErrorState extends WishlistState {
  final String error;

  WishlistErrorState(this.error);
}

class AddToWishlistSuccessState extends WishlistState {
  final String message;

  AddToWishlistSuccessState(this.message);
}

class RemoveFromWishlistSuccessState
    extends WishlistState {}

class ClearWishlistSuccessState
    extends WishlistState {}

class SyncWishlistLoadingState
    extends WishlistState {}

class SyncWishlistSuccessState
    extends WishlistState {
  final String message;

  SyncWishlistSuccessState(this.message);
}

class SyncWishlistFailureState
    extends WishlistState {
  final String error;

  SyncWishlistFailureState(this.error);
}