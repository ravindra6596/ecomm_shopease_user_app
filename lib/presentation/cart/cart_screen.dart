import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/bloc/cart/cart_event.dart';
import 'package:e_comm_user/bloc/cart/cart_state.dart';
import 'package:e_comm_user/bloc/navigation/navigation_bloc.dart';
import 'package:e_comm_user/bloc/navigation/navigation_event.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/cart/cart_error_widget.dart';
import 'package:e_comm_user/widgets/cart/cart_item_widget.dart';
import 'package:e_comm_user/widgets/cart/cart_loading_widget.dart';
import 'package:e_comm_user/widgets/cart/cart_summary_widget.dart';
import 'package:e_comm_user/widgets/cart/empty_cart_widget.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const int _defaultShippingFee = 0;
  CartBloc cartBloc = getIt<CartBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartBloc>().add(GetCartItemsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        title: myCart,
        showBackButton: false,
        backgroundColor: whiteColor,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            current is CartErrorState || current is SyncCartSuccessState || current is SyncCartFailureState,
        listener: (context, state) {
          if (state is CartErrorState) {
            Functions.showCustomSnackBar(
              context,
              message: state.error,
              backgroundColor: errorColor,
            );
          } else if (state is SyncCartSuccessState) {
            Functions.showCustomSnackBar(
              context,
              message: state.message,
              backgroundColor: successColor,
            );
          } else if (state is SyncCartFailureState) {
            Functions.showCustomSnackBar(
              context,
              message: state.error,
              backgroundColor: errorColor,
            );
          }
        },
        buildWhen: (previous, current) =>
            current is CartLoadingState ||
            current is CartLoadedState ||
            current is CartErrorState ||
            current is SyncCartLoadingState,
        builder: (context, state) {
          if (state is CartLoadingState && cartBloc.currentCartItems.isEmpty) {
            return const CartLoadingWidget();
          }

          if (state is SyncCartLoadingState) {
            return Stack(
              children: [
                _buildCartContent(
                  context,
                  cartBloc,
                  cartBloc.currentCartItems,
                  0,
                  0,
                ),
                const SyncCartLoadingWidget(),
              ],
            );
          }

          if (state is CartLoadedState) {
            return _buildCartContent(
              context,
              cartBloc,
              state.items,
              state.grandTotal,
              state.discountTotal,
            );
          }

          if (state is CartErrorState && cartBloc.currentCartItems.isEmpty) {
            return CartErrorWidget(
              error: state.error,
              onRetry: () => cartBloc.add(GetCartItemsEvent()),
            );
          }

          if (cartBloc.currentCartItems.isNotEmpty) {
            return _buildCartContent(
              context,
              cartBloc,
              cartBloc.currentCartItems,
              0,
              0,
            );
          }
          return const CartLoadingWidget();
        },
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    CartBloc cartBloc,
    List<CartItem> items,
    int grandTotal,
    int discountTotal,
  ) {
    if (items.isEmpty) {
      return EmptyCartWidget(
        title: cartEmpty,
        description: cartEmptyDesc,
        buttonTitle: continueShopping,
        icon: Icons.remove_shopping_cart_outlined,
        onContinueShopping: () {
          context.read<NavigationBloc>().add(
            const NavigationTabChangedEvent(0),
          );
          context.router.popUntilRoot();
        },
      );
    }

    final subtotal = grandTotal > 0
        ? grandTotal
        : items.fold<int>(0, (sum, item) => sum + (item.total_price ?? 0));
    final discountAmount = discountTotal > 0
        ? discountTotal
        : items.fold<int>(0, (sum, item) => sum + (item.discount_price ?? 0));
    const shipping = _defaultShippingFee;
    const vat = 0;
    final total = subtotal + shipping + vat;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final productId = item.product_id ?? 0;
              return CartItemWidget(
                key: ValueKey(item.id ?? item.product_id),
                item: item,
                onTap: productId > 0
                    ? () => context.router.push(
                          ProductDetailsRoute(productId: productId),
                        )
                    : null,
                onQuantityChanged: (quantity) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    cartBloc.add(
                      UpdateQuantityEvent(
                        productId,
                        quantity,
                        cartLineId: item.id,
                      ),
                    );
                  },);
                  Functions.showCustomSnackBar(
                    context,
                    message: itemQuantityChanged,
                    backgroundColor: successColor,
                  );
                },
                onRemove: () {
                  cartBloc.add(
                    RemoveFromCartEvent(
                      productId,
                      cartLineId: item.id,
                    ),
                  );
                  Functions.showCustomSnackBar(
                    context,
                    message: itemRemovedFromCart,
                    backgroundColor: errorColor,
                  );
                },
              );
            },
          ),
        ),
        CartSummaryWidget(
          subtotal: subtotal,
          shipping: shipping,
          vat: vat,
          totalAmount: total,
          discountAmount: discountAmount,
          onCheckout: () {
            getIt<AppRoutes>().push(CheckoutRoute());
          },
        ),
      ],
    );
  }
}
