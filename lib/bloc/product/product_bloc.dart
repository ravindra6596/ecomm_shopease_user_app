import 'package:e_comm_user/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/repository/product_repository.dart';
import 'package:injectable/injectable.dart';

import 'product_event.dart';
import 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository? productRepository;
  List<Product> allProducts = [];

  ProductBloc()
      : productRepository = getIt<ProductRepository>(),
        super(ProductInitialState()) {
    on<ProductEvent>(productListData);
    on<ProductDetailsEvent>(productDetailsMethod);
  }

  productListData(ProductEvent event, emit) async {
    if (event is ProductListEvent) {
      await productListMethod(event, emit);
    } else if (event is ProductSearchEvent) {
      await productListSearch(event, emit);
    }
    // else if (event is ProductDetailsEvent) {
    //   await productDetailsMethod(event, emit);
    // }
  }

  productListMethod(ProductListEvent event, emit) async {
    if (event.page == 1) {
      emit(ProductLoadingState());
      allProducts.clear();
      hasMoreData = true;
    }
    final productList =
        await productRepository!.getProductList(event.page, event.limit, event.search, event.categoryId, event.filter);

    switch (productList) {
      case Success<ProductResponseModel, Exception>():
        final newProducts = productList.data.data?.items ?? [];
        if (newProducts.length < event.limit) {
          hasMoreData = false;
        }
        allProducts.addAll(newProducts);
        final updatedResponse = ProductResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: ProductData(
            total: productList.data.data?.total,
            page: productList.data.data?.page,
            limit: productList.data.data?.limit,
            total_pages: productList.data.data?.total_pages,
            is_previous: productList.data.data?.is_previous,
            is_next: productList.data.data?.is_next,
            items: allProducts,
          ),
        );

        emit(ProductSuccessState(updatedResponse, hasMoreData));
        break;

      case Failure<ProductResponseModel, Exception>():
        emit(ProductErrorState(productList.error));
        break;
    }
  }

  productListSearch(ProductSearchEvent event, emit) async {
    if (event.search.isEmpty) {
      emit(ProductSuccessState(productResponseModel, hasMoreData));
    } else {
      final searchData = productResponseModel.data?.items
          ?.where((element) =>
              element.name!.toLowerCase().contains(event.search.toLowerCase()))
          .toList();
      final productResponseData = ProductResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: ProductData(
            total: productResponseModel.data?.total,
            page: productResponseModel.data?.page,
            limit: productResponseModel.data?.limit,
            total_pages: productResponseModel.data?.total_pages,
            is_previous: productResponseModel.data?.is_previous,
            is_next: productResponseModel.data?.is_next,
            items: searchData,
          ));
      emit(ProductSuccessState(productResponseData, false));
    }
  }

  productDetailsMethod(ProductDetailsEvent event, emit) async {
    emit(ProductDetailsLoadingState());
    final productDetails = await productRepository!.getProductDetails(event.productId);

    switch (productDetails) {
      case Success<ProductDetailsResponseModel, Exception>():
        final product = productDetails.data.data;
        if (product != null) {
          emit(ProductDetailsSuccessState(product));
        } else {
          emit(ProductDetailsErrorState('Product not found'));
        }
        break;

      case Failure<ProductDetailsResponseModel, Exception>():
        emit(ProductDetailsErrorState(productDetails.error));
        break;
    }
  }
}
