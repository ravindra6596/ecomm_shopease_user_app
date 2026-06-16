// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponseModel _$HomeResponseModelFromJson(Map<String, dynamic> json) =>
    HomeResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : HomeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeResponseModelToJson(HomeResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      delivery_address: json['delivery_address'] == null
          ? null
          : AddressData.fromJson(
              json['delivery_address'] as Map<String, dynamic>),
      banners: (json['banners'] as List<dynamic>?)
          ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      top_categories: (json['top_categories'] as List<dynamic>?)
          ?.map((e) => TopCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      trending_products: (json['trending_products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      featured_products: (json['featured_products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      popular_products: (json['popular_products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      new_arrivals: (json['new_arrivals'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      top_category_products: (json['top_category_products'] as List<dynamic>?)
          ?.map((e) => TopCategoryProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'delivery_address': instance.delivery_address,
      'banners': instance.banners,
      'top_categories': instance.top_categories,
      'featured_products': instance.featured_products,
      'trending_products': instance.trending_products,
      'popular_products': instance.popular_products,
      'new_arrivals': instance.new_arrivals,
      'top_category_products': instance.top_category_products,
    };

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      bannerId: (json['bannerId'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      image_url: json['image_url'] as String?,
      category_image_url: json['category_image_url'] as String?,
      category_id: (json['category_id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      is_active: json['is_active'] as bool?,
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'bannerId': instance.bannerId,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.image_url,
      'category_image_url': instance.category_image_url,
      'category_id': instance.category_id,
      'category_name': instance.category_name,
      'is_active': instance.is_active,
      'created_at': instance.created_at,
    };

TopCategory _$TopCategoryFromJson(Map<String, dynamic> json) => TopCategory(
      category_id: (json['category_id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      total_quantity: (json['total_quantity'] as num?)?.toInt(),
      total_sales: json['total_sales'] as num?,
      sales_percentage: (json['sales_percentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TopCategoryToJson(TopCategory instance) =>
    <String, dynamic>{
      'category_id': instance.category_id,
      'category_name': instance.category_name,
      'total_quantity': instance.total_quantity,
      'total_sales': instance.total_sales,
      'sales_percentage': instance.sales_percentage,
    };

TopCategoryProducts _$TopCategoryProductsFromJson(Map<String, dynamic> json) =>
    TopCategoryProducts(
      category_id: (json['category_id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopCategoryProductsToJson(
        TopCategoryProducts instance) =>
    <String, dynamic>{
      'category_id': instance.category_id,
      'category_name': instance.category_name,
      'products': instance.products,
    };
