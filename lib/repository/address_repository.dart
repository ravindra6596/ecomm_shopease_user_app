import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/address_request_model.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class AddressRepository {
  Future<Result<AddressResponseModel, Exception>> getAddressList();
  Future<Result<AddressDetailsResponseModel, Exception>> getAddressDetails(int id);
  Future<Result<AddressCreatedModel, Exception>> createAddress(AddressRequestModel addressRequestModel);
  Future<Result<AddressUpdatedModel, Exception>> updateAddress(int addId, AddressRequestModel addressRequestModel);
  Future<Result<AddressUpdatedModel, Exception>> updateOrderAddress(int id, UpdateOrderAddressRequest updateOrderAddressRequest);
  Future<Result<AddressUpdatedModel, Exception>> deleteAddress(int id);
}

@Injectable(as: AddressRepository)
class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<Result<AddressResponseModel, Exception>> getAddressList() async {
    try {
      final addressResponseModel = await apiClient.getAddressList();
      if (addressResponseModel.statusCode == 200) {
        return Success(addressResponseModel);
      } else {
        return Failure(addressResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }

  @override
  Future<Result<AddressDetailsResponseModel, Exception>> getAddressDetails(int id) async {
    try {
      final addressDetailsResponseModel = await apiClient.getAddressDetails(id);
      if (addressDetailsResponseModel.statusCode == 200) {
        return Success(addressDetailsResponseModel);
      } else {
        return Failure(addressDetailsResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }

  @override
  Future<Result<AddressCreatedModel, Exception>> createAddress(AddressRequestModel addressRequestModel) async {
    try {
      final createAddressModel = await apiClient.createAddress(addressRequestModel);
      if (createAddressModel.statusCode == 201) {
        return Success(createAddressModel);
      } else {
        return Failure(createAddressModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }

  @override
  Future<Result<AddressUpdatedModel, Exception>> updateAddress(int addId, AddressRequestModel addressRequestModel) async {
    try {
      final updateAddressModel = await apiClient.updateAddress(addId, addressRequestModel);
      if (updateAddressModel.statusCode == 200) {
        return Success(updateAddressModel);
      } else {
        return Failure(updateAddressModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
  @override
  Future<Result<AddressUpdatedModel, Exception>> updateOrderAddress(int id,UpdateOrderAddressRequest updateAddress) async {
    try {
      final updateAddressModel = await apiClient.updateOrderAddress(id,  UpdateOrderAddressRequest(address_id: updateAddress.address_id),);
      if (updateAddressModel.statusCode == 200) {
        return Success(updateAddressModel);
      } else {
        return Failure(updateAddressModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
  @override
  Future<Result<AddressUpdatedModel, Exception>> deleteAddress(int id) async {
    try {
      final addressDetailsResponseModel = await apiClient.deleteAddress(id);
      if (addressDetailsResponseModel.statusCode == 200) {
        return Success(addressDetailsResponseModel);
      } else {
        return Failure(addressDetailsResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
}
