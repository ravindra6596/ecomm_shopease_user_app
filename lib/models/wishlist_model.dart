import 'package:json_annotation/json_annotation.dart';
part 'wishlist_model.g.dart';
@JsonSerializable()
class AddToWishlistRequestModel {
  final int product_id;

  AddToWishlistRequestModel({
    required this.product_id,
  });

  factory AddToWishlistRequestModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$AddToWishlistRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AddToWishlistRequestModelToJson(this);
}
@JsonSerializable()
class AddToWishlistResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final Map<String, dynamic>? data;

  AddToWishlistResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory AddToWishlistResponseModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$AddToWishlistResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AddToWishlistResponseModelToJson(this);
}
@JsonSerializable()
class WishlistResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final List<WishlistItem>? data;

  WishlistResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory WishlistResponseModel.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$WishlistResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$WishlistResponseModelToJson(this);
}
@JsonSerializable()
class WishlistItem {
  final int? id;
  final int? product_id;
  final String? product_name;
  final int? product_price;
  final int is_synced;
  final String? product_image_url;
  final String? created_at;

  WishlistItem({
    this.id,
    this.product_id,
    this.product_name,
    this.product_price,
    this.is_synced = 0,
    this.product_image_url,
    this.created_at,
  });

  factory WishlistItem.fromJson(
      Map<String, dynamic> json,
      ) {
    final item = _$WishlistItemFromJson(json);

    return WishlistItem(
      id: item.id,
      product_id: item.product_id,
      product_name: item.product_name,
      product_price: item.product_price,
      product_image_url:
      json['product_image_url'] ??
          json['image_url'],
      created_at: item.created_at,
      is_synced: item.is_synced,
    );
  }

  Map<String, dynamic> toJson() =>
      _$WishlistItemToJson(this);

  factory WishlistItem.fromLocalDb(
      Map<String, dynamic> row,
      ) =>
      WishlistItem(
        id: row['id'],
        product_id: row['product_id'],
        product_name: row['product_name'],
        product_price: row['product_price'],
        product_image_url:
        row['product_image_url'],
        is_synced: row['is_synced'] ?? 0,
        created_at: row['created_at'],
      );

  Map<String, dynamic> toLocalDbMap() => {
    'product_id': product_id,
    'product_name': product_name,
    'product_price': product_price,
    'product_image_url': product_image_url,
    'is_synced': is_synced,
    'created_at':
    created_at ??
        DateTime.now().toIso8601String(),
    'updated_at':
    DateTime.now().toIso8601String(),
  };
  WishlistItem copyWith({
    String? product_image_url,
    int? is_synced,
  }) =>
      WishlistItem(
        id: id,
        product_id: product_id,
        product_name: product_name,
        product_price: product_price,
        product_image_url:
        product_image_url ?? this.product_image_url,
        is_synced: is_synced ?? this.is_synced,
        created_at: created_at,
      );
}
