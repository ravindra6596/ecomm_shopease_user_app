import 'package:json_annotation/json_annotation.dart';
part 'order_request_model.g.dart';
@JsonSerializable()
class OrderRequestModel {
  int? address_id;
  String? payment_method;

  OrderRequestModel({
    this.address_id,
    this.payment_method,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestModelToJson(this);
}

@JsonSerializable()
class OrderCreateModel {
  bool? status;
  int? statusCode;
  String? error;
  String? message;
  OrderPlacedData? data;

  OrderCreateModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory OrderCreateModel.fromJson(Map<String, dynamic> json,
      ) =>  _$OrderCreateModelFromJson(json);

  Map<String, dynamic> toJson() =>  _$OrderCreateModelToJson(this);
}
@JsonSerializable()
class OrderPlacedData {
  int? order_id;
  String? payment_method;
  String? order_date;
  String? delivery_date;

  OrderPlacedData({
    this.order_id,
    this.payment_method,
    this.order_date,
    this.delivery_date,
  });

  factory OrderPlacedData.fromJson(Map<String, dynamic> json) =>
      _$OrderPlacedDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPlacedDataToJson(this);
}