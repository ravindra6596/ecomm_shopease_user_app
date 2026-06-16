import 'package:e_comm_user/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address_response_model.dart';

part 'home_response_model.g.dart';

@JsonSerializable()
class HomeResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final HomeData? data;

  HomeResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseModelToJson(this);
}

@JsonSerializable()
class HomeData {
  final AddressData? delivery_address;
  final List<BannerModel>? banners;
  final List<TopCategory>? top_categories;
  final List<Product>? featured_products;
  final List<Product>? trending_products;
  final List<Product>? popular_products;
  final List<Product>? new_arrivals;
  final List<TopCategoryProducts>? top_category_products;

  HomeData({
    this.delivery_address,
    this.banners,
    this.top_categories,
    this.trending_products,
    this.featured_products,
    this.popular_products,
    this.new_arrivals,
    this.top_category_products,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}

@JsonSerializable()
class BannerModel {
  int? bannerId;
  String? title;
  String? description;
  String? image_url;
  String? category_image_url;
  int? category_id;
  String? category_name;
  bool? is_active;
  String? created_at;
  BannerModel({
    this.bannerId,
    this.title,
    this.description,
    this.image_url,
    this.category_image_url,
    this.category_id,
    this.category_name,
    this.is_active,
    this.created_at,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

@JsonSerializable()
class TopCategory {
  final int? category_id;
  final String? category_name;
  final int? total_quantity;
  final num? total_sales;
  final double? sales_percentage;

  TopCategory({
    this.category_id,
    this.category_name,
    this.total_quantity,
    this.total_sales,
    this.sales_percentage,
  });

  factory TopCategory.fromJson(Map<String, dynamic> json) =>
      _$TopCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TopCategoryToJson(this);
}


@JsonSerializable()
class TopCategoryProducts {
  final int? category_id;
  final String? category_name;
  final List<Product>? products;

  TopCategoryProducts({
    this.category_id,
    this.category_name,
    this.products,
  });

  factory TopCategoryProducts.fromJson(Map<String, dynamic> json) =>
      _$TopCategoryProductsFromJson(json);

  Map<String, dynamic> toJson() => _$TopCategoryProductsToJson(this);
}