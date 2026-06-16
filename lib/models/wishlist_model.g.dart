// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToWishlistRequestModel _$AddToWishlistRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddToWishlistRequestModel(
      product_id: (json['product_id'] as num).toInt(),
    );

Map<String, dynamic> _$AddToWishlistRequestModelToJson(
        AddToWishlistRequestModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
    };

AddToWishlistResponseModel _$AddToWishlistResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddToWishlistResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AddToWishlistResponseModelToJson(
        AddToWishlistResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

WishlistResponseModel _$WishlistResponseModelFromJson(
        Map<String, dynamic> json) =>
    WishlistResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WishlistResponseModelToJson(
        WishlistResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) => WishlistItem(
      id: (json['id'] as num?)?.toInt(),
      product_id: (json['product_id'] as num?)?.toInt(),
      product_name: json['product_name'] as String?,
      product_price: (json['product_price'] as num?)?.toInt(),
      is_synced: (json['is_synced'] as num?)?.toInt() ?? 0,
      product_image_url: json['product_image_url'] as String?,
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.product_id,
      'product_name': instance.product_name,
      'product_price': instance.product_price,
      'is_synced': instance.is_synced,
      'product_image_url': instance.product_image_url,
      'created_at': instance.created_at,
    };
