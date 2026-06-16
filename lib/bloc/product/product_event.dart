import 'package:e_comm_user/models/product_model.dart';

abstract class ProductEvent {}

class ProductListEvent extends ProductEvent {
  final int page;
  final int limit;
  final String search;
  final int? categoryId;
  final ProductFilterModel? filter;
  ProductListEvent(this.page, this.limit, this.search, [this.categoryId,this.filter]);
}

class ProductSearchEvent extends ProductEvent {
  final String search;
  ProductSearchEvent(this.search);
}

class ProductDetailsEvent extends ProductEvent {
  final int productId;
  ProductDetailsEvent(this.productId);
}

class ProductImageIndexChangedEvent extends ProductEvent {
  final int imageIndex;
  ProductImageIndexChangedEvent(this.imageIndex);
}
