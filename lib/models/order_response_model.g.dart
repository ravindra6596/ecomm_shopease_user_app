// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponseModel _$OrderResponseModelFromJson(Map<String, dynamic> json) =>
    OrderResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'],
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseModelToJson(OrderResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total_pages: (json['total_pages'] as num?)?.toInt(),
      is_previous: json['is_previous'] as bool?,
      is_next: json['is_next'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItems.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'total_pages': instance.total_pages,
      'is_previous': instance.is_previous,
      'is_next': instance.is_next,
      'items': instance.items,
    };

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) => OrderItems(
      id: (json['id'] as num?)?.toInt(),
      user_name: json['user_name'] as String?,
      user_id: (json['user_id'] as num?)?.toInt(),
      address_id: (json['address_id'] as num?)?.toInt(),
      total_amount: (json['total_amount'] as num?)?.toInt(),
      status: json['status'] as String?,
      payment_status: json['payment_status'] as String?,
      payment_method: json['payment_method'] as String?,
      created_at: json['created_at'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ProductItems.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: json['address'] == null
          ? null
          : AddressData.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.user_name,
      'user_id': instance.user_id,
      'address_id': instance.address_id,
      'total_amount': instance.total_amount,
      'status': instance.status,
      'payment_status': instance.payment_status,
      'payment_method': instance.payment_method,
      'created_at': instance.created_at,
      'items': instance.items,
      'address': instance.address,
    };

ProductItems _$ProductItemsFromJson(Map<String, dynamic> json) => ProductItems(
      product_id: (json['product_id'] as num?)?.toInt(),
      product_name: json['product_name'] as String?,
      image_url: json['image_url'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      total_price: (json['total_price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductItemsToJson(ProductItems instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'product_name': instance.product_name,
      'image_url': instance.image_url,
      'quantity': instance.quantity,
      'price': instance.price,
      'total_price': instance.total_price,
    };

OrderDetailsResponseModel _$OrderDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    OrderDetailsResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OrderItems.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDetailsResponseModelToJson(
        OrderDetailsResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };
