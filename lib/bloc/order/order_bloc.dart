import 'package:e_comm_user/bloc/order/order_event.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/models/order_response_model.dart';
import 'package:e_comm_user/repository/order_repository.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'order_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository? orderRepository;
  List<OrderItems> allOrders = [];
  OrderData? selectedOrder;
  int? selectedOrderId;
  int selectedOrderIndex = 0;
  OrderBloc()
      : orderRepository = getIt<OrderRepository>(),
        super(OrderInitialState()) {
   
    on<CreateOrderEvent>(createOrder);
    on<OrderEvent>(orderListData);
    on<OrderDetailsEvent>(orderDetailsMethod);
    on<OrderCancelEvent>(orderCancelMethod);
    on<OrderInvoiceEvent>(orderInvoiceMethod);
  }
  Future<void> createOrder(CreateOrderEvent event, emit) async {

    emit(OrderLoadingState());
    final result = await orderRepository!.createOrder(event.orderRequestModel);

    switch (result) {
      case Success<OrderCreateModel, Exception>():
        final orderData = result.data;
        emit(OrderActionSuccessState(orderData));
        break;
      case Failure<OrderCreateModel, Exception>():
        emit(OrderErrorState(result.error.toString()));
        break;
    }
  }
  // order lists
  orderListData(OrderEvent event, emit) async {
    if (event is OrderListEvent) {
      await orderListMethod(event, emit);
    } else if (event is OrderSearchEvent) {
      await orderListSearch(event, emit);
    }
    // else if (event is OrderDetailsEvent) {
    //   await orderDetailsMethod(event, emit);
    // }
  }

  orderListMethod(OrderListEvent event, emit) async {
    if (event.page == 1) {
      emit(OrderLoadingState());
      allOrders.clear();
      hasMoreData = true;
    }
    final orderList =
    await orderRepository!.getOrderList(event.page, event.limit, event.search,   event.filter);

    switch (orderList) {
      case Success<OrderResponseModel, Exception>():
        final newOrders = orderList.data.data?.items ?? [];
        if (newOrders.length < event.limit) {
          hasMoreData = false;
        }
        allOrders.addAll(newOrders);
        final updatedResponse = OrderResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: OrderData(
            total: orderList.data.data?.total,
            page: orderList.data.data?.page,
            limit: orderList.data.data?.limit,
            total_pages: orderList.data.data?.total_pages,
            is_previous: orderList.data.data?.is_previous,
            is_next: orderList.data.data?.is_next,
            items: allOrders,
          ),
        );

        emit(OrderSuccessState(updatedResponse, hasMoreData));
        break;

      case Failure<OrderResponseModel, Exception>():
        emit(OrderErrorState(orderList.error));
        break;
    }
  }

  orderListSearch(OrderSearchEvent event, emit) async {
    if (event.search.isEmpty) {
      emit(OrderSuccessState(orderResponseModel, hasMoreData));
    } else {
      final searchData = orderResponseModel.data?.items
          ?.where((element) =>
      element.items?.any((product) =>
          product.product_name!.toLowerCase().contains(event.search.toLowerCase())
      ) ??
          false)
          .toList();
      final orderResponseData = OrderResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: OrderData(
            total: orderResponseModel.data?.total,
            page: orderResponseModel.data?.page,
            limit: orderResponseModel.data?.limit,
            total_pages: orderResponseModel.data?.total_pages,
            is_previous: orderResponseModel.data?.is_previous,
            is_next: orderResponseModel.data?.is_next,
            items: searchData,
          ));
      emit(OrderSuccessState(orderResponseData, false));
    }
  }
  orderDetailsMethod(OrderDetailsEvent event, emit) async {
    emit(OrderLoadingState());
    final orderDetails = await orderRepository!.getOrderDetails(event.id);

    switch (orderDetails) {
      case Success<OrderDetailsResponseModel, Exception>():
        final order = orderDetails.data.data;
        if (order != null) {
          emit(OrderDetailsSuccessState(orderDetails.data));
        } else {
          emit(OrderErrorState('Order not found'));
        }
        break;

      case Failure<OrderDetailsResponseModel, Exception>():
        emit(OrderErrorState(orderDetails.error));
        break;
    }
  }

  orderCancelMethod(OrderCancelEvent event, emit) async {
    emit(OrderLoadingState());
    final orderDetails = await orderRepository!.cancelOrder(event.id);

    switch (orderDetails) {
      case Success<OrderDetailsResponseModel, Exception>():
        final order = orderDetails.data.message;
        if (order != null) {
          emit(OrderDeletedState(orderDetails.data));
        } else {
          emit(OrderErrorState('Order not found'));
        }
        break;

      case Failure<OrderDetailsResponseModel, Exception>():
        emit(OrderErrorState(orderDetails.error));
        break;
    }
  }

  // order invoice
  orderInvoiceMethod(OrderInvoiceEvent event, emit) async {
    final orderDetails = await orderRepository!.getOrderInvoice(event.id);

    switch (orderDetails) {
      case Success<List<int>, Exception>():
          emit(OrderInvoiceLoadedState(orderDetails.data,event.id));
           break;

      case Failure<List<int>, Exception>():
        emit(OrderErrorState(orderDetails.error));
        break;
    }
  }
 }