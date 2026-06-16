// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) =>
    OrderRequestModel(
      address_id: (json['address_id'] as num?)?.toInt(),
      payment_method: json['payment_method'] as String?,
    );

Map<String, dynamic> _$OrderRequestModelToJson(OrderRequestModel instance) =>
    <String, dynamic>{
      'address_id': instance.address_id,
      'payment_method': instance.payment_method,
    };

OrderCreateModel _$OrderCreateModelFromJson(Map<String, dynamic> json) =>
    OrderCreateModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderPlacedData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderCreateModelToJson(OrderCreateModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

OrderPlacedData _$OrderPlacedDataFromJson(Map<String, dynamic> json) =>
    OrderPlacedData(
      order_id: (json['order_id'] as num?)?.toInt(),
      payment_method: json['payment_method'] as String?,
      order_date: json['order_date'] as String?,
      delivery_date: json['delivery_date'] as String?,
    );

Map<String, dynamic> _$OrderPlacedDataToJson(OrderPlacedData instance) =>
    <String, dynamic>{
      'order_id': instance.order_id,
      'payment_method': instance.payment_method,
      'order_date': instance.order_date,
      'delivery_date': instance.delivery_date,
    };
