// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartRequestModel _$AddToCartRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddToCartRequestModel(
      product_id: (json['product_id'] as num).toInt(),
    );

Map<String, dynamic> _$AddToCartRequestModelToJson(
        AddToCartRequestModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
    };

AddToCartResponseModel _$AddToCartResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddToCartResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AddToCartResponseModelToJson(
        AddToCartResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

CartResponseModel _$CartResponseModelFromJson(Map<String, dynamic> json) =>
    CartResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CartData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartResponseModelToJson(CartResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

CartData _$CartDataFromJson(Map<String, dynamic> json) => CartData(
      grand_total: (json['grand_total'] as num?)?.toInt(),
      total_items: (json['total_items'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'grand_total': instance.grand_total,
      'total_items': instance.total_items,
      'items': instance.items,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      id: (json['id'] as num?)?.toInt(),
      cart_id: (json['cart_id'] as num?)?.toInt(),
      product_id: (json['product_id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      product_name: json['product_name'] as String?,
      product_price: (json['product_price'] as num?)?.toInt(),
      is_synced: (json['is_synced'] as num?)?.toInt() ?? 0,
      total_price: (json['total_price'] as num?)?.toInt(),
      product_image_url: json['product_image_url'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'cart_id': instance.cart_id,
      'product_id': instance.product_id,
      'quantity': instance.quantity,
      'product_name': instance.product_name,
      'product_price': instance.product_price,
      'total_price': instance.total_price,
      'is_synced': instance.is_synced,
      'product_image_url': instance.product_image_url,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

UpdateQuantityRequestModel _$UpdateQuantityRequestModelFromJson(
        Map<String, dynamic> json) =>
    UpdateQuantityRequestModel(
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateQuantityRequestModelToJson(
        UpdateQuantityRequestModel instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
    };

UpdateQuantityResponseModel _$UpdateQuantityResponseModelFromJson(
        Map<String, dynamic> json) =>
    UpdateQuantityResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UpdateQuantityResponseModelToJson(
        UpdateQuantityResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };
