import 'package:e_comm_user/models/order_response_model.dart';
import 'package:e_comm_user/models/product_model.dart';

class FilterState {
  final ProductFilterModel productFilter;
  final OrderFilterModel orderFilter;

  const FilterState({
    this.productFilter = const ProductFilterModel(),
    this.orderFilter = const OrderFilterModel(),
  });

  FilterState copyWith({
    ProductFilterModel? productFilter,
    OrderFilterModel? orderFilter,
  }) {
    return FilterState(
      productFilter: productFilter ?? this.productFilter,
      orderFilter: orderFilter ?? this.orderFilter,
    );
  }
}

class OrderFilterState {
  final OrderFilterModel filter;

  const OrderFilterState({
    required this.filter,
  });

  OrderFilterState copyWith({
    OrderFilterModel? filter,
  }) {
    return OrderFilterState(
      filter: filter ?? this.filter,
    );
  }
}