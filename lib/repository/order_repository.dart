import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/models/order_response_model.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:injectable/injectable.dart';

abstract class OrderRepository {
  Future<Result<OrderCreateModel, Exception>>createOrder(OrderRequestModel orderRequestModel);
  Future<Result<OrderResponseModel, Exception>> getOrderList(
      int page, int limit, String search,  OrderFilterModel? filter);
  Future<Result<OrderDetailsResponseModel, Exception>> getOrderDetails(int id);
  Future<Result<List<int>, Exception>> getOrderInvoice(int id);
  Future<Result<OrderDetailsResponseModel, Exception>> cancelOrder(int id);
}

@Injectable(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this.apiClient);
  final ApiClient apiClient;

  @override
  Future<Result<OrderCreateModel, Exception>>createOrder(OrderRequestModel orderRequestModel) async {
    try {
      final orderCreateModel = await apiClient.createOrder(orderRequestModel);
      if (orderCreateModel.statusCode == 201) {
        return Success(orderCreateModel);
      } else {
        return Failure(orderCreateModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
  // order list
  @override
  Future<Result<OrderResponseModel, Exception>> getOrderList(
      int page, int limit, String search,  OrderFilterModel? filter,) async {
    try {
      final orderResponseModel = await apiClient.getOrdersList(page, limit, search,  filter?.payment_method, filter?.order_status, filter?.sort_by, filter?.order);
      if (orderResponseModel.statusCode == 200) {
        return Success(orderResponseModel);
      } else {
        return Failure(orderResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
  // order details
  @override
  Future<Result<OrderDetailsResponseModel, Exception>> getOrderDetails(int id) async {
    try {
      final orderDetailsResponseModel = await apiClient.getOrderDetails(id);
      if (orderDetailsResponseModel.statusCode == 200) {
        return Success(orderDetailsResponseModel);
      } else {
        return Failure(orderDetailsResponseModel.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }

  @override
  Future<Result<OrderDetailsResponseModel, Exception>> cancelOrder(int id) async {
    try {
      final cancelOrder = await apiClient.cancelOrder(id);
      if (cancelOrder.statusCode == 200) {
        return Success(cancelOrder);
      } else {
        return Failure(cancelOrder.message ?? '');
      }
    } on Exception catch (e) {
      dynamic res = Functions.getErrorResponse(e);
      if ((res['message']) != null && res['message'].toString().isNotEmpty) {
        return Failure(res['message']);
      } else {
        return Failure(e.toString());
      }
    }
  }
// order Invoice
  @override
  Future<Result<List<int>, Exception>> getOrderInvoice(int id) async {
    try {
      final response =
      await apiClient.getOrderInvoice(id);
      if (response.response.statusCode == 200) {
        return Success(
          response.data,
        );
      }
      return Failure('Invoice download failed');

    } on Exception catch (e) {
      return Failure(e.toString());
    }
  }

}
