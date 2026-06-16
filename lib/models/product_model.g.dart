// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponseModel _$ProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProductResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProductData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductResponseModelToJson(
        ProductResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total_pages: (json['total_pages'] as num?)?.toInt(),
      is_previous: json['is_previous'] as bool?,
      is_next: json['is_next'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'total_pages': instance.total_pages,
      'is_previous': instance.is_previous,
      'is_next': instance.is_next,
      'items': instance.items,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toInt(),
      discount: (json['discount'] as num?)?.toInt(),
      discount_price: (json['discount_price'] as num?)?.toInt(),
      return_policy: json['return_policy'] as String?,
      category_id: (json['category_id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      is_deleted: json['is_deleted'] as bool?,
      is_featured: json['is_featured'] as bool?,
      created_by: (json['created_by'] as num?)?.toInt(),
      deleted_by: (json['deleted_by'] as num?)?.toInt(),
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'discount': instance.discount,
      'discount_price': instance.discount_price,
      'return_policy': instance.return_policy,
      'category_id': instance.category_id,
      'category_name': instance.category_name,
      'images': instance.images,
      'is_deleted': instance.is_deleted,
      'is_featured': instance.is_featured,
      'created_by': instance.created_by,
      'deleted_by': instance.deleted_by,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
      id: (json['id'] as num?)?.toInt(),
      image_url: json['image_url'] as String?,
    );

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.image_url,
    };

ProductDetailsResponseModel _$ProductDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProductDetailsResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Product.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDetailsResponseModelToJson(
        ProductDetailsResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };
