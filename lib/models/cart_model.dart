import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class AddToCartRequestModel {
  final int product_id;

  AddToCartRequestModel({
    required this.product_id,
  });

  factory AddToCartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddToCartRequestModelToJson(this);
}

@JsonSerializable()
class AddToCartResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final Map<String, dynamic>? data;

  AddToCartResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddToCartResponseModelToJson(this);
}

@JsonSerializable()
class CartResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final CartData? data;

  CartResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);
}

@JsonSerializable()
class CartData {
  final int? grand_total;
  final int? total_items;
  final List<CartItem>? items;

  CartData({
    this.grand_total,
    this.total_items,
    this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) =>
      _$CartDataFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataToJson(this);
}

@JsonSerializable()
class CartItem {
  final int? id;
  final int? cart_id;
  final int? product_id;
  final int? quantity;
  final String? product_name;
  final int? product_price;
  final int? total_price;
  final int is_synced;
  final String? product_image_url;
  final String? created_at;
  final String? updated_at;

  CartItem({
    this.id,
    this.cart_id,
    this.product_id,
    this.quantity,
    this.product_name,
    this.product_price,
    this.is_synced = 0,
    this.total_price,
    this.product_image_url,
    this.created_at,
    this.updated_at,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final item = _$CartItemFromJson(json);
    return CartItem(
      id: item.id,
      cart_id: item.cart_id,
      product_id: item.product_id,
      quantity: item.quantity,
      product_name: item.product_name,
      product_price: item.product_price,
      total_price: item.total_price,
      is_synced: item.is_synced,
      product_image_url: item.product_image_url ??
          json['image_url'] as String? ??
          json['product_image'] as String?,
      created_at: item.created_at,
      updated_at: item.updated_at,
    );
  }

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  /// Maps a SQLite `cart_items` row to [CartItem] (guest cart).
  factory CartItem.fromLocalDb(Map<String, dynamic> row) => CartItem(
        id: row['id'] as int?,
        product_id: row['product_id'] as int?,
        product_name: row['product_name'] as String?,
        product_price: row['product_price'] as int?,
        quantity: row['quantity'] as int?,
        total_price: row['total_price'] as int?,
        is_synced: row['is_synced'] ?? 0,
        product_image_url: row['product_image_url'] as String?,
        created_at: row['created_at'] as String?,
        updated_at: row['updated_at'] as String?,
      );

  /// Inserts/updates in SQLite `cart_items` (guest cart).
  Map<String, dynamic> toLocalDbMap() => {
        'product_id': product_id,
        'product_name': product_name,
        'product_price': product_price,
        'product_image_url': product_image_url,
        'quantity': quantity ?? 1,
        'is_synced': is_synced,
        'total_price': total_price ?? (product_price ?? 0) * (quantity ?? 1),
        'created_at': created_at ?? DateTime.now().toIso8601String(),
        'updated_at': updated_at ?? DateTime.now().toIso8601String(),
      };

  CartItem copyWith({
    String? product_image_url,
    int? is_synced,
  }) =>
      CartItem(
        id: id,
        cart_id: cart_id,
        product_id: product_id,
        quantity: quantity,
        product_name: product_name,
        product_price: product_price,
        total_price: total_price,
        is_synced: is_synced ?? this.is_synced,
        product_image_url: product_image_url ?? this.product_image_url,
        created_at: created_at,
        updated_at: updated_at,
      );
}

@JsonSerializable()
class UpdateQuantityRequestModel {
  final int quantity;

  UpdateQuantityRequestModel({
    required this.quantity,
  });

  factory UpdateQuantityRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateQuantityRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateQuantityRequestModelToJson(this);
}

@JsonSerializable()
class UpdateQuantityResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final Map<String, dynamic>? data;

  UpdateQuantityResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory UpdateQuantityResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateQuantityResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateQuantityResponseModelToJson(this);
}
