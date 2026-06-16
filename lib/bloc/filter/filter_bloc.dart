import 'package:e_comm_user/models/order_response_model.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'filter_event.dart';
import 'filter_state.dart';
@injectable
class FilterBloc extends Bloc<FilterEvent, FilterState> {

  FilterBloc()
      : super(
    const FilterState(
      productFilter: ProductFilterModel(),
      orderFilter: OrderFilterModel(),
    ),
  ) {
    // products
    on<UpdatePriceRangeEvent>(updatePriceRange);
    on<UpdateSortByEvent>(updateSortBy);
    on<UpdateOrderEvent>(updateOrder );
    on<ApplyFilterEvent>(applyFilter);
    on<ClearFilterEvent>(clearFilter);
    // orders
    /// ORDER
    on<UpdateOrderStatusEvent>(updateOrderStatus);
    on<UpdatePaymentStatusEvent>(updatePaymentStatus);
    on<UpdatePaymentMethodEvent>(updatePaymentMethod);
    on<UpdateOrderSortByEvent>(updateOrderSortBy);
    on<UpdateOrderSortEvent>(updateOrderSort);
    on<ApplyOrderFilterEvent>(applyOrderFilter);
    on<ClearOrderFilterEvent>(clearOrderFilter);

  }

  updatePriceRange(
      UpdatePriceRangeEvent event,
      Emitter<FilterState> emit,
      ) {
    emit(
      state.copyWith(
        productFilter: state.productFilter.copyWith(
          min_price: event.values.start,
          max_price: event.values.end,
        ),
      ),
    );
  }

 updateSortBy(
      UpdateSortByEvent event,
      Emitter<FilterState> emit,
      ) {
    emit(
      state.copyWith(
        productFilter: state.productFilter.copyWith(
          sort_by: event.sortBy,
        ),
      ),
    );
  }

 updateOrder(
      UpdateOrderEvent event,
      Emitter<FilterState> emit,
      ) {
    emit(
      state.copyWith(
        productFilter: state.productFilter.copyWith(
          order: event.order,
        ),
      ),
    );
  }

   applyFilter(
      ApplyFilterEvent event,
      Emitter<FilterState> emit,
      ) {
    emit(
      state.copyWith(
        productFilter: state.productFilter.copyWith(
          isFilterApplied: true,
        ),
      ),
    );
  }

   clearFilter(ClearFilterEvent event, emit) {
    emit(const FilterState(productFilter: ProductFilterModel()));
  }
  // =========================================================
  // ORDER
  // =========================================================

  updateOrderStatus(
      UpdateOrderStatusEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: state.orderFilter.copyWith(
          order_status: event.status,
        ),
      ),
    );
  }

  updatePaymentStatus(
      UpdatePaymentStatusEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: state.orderFilter.copyWith(
          order_status: event.paymentStatus,
        ),
      ),
    );
  }

  updatePaymentMethod(
      UpdatePaymentMethodEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: state.orderFilter.copyWith(
          payment_method: event.paymentMethod,
        ),
      ),
    );
  }

  updateOrderSortBy(
      UpdateOrderSortByEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: state.orderFilter.copyWith(
          sort_by: event.sortBy,
        ),
      ),
    );
  }

  updateOrderSort(
      UpdateOrderSortEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: state.orderFilter.copyWith(
          order: event.order,
        ),
      ),
    );
  }

  applyOrderFilter(
      ApplyOrderFilterEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: state.orderFilter.copyWith(
          isFilterApplied: true,
        ),
      ),
    );
  }

  clearOrderFilter(
      ClearOrderFilterEvent event,
      Emitter<FilterState> emit,
      ) {

    emit(
      state.copyWith(
        orderFilter: const OrderFilterModel(),
      ),
    );
  }
}