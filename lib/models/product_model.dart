import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final ProductData? data;

  ProductResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseModelToJson(this);
}

@JsonSerializable()
class ProductData {
  final int? total;
  final int? page;
  final int? limit;
  final int? total_pages;
  final bool? is_previous;
  final bool? is_next;
  final List<Product>? items;

  ProductData({
    this.total,
    this.page,
    this.limit,
    this.total_pages,
    this.is_previous,
    this.is_next,
    this.items,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}

@JsonSerializable()
class Product {
  final int? id;
  final String? name;
  final String? description;
  final int? price;
  final int? discount;
  final int? discount_price;
  final String? return_policy;
  final int? category_id;
  final String? category_name;
  final List<ProductImage>? images;
  final bool? is_deleted;
  final bool? is_featured;
  final int? created_by;
  final int? deleted_by;
  final String? created_at;
  final String? updated_at;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discount,
    this.discount_price,
    this.return_policy,
    this.category_id,
    this.category_name,
    this.images,
    this.is_deleted,
    this.is_featured,
    this.created_by,
    this.deleted_by,
    this.created_at,
    this.updated_at,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class ProductImage {
  final int? id;
  final String? image_url;

  ProductImage({
    this.id,
    this.image_url,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}

@JsonSerializable()
class ProductDetailsResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final Product? data;

  ProductDetailsResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsResponseModelToJson(this);
}
class ProductFilterModel {
  final double min_price;
  final double max_price;

  final String? sort_by;
  final String? order;

  final bool isFilterApplied;

  const ProductFilterModel({
    this.min_price = 0,
    this.max_price = 50000,
    this.sort_by,
    this.order,
    this.isFilterApplied = false,
  });

  ProductFilterModel copyWith({
    double? min_price,
    double? max_price,
    String? sort_by,
    String? order,
    bool? isFilterApplied,
  }) {
    return ProductFilterModel(
      min_price: min_price ?? this.min_price,
      max_price: max_price ?? this.max_price,
      sort_by: sort_by ?? this.sort_by,
      order: order ?? this.order,
      isFilterApplied:
      isFilterApplied ?? this.isFilterApplied,
    );
  }
}