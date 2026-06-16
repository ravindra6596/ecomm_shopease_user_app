import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/address_request_model.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/repository/address_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'address_event.dart';
import 'address_state.dart';

@injectable
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository? addressRepository;
  List<AddressData> allAddresses = [];
  AddressData? selectedAddress;
  int? selectedAddressId;
  int selectedAddressIndex = 0;
   
  AddressBloc()
      : addressRepository = getIt<AddressRepository>(),
        super(AddressInitialState()) {
    on<AddressListEvent>(addressListMethod);
    on<AddressSelectEvent>(selectListAddress);
    on<CreateAddressEvent>(createAddress);
    on<UpdateAddressEvent>(updateAddress);
    on<UpdateOrderAddressEvent>(updateOrderAddress);
    on<AddressDeleteEvent>(deleteAddress);
  }
  /// ───────────────────────────────────────────────────────
  /// SELECT ADDRESS
  /// ───────────────────────────────────────────────────────

  Future<void> selectListAddress(AddressSelectEvent event, emit) async {

    if (state is! AddressSuccessState) return;

    final currentState = state as AddressSuccessState;

    selectedAddressId = event.addressId;
    // selectedAddressIndex = event.selectedIndex;
    /// STORE FULL OBJECT
    // selectedAddress = currentState.addressResponseModel.data?[event.selectedIndex];

    emit(
      AddressSuccessState(
        currentState.addressResponseModel,
        // selectedAddressIndex,
        selectedAddressId!,
      ),
    );
  }

  Future<void> addressListMethod(AddressListEvent event,  Emitter<AddressState> emit) async {

    emit(AddressLoadingState());

    final addressList = await addressRepository!.getAddressList();
    switch (addressList) {
    /// SUCCESS
      case Success<AddressResponseModel,Exception>():

      /// STORE LIST
        allAddresses = addressList.data.data ?? [];
        /// AUTO SELECT DEFAULT ADDRESS
        if (selectedAddressId == null && allAddresses.isNotEmpty) {

          int defaultIndex = allAddresses.indexWhere(
                (e) =>  e.is_default == true,
          );

          /// IF NO DEFAULT FOUND
          if (defaultIndex == -1) {
            defaultIndex = 0;
          }

          selectedAddressId =  allAddresses[defaultIndex].id;
          selectedAddressIndex = defaultIndex;
        }

        /// SELECTED ADDRESS OBJECT
        AddressData? selectedAddress;

        try {
          selectedAddress =
              allAddresses.firstWhere((e) =>
                // e.id == selectedAddressId,
                e.is_default == true
              );
        } catch (e) {
          selectedAddress = null;
        }

        emit(
          AddressSuccessState(
            addressList.data,
            // selectedAddressIndex,
            selectedAddress?.id ?? 0,
          ),
        );

        /// LOAD DETAILS AUTOMATICALLY
        if (selectedAddressId != null) {
          add(AddressSelectEvent(selectedAddressId!, ));
        }

        break;

    /// FAILURE
      case Failure<AddressResponseModel, Exception>():
        emit(
          AddressErrorState(addressList.error.toString()),
        );
        break;
    }
  }
  /// CREATE ADDRESS
  Future<void> createAddress(CreateAddressEvent event, emit) async {
    emit(AddressLoadingState());

    final result = await addressRepository!.createAddress(event.addressRequestModel);

    switch (result) {
      case Success<AddressCreatedModel, Exception>():
        final addressData = result.data;
        emit(AddressActionSuccessState(addressData.message ?? 'Address Created'));
        break;
      case Failure<AddressCreatedModel, Exception>():
        emit(AddressErrorState(result.error.toString()));
        break;
    }
  }
  /// UPDATE ADDRESS
  Future<void> updateAddress(UpdateAddressEvent event,emit) async {
    emit(AddressLoadingState());
    final result = await addressRepository!.updateAddress(
      event.addressId,
      event.addressRequestModel,
    );
    switch (result) {
      case Success<AddressUpdatedModel, Exception>():
        final addressData = result.data;
        emit(AddressActionSuccessState(addressData.message ?? 'Address Updated'));
        break;
      case Failure<AddressUpdatedModel, Exception>():
        emit(AddressErrorState(result.error));
        break;
    }
  }
  /// UPDATE ORDER ADDRESS
  Future<void> updateOrderAddress(UpdateOrderAddressEvent event,emit) async {
    emit(AddressLoadingState());
    final result = await addressRepository!.updateOrderAddress(
      event.orderId,
      UpdateOrderAddressRequest(address_id: event.addressId),
    );
    switch (result) {
      case Success<AddressUpdatedModel, Exception>():
        final addressData = result.data;
        emit(AddressActionSuccessState(addressData.message ?? 'Address Updated'));
        break;
      case Failure<AddressUpdatedModel, Exception>():
        emit(AddressErrorState(result.error));
        break;
    }
  }
  /// UPDATE ORDER ADDRESS
  Future<void> deleteAddress(AddressDeleteEvent event,emit) async {
    emit(AddressLoadingState());
    final result = await addressRepository!.deleteAddress(event.addressId);
    switch (result) {
      case Success<AddressUpdatedModel, Exception>():
        final addressData = result.data;
        emit(AddressActionSuccessState(addressData.message ?? 'Address Deleted'));
        break;
      case Failure<AddressUpdatedModel, Exception>():
        emit(AddressErrorState(result.error));
        break;
    }
  }
}
