import 'package:e_comm_user/models/address_response_model.dart';

abstract class AddressState {}

class AddressInitialState extends AddressState {}

class AddressLoadingState extends AddressState {}

class AddressSuccessState extends AddressState {
  final AddressResponseModel addressResponseModel;
  // final int selectedIndex;
  final int selectedAddressId;
  AddressSuccessState(
    this.addressResponseModel,this.selectedAddressId
  );
}

class AddressDetailsLoadingState extends AddressState {}

class AddressDetailsSuccessState extends AddressState {
  final AddressDetailsResponseModel address;

  AddressDetailsSuccessState(
    this.address
  );
}

class AddressDetailsErrorState extends AddressState {
  final String error;

  AddressDetailsErrorState(this.error);
}
class AddressActionSuccessState extends AddressState {
  final String message;

  AddressActionSuccessState(this.message);
  List<Object> get props => [message];
}

class AddressErrorState extends AddressState {
  final String error;

  AddressErrorState(this.error);
}
