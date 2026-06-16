// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopCategoryResponseModel _$TopCategoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    TopCategoryResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopCategoryResponseModelToJson(
        TopCategoryResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      category_id: (json['category_id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => CategoryImages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_id': instance.category_id,
      'category_name': instance.category_name,
      'images': instance.images,
    };

CategoriesResponseModel _$CategoriesResponseModelFromJson(
        Map<String, dynamic> json) =>
    CategoriesResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CategoriesData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoriesResponseModelToJson(
        CategoriesResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

CategoriesData _$CategoriesDataFromJson(Map<String, dynamic> json) =>
    CategoriesData(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total_pages: (json['total_pages'] as num?)?.toInt(),
      is_previous: json['is_previous'] as bool?,
      is_next: json['is_next'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesDataToJson(CategoriesData instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'total_pages': instance.total_pages,
      'is_previous': instance.is_previous,
      'is_next': instance.is_next,
      'items': instance.items,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => CategoryImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      products_count: (json['products_count'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      deletedBy: (json['deletedBy'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'images': instance.images,
      'products_count': instance.products_count,
      'isDeleted': instance.isDeleted,
      'deletedBy': instance.deletedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

CategoryImages _$CategoryImagesFromJson(Map<String, dynamic> json) =>
    CategoryImages(
      id: (json['id'] as num?)?.toInt(),
      image_url: json['image_url'] as String?,
    );

Map<String, dynamic> _$CategoryImagesToJson(CategoryImages instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.image_url,
    };

CategoryDetailsResponseModel _$CategoryDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    CategoryDetailsResponseModel(
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CategoryData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryDetailsResponseModelToJson(
        CategoryDetailsResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusCode': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => CategoryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      products_count: (json['products_count'] as num?)?.toInt(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      is_deleted: json['is_deleted'] as bool?,
      deleted_by: json['deleted_by'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'products_count': instance.products_count,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'is_deleted': instance.is_deleted,
      'deleted_by': instance.deleted_by,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

CategoryImage _$CategoryImageFromJson(Map<String, dynamic> json) =>
    CategoryImage(
      id: (json['id'] as num?)?.toInt(),
      image_url: json['image_url'] as String?,
    );

Map<String, dynamic> _$CategoryImageToJson(CategoryImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.image_url,
    };
