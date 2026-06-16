import 'package:e_comm_user/bloc/cart/cart_event.dart';
import 'package:e_comm_user/bloc/cart/cart_state.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/repository/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  List<CartItem> currentCartItems = [];
  bool isSyncing = false;
  CartBloc()
      : cartRepository = getIt<CartRepository>(),
        super(CartInitialState()) {
    on<AddToCartEvent>(addToCartMethod);
    on<GetCartItemsEvent>(getCartItemsMethod);
    on<UpdateQuantityEvent>(updateQuantityMethod);
    on<RemoveFromCartEvent>(removeFromCartMethod);
    on<ClearCartEvent>(clearCartMethod);
    on<SyncCartEvent>(syncCartMethod);
    // on<UserLoggedInEvent>(userLoggedInMethod);
    on<UserLoggedOutEvent>(userLoggedOutMethod);
  }

  addToCartMethod(AddToCartEvent event, emit) async {
    try {
      final result = await cartRepository.addToCart(
        event.productId,
        event.productName,
        event.productPrice,
        productImageUrl: event.productImageUrl,
      );

      switch (result) {
        case Success<void, Exception>():
          await _emitCartLoaded(
            emit,
            snackbarMessage: 'Item added to cart',
          );
          break;
        case Failure<void, Exception>():
          emit(CartErrorState(result.error.toString()));
          break;
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  getCartItemsMethod(GetCartItemsEvent event, emit) async {
    try {
      emit(CartLoadingState());
      final result = await cartRepository.getCartItems();

      switch (result) {
        case Success<CartData, Exception>():
          await _emitCartLoaded(emit, cartData: result.data);
          break;
        case Failure<CartData, Exception>():
          emit(CartErrorState(result.error.toString()));
          break;
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _emitCartLoaded(
    Emitter<CartState> emit, {
    CartData? cartData,
    String? snackbarMessage,
  }) async {
    CartData? data = cartData;
    if (data == null) {
      final result = await cartRepository.getCartItems();
      if (result is Failure<CartData, Exception>) {
        emit(CartErrorState(result.error.toString()));
        return;
      }
      data = (result as Success<CartData, Exception>).data;
    }

    currentCartItems = data.items ?? [];
    emit(CartLoadedState(
      currentCartItems,
      data.total_items ?? 0,
      data.grand_total ?? 0,
      snackbarMessage: snackbarMessage,
    ));
  }

  updateQuantityMethod(UpdateQuantityEvent event, emit) async {
    try {
      if (event.quantity < 1) {
        emit(CartErrorState('Quantity cannot be less than 1'));
        return;
      }

      final result = await cartRepository.updateQuantity(
        event.productId,
        event.quantity,
        cartLineId: event.cartLineId,
      );

      switch (result) {
        case Success<void, Exception>():
          await _emitCartLoaded(emit);
          break;
        case Failure<void, Exception>():
          emit(CartErrorState(result.error.toString()));
          break;
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  removeFromCartMethod(RemoveFromCartEvent event, emit) async {
    try {
      final result = await cartRepository.removeFromCart(
        event.productId,
        cartLineId: event.cartLineId,
      );

      switch (result) {
        case Success<void, Exception>():
          await _emitCartLoaded(emit);
          break;
        case Failure<void, Exception>():
          emit(CartErrorState(result.error.toString()));
          break;
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  clearCartMethod(ClearCartEvent event, emit) async {
    try {
      final result = await cartRepository.clearCart();

      switch (result) {
        case Success<void, Exception>():
          await _emitCartLoaded(emit);
          break;
        case Failure<void, Exception>():
          emit(CartErrorState(result.error.toString()));
          break;
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  syncCartMethod(SyncCartEvent event, emit) async {
    try {
      emit(SyncCartLoadingState());

      final result = await cartRepository.syncCartToServer();

      switch (result) {
        case Success<void, Exception>():
          emit(SyncCartSuccessState(
            'Cart synced successfully',
          ));

          add(GetCartItemsEvent());
          break;

        case Failure<void, Exception>():
          emit(SyncCartFailureState(
            result.error.toString(),
          ));
          break;
      }
    } catch (e) {
      emit(SyncCartFailureState(e.toString()));
    }
  }

  userLoggedInMethod(UserLoggedInEvent event, emit) async {
    await cartRepository.clearCart();
    add(SyncCartEvent());
  }

  userLoggedOutMethod(UserLoggedOutEvent event, emit) async {
    add(GetCartItemsEvent());
  }
}
