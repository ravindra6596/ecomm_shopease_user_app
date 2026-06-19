import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/address/address_bloc.dart';
import 'package:e_comm_user/bloc/address/address_event.dart';
import 'package:e_comm_user/bloc/address/address_state.dart';
import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/bloc/cart/cart_event.dart';
import 'package:e_comm_user/bloc/cart/cart_state.dart';
import 'package:e_comm_user/bloc/order/order_bloc.dart';
import 'package:e_comm_user/bloc/order/order_event.dart';
import 'package:e_comm_user/bloc/order/order_state.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/cart/cart_item_widget.dart';
import 'package:e_comm_user/widgets/cart/cart_summary_widget.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/saved_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
    const CheckoutScreen({super.key,  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  CartBloc cartBloc = getIt<CartBloc>();
  int selectedPayment = 0;
  AddressBloc addressBloc = getIt.get<AddressBloc>();
  OrderBloc orderBloc = getIt.get<OrderBloc>();
  var prefs = getIt<SharedPreferences>();
  AddressData? selectedAddress;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  BuildContext? navContext;
  @override
  Widget build(BuildContext context) {
    navContext = context;
    return Scaffold(
      backgroundColor:whiteColor,
      appBar: CustomAppBar(title: checkout),

      // bottomNavigationBar: _buildPlaceOrderButton(),
      bottomNavigationBar: BlocBuilder<OrderBloc, OrderState>(
        bloc: orderBloc,
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return _buildPlaceOrderButton();
        },
      ),

      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cartBloc),
          BlocProvider(create: (context) => orderBloc),
          // BlocProvider(create: (context) => NavigationBloc()),
        ],
        child: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state  is OrderActionSuccessState) {
              Functions.showCustomSnackBar(
                context, message: state.orderCreateModel.message ?? 'Order Placed', backgroundColor:successColor,
              );
              getIt<AppRoutes>().push(OrderSuccessRoute(orderCreateModel: state.orderCreateModel));
              cartBloc.add(GetCartItemsEvent());
            }
            else if (state is OrderErrorState) {
              Functions.showCustomSnackBar(
                context,  message: state.message, backgroundColor: errorColor,
              );
            }
          },
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addressCard(),
                    // sectionTitle(paymentMethod),
                    Visibility(
                      visible: false,
                      child: Row(
                        children: [
                          _paymentCard("Card", 0),
                          const SizedBox(width: 10),
                          _paymentCard("Cash", 1),
                          const SizedBox(width: 10),
                          _paymentCard("Apple Pay", 2),
                        ],
                      ),
                    ),
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        List<CartItem> items = [];
                        if (state is CartLoadedState) {
                          items = state.items;
                        } else {
                          items = cartBloc.currentCartItems;
                        }

                        final subtotal = items.fold<int>(
                            0,(sum, item) => sum + (item.total_price ?? 0));
                        final discountAmount = items.fold<int>(
                            0,(sum, item) => sum + (item.discount_price ?? 0));
                        const shipping = 0;
                        const vat = 0;
                        final totalAmt = subtotal + shipping + vat;

                        final totalDiscount = (subtotal - discountAmount).round();
                        final shippingFeeAmount = (totalDiscount *10/100).round();
                        final grandTotalAmount = discountAmount + shippingFeeAmount;
                        final savings = totalDiscount - shippingFeeAmount;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// CART ITEMS
                            sectionTitle(cartItems),
                            buildCartList(items),
                            /// SUMMARY
                            sectionTitle(orderSummary),
                            SummaryRow(label: subTotal,value: subtotal),
                            SizedBox(height: 0.8.h),
                            SummaryRow(label: discount, value: totalDiscount, isDiscount: true),
                            SizedBox(height: 0.8.h),
                            SummaryRow(label: protectPromiseFee, value: shippingFeeAmount ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.2.h),
                              child: Divider(color: dividerColor,height: 1),
                            ),
                            SummaryRow(label: total,value: grandTotalAmount,isTotal: true),
                            SizedBox(height: 1.h),
                            SavedPriceWidget(savingAmount: savings),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 2.h),
                    // _promoCode(),
                  ],
                ),
              ),
            ),
          ),
        ),
        ),

    );
  }

  // ---------------- ADDRESS ----------------
  Widget addressCard() {

    return BlocProvider.value(
      value: addressBloc..add(AddressListEvent()),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          // final selectedAddress = addressBloc.selectedAddress;
          if (state is AddressSuccessState  ) {
            final addresses = state.addressResponseModel.data ?? [];
              // selectedAddress = addresses.where((e) => e.is_default == true).isNotEmpty
              //     ? addresses.firstWhere((e) => e.is_default == true)
              //     : null;
            if (addresses.isNotEmpty) {
              selectedAddress = addresses.firstWhere(
                    (e) => e.is_default == true,
                orElse: () => addresses.first,
              );
            } else {
              selectedAddress = null;
            }

            return selectedAddress == null ?
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              onPressed: () async {
                final result = await getIt<AppRoutes>().push(  AddressListRoute());
                if (result == true) {
                  addressBloc.add(AddressListEvent());
                }
              },
              child: CustomText(
                text: selectAddress,
                fontSize: 13.px,
                color: primaryColor,
                style: CustomTextStyle.medium,
              ),
            )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(deliveryAddress),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(1.h),
                    border: Border.all(color: greyColor.withValues(alpha: .3)),
                                  ),
                                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: greyColor.withValues(alpha: .6),
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: CustomText(
                                    text: selectedAddress?.full_name ?? '',
                                    fontSize: 15.px,
                                    style: CustomTextStyle.bold,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            CustomText(
                          text:   "${selectedAddress?.address_line ?? ''}, "
                                  "${selectedAddress?.city ?? ''}, "
                                  "${selectedAddress?.state ?? ''}, "
                                  "${selectedAddress?.country ?? ''} - "
                                  "${selectedAddress?.pincode ?? ''}",
                          fontSize: 14.px,
                          color: greyColor.withValues(alpha: .6),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                            ),
                            CustomText(
                              text: selectedAddress?.phone ?? '',
                              fontSize: 13.px,
                              style: CustomTextStyle.medium,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final result =  await getIt<AppRoutes>().push(  AddressListRoute());
                          if (result == true) {
                            addressBloc.add(AddressListEvent());
                          }
                        },
                        child: CustomText(
                          text: change,
                          fontSize: 13.px,
                          color: primaryColor,
                          style: CustomTextStyle.medium,
                        ),
                      )
                    ],
                                  ),
                                ),
                  ],
                );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ---------------- PAYMENT ----------------
  Widget _paymentCard(String title, int index) {
    final isSelected = selectedPayment == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedPayment = index);

        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isSelected ? 1.05 : 1.0,
            child: Center(
              child: CustomText(
                text:  title,
                   color: isSelected ? whiteColor : blackColor,
                  style: CustomTextStyle.semiBold,
               ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- SUMMARY ----------------


  // ---------------- PROMO ----------------
  Widget _promoCode() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: box(),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter promo code",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  // ---------------- BUTTON ----------------
  Widget _buildPlaceOrderButton() {
    final isLoggedIn = prefs.getBool(SharedPrefHelper.isLoginPref) ?? false;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoggedIn  ?
          CustomButton(
            text: placeOrder,
            onPressed: (){
              if(selectedAddress?.id == 0 || selectedAddress?.id == null){
                Functions.showCustomSnackBar(context, message: selectAddress,backgroundColor: errorColor);
              }
              else{
                OrderRequestModel orderRequestModel = OrderRequestModel(address_id: selectedAddress?.id ?? 0,payment_method: 'cod');
                orderBloc.add(CreateOrderEvent(orderRequestModel));
              }
        })
        : CustomButton(
          text: login,
          onPressed: () {
            getIt<AppRoutes>().push(LoginRoute());
          },
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: CustomText(
        text:title,
          fontSize: 16,
          style: CustomTextStyle.bold,
      ),
    );
  }


  BoxDecoration box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  Widget buildCartList( List<CartItem> items) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final productId = item.product_id ?? 0;
        return CartItemWidget(
          key: ValueKey(item.id ?? item.product_id),
          item: item,
          onTap: productId > 0
              ? () => context.router.push(
            ProductDetailsRoute(
              productId: productId,
            ),
          ): null,

          onQuantityChanged: (quantity) {
            cartBloc.add(
              UpdateQuantityEvent(
                productId,
                quantity,
                cartLineId: item.id ?? 0,
              ),
            );
            Functions.showCustomSnackBar(
              context,
              message: itemQuantityChanged,
              backgroundColor:
              successColor,
            );
          },
          onRemove: () {
            cartBloc.add(
              RemoveFromCartEvent(
                productId,
                cartLineId: item.id ?? 0,
              ),
            );
            Functions.showCustomSnackBar(
              context,
              message: itemRemovedFromCart,
              backgroundColor:
              errorColor,
            );
          },
        );
      },
    );
  }
}