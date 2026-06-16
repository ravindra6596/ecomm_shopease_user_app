import 'package:flutter/material.dart';

abstract class FilterEvent {
  const FilterEvent();
}

class UpdatePriceRangeEvent extends FilterEvent {
  final RangeValues values;

  const UpdatePriceRangeEvent(this.values);
}

class UpdateSortByEvent extends FilterEvent {
  final String sortBy;

  const UpdateSortByEvent(this.sortBy);
}

class UpdateOrderEvent extends FilterEvent {
  final String order;

  const UpdateOrderEvent(this.order);
}

class ApplyFilterEvent extends FilterEvent {}

class ClearFilterEvent extends FilterEvent {}

class UpdateOrderStatusEvent extends FilterEvent {
  final String status;

  const UpdateOrderStatusEvent(this.status);
}
class UpdatePaymentStatusEvent extends FilterEvent {
  final String paymentStatus;

  const UpdatePaymentStatusEvent(this.paymentStatus);
}
class UpdatePaymentMethodEvent extends FilterEvent {
  final String paymentMethod;

  const UpdatePaymentMethodEvent(this.paymentMethod);
}
class UpdateOrderSortByEvent extends FilterEvent {
  final String sortBy;

  const UpdateOrderSortByEvent(this.sortBy);
}
class UpdateOrderSortEvent extends FilterEvent {
  final String order;

  const UpdateOrderSortEvent(this.order);
}
class ApplyOrderFilterEvent extends FilterEvent {}
class ClearOrderFilterEvent extends FilterEvent {}
