import 'package:json_annotation/json_annotation.dart';
part 'address_response_model.g.dart';

@JsonSerializable()
class AddressResponseModel {
  bool? status;
  int? statusCode;
  String? error;
  String? message;
  List<AddressData>? data;

  AddressResponseModel(
      {this.status, this.statusCode, this.error, this.message, this.data});

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressResponseModelToJson(this);
}

@JsonSerializable()
class AddressData {
  int? id;
  int? user_id;
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

  AddressData(
      {this.id,
      this.user_id,
      this.full_name,
      this.phone,
      this.address_line,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.is_default,
      this.address_type,
      this.latitude,
      this.longitude,
      });

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);
}
@JsonSerializable()
class AddressDetailsResponseModel {
  bool? status;
  int? statusCode;
  String? error;
  String? message;
  AddressData? data;

  AddressDetailsResponseModel(
      {this.status, this.statusCode, this.error, this.message, this.data});


  factory AddressDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddressDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDetailsResponseModelToJson(this);
}

@JsonSerializable()
class AddressCreatedModel {
  bool? status;
  int? statusCode;
  String? error;
  String? message;
  Map? data;

  AddressCreatedModel(
      {this.status, this.statusCode, this.error, this.message, this.data});

  factory AddressCreatedModel.fromJson(Map<String, dynamic> json) =>
      _$AddressCreatedModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressCreatedModelToJson(this);
}
@JsonSerializable()
class AddressUpdatedModel {
  bool? status;
  int? statusCode;
  String? error;
  String? message;
  Map? data;

  AddressUpdatedModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory AddressUpdatedModel.fromJson(Map<String, dynamic> json,
      ) =>  _$AddressUpdatedModelFromJson(json);

  Map<String, dynamic> toJson() =>  _$AddressUpdatedModelToJson(this);
}