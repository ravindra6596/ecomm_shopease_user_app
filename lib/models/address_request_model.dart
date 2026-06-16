import 'package:json_annotation/json_annotation.dart';
part 'address_request_model.g.dart';
@JsonSerializable(includeIfNull: false,)
class AddressRequestModel {
  String? full_name;
  String? phone;
  String? address_line;
  String? city;
  String? state;
  String? country;
  String? pincode;
  bool? is_default;
  String? address_type;
  double? latitude;
  double? longitude;

  AddressRequestModel(
      {this.full_name,
        this.phone,
        this.address_line,
        this.city,
        this.state,
        this.country,
        this.pincode,
      this.is_default = false,
        this.address_type,
        this.latitude,
        this.longitude,
      });

  factory AddressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddressRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressRequestModelToJson(this);

}

@JsonSerializable()
class UpdateOrderAddressRequest {
  final int address_id;

  UpdateOrderAddressRequest({
    required this.address_id,
  });

  factory UpdateOrderAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderAddressRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateOrderAddressRequestToJson(this);
}