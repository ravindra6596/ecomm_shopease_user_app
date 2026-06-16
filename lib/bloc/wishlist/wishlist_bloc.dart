import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:e_comm_user/repository/wishlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


import 'wishlist_event.dart';
import 'wishlist_state.dart';

@lazySingleton
class WishlistBloc
    extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;

  List<WishlistItem> currentWishlistItems = [];

  bool isSyncing = false;

  WishlistBloc()
      : wishlistRepository =
  getIt<WishlistRepository>(),
        super(WishlistInitialState()) {
    on<AddToWishlistEvent>(
      addToWishlistMethod,
    );

    on<GetWishlistItemsEvent>(
      getWishlistItemsMethod,
    );

    on<RemoveFromWishlistEvent>(
      removeFromWishlistMethod,
    );

    on<ClearWishlistEvent>(
      clearWishlistMethod,
    );

    on<SyncWishlistEvent>(
      syncWishlistMethod,
    );

    on<UserLoggedOutWishlistEvent>(
      userLoggedOutMethod,
    );
  }

  addToWishlistMethod(
      AddToWishlistEvent event,
      emit,
      ) async {
    try {
      final result =
      await wishlistRepository.addToWishlist(
        event.productId,
        event.productName,
        event.productPrice,
        productImageUrl:
        event.productImageUrl,
      );

      switch (result) {
        case Success<void, Exception>():
          await _emitWishlistLoaded(
            emit,
            snackbarMessage:
            'Item added to wishlist',
          );
          break;

        case Failure<void, Exception>():
          emit(
            WishlistErrorState(
              result.error.toString(),
            ),
          );
          break;
      }
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }

  getWishlistItemsMethod(
      GetWishlistItemsEvent event,
      emit,
      ) async {
    try {
      emit(WishlistLoadingState());

      final result =
      await wishlistRepository
          .getWishlistItems();

      switch (result) {
        case Success<List<WishlistItem>,
            Exception>(
            :final data
        ):
          currentWishlistItems = data;

          emit(
            WishlistLoadedState(data),
          );
          break;

        case Failure<List<WishlistItem>,
            Exception>(
            :final error
        ):
          emit(
            WishlistErrorState(
              error.toString(),
            ),
          );
          break;
      }
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }

  Future<void> _emitWishlistLoaded(
      Emitter<WishlistState> emit, {
        String? snackbarMessage,
      }) async {
    final result =
    await wishlistRepository
        .getWishlistItems();

    switch (result) {
      case Success<List<WishlistItem>,
          Exception>(
          :final data
      ):
        currentWishlistItems = data;

        emit(
          WishlistLoadedState(
            data,
            snackbarMessage:
            snackbarMessage,
          ),
        );
        break;

      case Failure<List<WishlistItem>,
          Exception>(
          :final error
      ):
        emit(
          WishlistErrorState(
            error.toString(),
          ),
        );
        break;
    }
  }

  removeFromWishlistMethod(
      RemoveFromWishlistEvent event,
      emit,
      ) async {
    try {
      final result =
      await wishlistRepository
          .removeFromWishlist(
        event.productId,
        wishlistItemId:
        event.wishlistItemId,
      );

      switch (result) {
        case Success<void, Exception>():
          await _emitWishlistLoaded(emit);
          break;

        case Failure<void, Exception>():
          emit(
            WishlistErrorState(
              result.error.toString(),
            ),
          );
          break;
      }
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }

  clearWishlistMethod(
      ClearWishlistEvent event,
      emit,
      ) async {
    try {
      final result =
      await wishlistRepository
          .clearWishlist();

      switch (result) {
        case Success<void, Exception>():
          await _emitWishlistLoaded(emit);
          break;

        case Failure<void, Exception>():
          emit(
            WishlistErrorState(
              result.error.toString(),
            ),
          );
          break;
      }
    } catch (e) {
      emit(WishlistErrorState(e.toString()));
    }
  }

  syncWishlistMethod(
      SyncWishlistEvent event,
      emit,
      ) async {
    try {
      emit(SyncWishlistLoadingState());

      final result =
      await wishlistRepository
          .syncWishlistToServer();

      switch (result) {
        case Success<void, Exception>():
          emit(
            SyncWishlistSuccessState(
              'Wishlist synced successfully',
            ),
          );

          add(GetWishlistItemsEvent());

          break;

        case Failure<void, Exception>():
          emit(
            SyncWishlistFailureState(
              result.error.toString(),
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        SyncWishlistFailureState(
          e.toString(),
        ),
      );
    }
  }

  userLoggedOutMethod(
      UserLoggedOutWishlistEvent event,
      emit,
      ) async {
    add(GetWishlistItemsEvent());
  }
}