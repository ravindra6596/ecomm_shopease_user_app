import 'package:json_annotation/json_annotation.dart';

import 'product_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class TopCategoryResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final List<Category>? data;

  TopCategoryResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory TopCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TopCategoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopCategoryResponseModelToJson(this);
}

@JsonSerializable()
class Category {
  final int? category_id;
  final String? category_name;
  List<CategoryImages>? images;

  Category({
    this.category_id,
    this.category_name,
    this.images,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoriesResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final CategoriesData? data;

  CategoriesResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseModelToJson(this);
}

@JsonSerializable()
class CategoriesData {
  final int? total;
  final int? page;
  final int? limit;
  final int? total_pages;
  final bool? is_previous;
  final bool? is_next;
  final List<Categories>? items;

  CategoriesData({
    this.total,
    this.page,
    this.limit,
    this.total_pages,
    this.is_previous,
    this.is_next,
    this.items,
  });

  factory CategoriesData.fromJson(Map<String, dynamic> json) =>
      _$CategoriesDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesDataToJson(this);
}

@JsonSerializable()
class Categories {
  int? id;
  String? name;
  List<CategoryImages>? images;
  int? products_count;
  bool? isDeleted;
  int? deletedBy;
  String? createdAt;
  String? updatedAt;

  Categories(
      {this.id,
      this.name,
      this.images,
      this.products_count,
      this.isDeleted,
      this.deletedBy,
      this.createdAt,
      this.updatedAt});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}

@JsonSerializable()
class CategoryImages {
  int? id;
  String? image_url;

  CategoryImages({this.id, this.image_url});

  factory CategoryImages.fromJson(Map<String, dynamic> json) =>
      _$CategoryImagesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryImagesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryDetailsResponseModel {
  bool? status;
  int? statusCode;
  String? error;
  String? message;
  CategoryData? data;

  CategoryDetailsResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory CategoryDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoryDetailsResponseModelToJson(this);
}
@JsonSerializable(explicitToJson: true)
class CategoryData {
  int? id;
  String? name;
  List<CategoryImage>? images;
  int? products_count;
  List<Product>? products;
  bool? is_deleted;
  String? deleted_by;
  String? created_at;
  String? updated_at;

  CategoryData({
    this.id,
    this.name,
    this.images,
    this.products_count,
    this.products,
    this.is_deleted,
    this.deleted_by,
    this.created_at,
    this.updated_at,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}
@JsonSerializable()
class CategoryImage {
  int? id;
  String? image_url;

  CategoryImage({
    this.id,
    this.image_url,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) =>
      _$CategoryImageFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryImageToJson(this);
}