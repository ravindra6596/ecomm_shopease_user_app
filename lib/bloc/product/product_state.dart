import 'package:e_comm_user/models/product_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  final ProductResponseModel productResponseModel;
  final bool hasMore;
  ProductSuccessState(this.productResponseModel, this.hasMore);
}

class ProductDetailsLoadingState extends ProductState {}

class ProductDetailsSuccessState extends ProductState {
  final Product product;
  final int currentImageIndex;
  ProductDetailsSuccessState(this.product, [this.currentImageIndex = 0]);
}

class ProductDetailsErrorState extends ProductState {
  final String error;
  ProductDetailsErrorState(this.error);
}

class ProductErrorState extends ProductState {
  final String error;
  ProductErrorState(this.error);
}
