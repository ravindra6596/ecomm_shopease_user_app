import 'package:e_comm_user/models/address_request_model.dart';

abstract class AddressEvent {}

class AddressListEvent extends AddressEvent {
  AddressListEvent();
}

class AddressSelectEvent extends AddressEvent {
  final int addressId;
  // final int selectedIndex;

  AddressSelectEvent(
    this.addressId,
    // this.selectedIndex,
  );

  List<Object?> get props => [addressId, ];
}

class AddressDeleteEvent extends AddressEvent {
  final int addressId;

  AddressDeleteEvent(this.addressId);
}
class CreateAddressEvent extends AddressEvent {
  final AddressRequestModel addressRequestModel;
  CreateAddressEvent(this.addressRequestModel);
}

class UpdateAddressEvent extends AddressEvent {
  final int addressId;
  final AddressRequestModel addressRequestModel;

  UpdateAddressEvent(this.addressId, this.addressRequestModel);
}
class UpdateOrderAddressEvent extends AddressEvent {
  final int orderId;
  final int addressId;
  final AddressRequestModel addressRequestModel;

  UpdateOrderAddressEvent(this.orderId, this.addressId,this.addressRequestModel);
}