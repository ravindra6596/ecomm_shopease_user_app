import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/models/order_response_model.dart';

abstract class OrderState {}
class OrderInitialState extends OrderState {}
class OrderLoadingState extends OrderState {}
class OrderActionSuccessState extends OrderState {
  final OrderCreateModel orderCreateModel;
  OrderActionSuccessState(this.orderCreateModel);
  List<Object> get props => [orderCreateModel];
}
class OrderSuccessState extends OrderState {
  final OrderResponseModel orderResponseModel;
  final bool hasMore;

  OrderSuccessState(this.orderResponseModel, this.hasMore);
}
class OrderDeletedState extends OrderState {
  final OrderDetailsResponseModel orderDetailsResponseModel;
  OrderDeletedState(this.orderDetailsResponseModel);
  List<Object> get props => [orderDetailsResponseModel];
}
class OrderDetailsSuccessState extends OrderState {
  final OrderDetailsResponseModel orderDetailsResponseModel;
  OrderDetailsSuccessState(this.orderDetailsResponseModel);
  List<Object> get props => [orderDetailsResponseModel];
}
class OrderErrorState extends OrderState {
  final String message;
  OrderErrorState(this.message);
  List<Object> get props => [message];
}

class OrderInvoiceLoadingState extends OrderState {}
class OrderInvoiceLoadedState extends OrderState {

  final List<int> bytes;
  final int orderId;

  OrderInvoiceLoadedState(
      this.bytes,
      this.orderId,
      );
}