import 'package:json_annotation/json_annotation.dart';
import 'address_response_model.dart';
part 'order_response_model.g.dart';
@JsonSerializable()
class OrderResponseModel {
  bool? status;
  int? statusCode;
  dynamic error;
  String? message;
  OrderData? data;

  OrderResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseModelToJson(this);
}

@JsonSerializable()
class OrderData {
  int? total;
  int? page;
  int? limit;
  int? total_pages;
  bool? is_previous;
  bool? is_next;
  List<OrderItems>? items;

  OrderData({
    this.total,
    this.page,
    this.limit,
    this.total_pages,
    this.is_previous,
    this.is_next,
    this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}

@JsonSerializable()
class OrderItems {
  int? id;

   String? user_name;

   int? user_id;

  int? address_id;


  int? total_amount;
  int? total_discount_price;
  int? shipping;

  String? status;

  String? payment_status;


  String? payment_method;

  String? created_at;

  List<ProductItems>? items;

  AddressData? address;

  OrderItems({
    this.id,
    this.user_name,
    this.user_id,
    this.address_id,
    this.total_amount,
    this.total_discount_price,
    this.shipping,
    this.status,
    this.payment_status,
    this.payment_method,
    this.created_at,
    this.items,
    this.address,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) =>
      _$OrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}

@JsonSerializable()
class ProductItems {

  int? product_id;


  String? product_name;
  String? image_url;

  int? quantity;
  int? price;
  int? discount;
  int? discount_price;

  int? total_price;

  ProductItems({
    this.product_id,
    this.product_name,
    this.image_url,
    this.quantity,
    this.price,
    this.total_price,
    this.discount,
    this.discount_price,
  });

  factory ProductItems.fromJson(Map<String, dynamic> json) =>
      _$ProductItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemsToJson(this);
}
class OrderFilterModel {

  final String? order_status;
  final String? payment_method;
  final String? sort_by;
  final String? order;

  final bool isFilterApplied;

  const OrderFilterModel({
    this.order_status,
    this.payment_method,
    this.sort_by,
    this.order,
    this.isFilterApplied = false,
  });

  OrderFilterModel copyWith({
    String? order_status,
    String? payment_method,
    String? sort_by,
    String? order,
    bool? isFilterApplied,
  }) {
    return OrderFilterModel(
      order_status: order_status ?? this.order_status,
      payment_method: payment_method ?? this.payment_method,
      sort_by: sort_by ?? this.sort_by,
      order: order ?? this.order,
      isFilterApplied:
      isFilterApplied ?? this.isFilterApplied,
    );
  }
}

@JsonSerializable()
class OrderDetailsResponseModel {
  final bool? status;
  final int? statusCode;
  final String? error;
  final String? message;
  final OrderItems? data;

  OrderDetailsResponseModel({
    this.status,
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory OrderDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsResponseModelToJson(this);
}