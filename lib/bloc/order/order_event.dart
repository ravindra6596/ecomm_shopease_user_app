import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/models/order_response_model.dart';

abstract class OrderEvent {}
class CreateOrderEvent extends OrderEvent {
  final OrderRequestModel orderRequestModel;
  CreateOrderEvent(this.orderRequestModel);
}

class OrderListEvent extends OrderEvent {
  final int page;
  final int limit;
  final String search;
  final OrderFilterModel? filter;
  OrderListEvent(this.page, this.limit, this.search, [this.filter]);
}
class OrderSearchEvent extends OrderEvent {
  final String search;
  OrderSearchEvent(this.search);
}
class OrderDetailsEvent extends OrderEvent {
  final int id;
  OrderDetailsEvent(this.id);
}

class OrderCancelEvent extends OrderEvent {
  final int id;
  OrderCancelEvent(this.id);
}
class OrderInvoiceEvent extends OrderEvent {
  final int id;
  OrderInvoiceEvent(this.id);
}
