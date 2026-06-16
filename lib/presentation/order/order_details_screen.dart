// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/address/address_bloc.dart';
import 'package:e_comm_user/bloc/address/address_event.dart';
import 'package:e_comm_user/bloc/order/order_bloc.dart';
import 'package:e_comm_user/bloc/order/order_event.dart';
import 'package:e_comm_user/bloc/order/order_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/cart/cart_item_widget.dart';
import 'package:e_comm_user/widgets/cart/cart_summary_widget.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key, this.orderId = 0,this.isFrom});
  String? isFrom;
  int orderId;
  OrderBloc orderBloc = getIt.get<OrderBloc>();
  AddressBloc addressBloc = getIt.get<AddressBloc>();
  void handleBack(BuildContext context) {
    if (isFrom == orderSuccess) {
      context.router.replaceAll([
        MainRoute(
          key: UniqueKey(),
          selectedIndex: 0,
        ),
      ]);
    } else {
      if (context.router.canPop()) {
        context.router.pop();
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          handleBack(context);
        }
      },
      child: BlocProvider(
        create: (context) => orderBloc..add(OrderDetailsEvent(orderId)),
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: CustomAppBar(
            title: orderDetails,
            onBackPressed: () {
              handleBack(context);
            },
          ),
          body: BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) async {
              if (state is OrderDeletedState) {
                context.router.replaceAll([
                  MainRoute(
                    key: UniqueKey(),
                    selectedIndex: 0,
                  ),
                ]);
                Functions.showCustomSnackBar(context,message:  state.orderDetailsResponseModel.message ?? '',backgroundColor: errorColor);
              }
              if (state is OrderInvoiceLoadedState) {

                // final dir = await getApplicationDocumentsDirectory();
                Directory? downloadsDir;
                if (Platform.isAndroid) {
                  downloadsDir = Directory('/storage/emulated/0/Download');
                } else {
                  downloadsDir = await getApplicationDocumentsDirectory();
                }
                final file = File("${downloadsDir.path}/ShopEase_Invoice_${state.orderId}.pdf");
                await file.writeAsBytes(state.bytes);
                await OpenFilex.open(file.path);
              }
            },
              buildWhen: (previous, current) {
                return current is! OrderInvoiceLoadedState;
              },
              builder: (context, state) {
                if (state is OrderLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is OrderErrorState) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is OrderDetailsSuccessState) {
                  orderDetailsResponseModel = state.orderDetailsResponseModel;
                  final orderData = orderDetailsResponseModel.data;
                  final currentStep = statusSteps.indexOf(
                    orderData?.status?.toLowerCase() ?? '',
                  );
                  final discountAmount = orderData?.total_discount_price ?? 0;
                  final shipping = orderData?.shipping ?? 0;
                  final totalAmount = orderData?.total_amount ?? 0;
                  final totalDiscount = totalAmount - discountAmount;
                  final savings = totalDiscount - shipping;

                  final displayAmount =
                  (discountAmount == 0 && shipping == 0)
                      ? totalAmount
                      : discountAmount + shipping;
                  return  SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// SUMMARY
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text:"$order #${orderData?.id ?? 0}",
                                        fontSize: 18.px,
                                        style: CustomTextStyle.bold,
                                      ),
                                      SizedBox(height: 2.h),
                                      CustomText(
                                        text: Functions.formatDateTime(orderData?.created_at ?? '',format: 'dd MMM yyyy'),
                                        color: greyColor.withValues(alpha: .6),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getOrderStatusColor(orderData?.status ?? ''
                                      ).withValues(alpha: .12),
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                    child: CustomText(
                                      text: orderData?.status?.toUpperCase() ?? '',
                                      color: getOrderStatusColor(orderData?.status ?? ''),
                                      style: CustomTextStyle.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: infoTile(
                                      title: payment,
                                      value: orderData?.payment_method?.toUpperCase() ?? '',
                                    ),
                                  ),
                                  Expanded(
                                    child: infoTile(
                                      title: total,
                                      value: "₹${Functions.formatPrice(displayAmount)}",                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          /// STATUS
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: greyColor.withValues(alpha: .3)),
                              borderRadius: BorderRadius.circular(1.h),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: orderStatus,
                                  style: CustomTextStyle.bold,
                                  fontSize: 17,
                                ),
                                SizedBox(height: 2.h),
                                Column(
                                  children: List.generate(
                                    statusSteps.length,
                                        (index) {
                                      final isCompleted = index <= currentStep;
                                      final isLast = index == statusSteps.length - 1;
                                      return IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width: 4.w,
                                                  height: 2.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isCompleted
                                                        ? successColor
                                                        :greyColor.withValues(alpha: .3),
                                                  ),
                                                  child: isCompleted
                                                      ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: whiteColor,
                                                  )
                                                      : null,
                                                ),

                                                if (!isLast)
                                                  Container(
                                                    width: 2,
                                                    height: 50,
                                                    color: isCompleted
                                                        ? successColor
                                                        : greyColor.withValues(alpha: .3),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(width: 1.5.h),
                                            CustomText(
                                              text: statusSteps[index].toUpperCase(),
                                              style: CustomTextStyle.semiBold,
                                              color: isCompleted
                                                  ? blackColor
                                                  : greyColor,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Products
                          CustomText(
                            text: products,
                            style: CustomTextStyle.bold,
                            fontSize: 17,
                          ),
                          SizedBox(height: 1.h),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderData?.items?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = orderData?.items?[index];
                              return GestureDetector(
                                onTap: () {
                                  getIt<AppRoutes>().push(ProductDetailsRoute(productId: item?.product_id ?? 0));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 1.h),
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border(
                                          bottom: BorderSide(color: greyColor.withValues(alpha: .5))
                                      )
                                    // border: Border.all(color: dividerColor),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProductThumbnail(imageUrl: item?.image_url ?? ''),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: item?.product_name ?? '',
                                              style: CustomTextStyle.semiBold,
                                              fontSize: 15.sp,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 1.h),
                                            infoTile(title: qty, value: item?.quantity?.toString() ?? '',isHorizontal: true),
                                            SizedBox(height: 1.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          CustomText(text: orderSummary),
                          SummaryRow(label: subTotal,value: totalAmount),
                          SizedBox(height: 0.8.h),
                          SummaryRow(label: discount, value: totalDiscount, isDiscount: true),
                          SizedBox(height: 0.8.h),
                          SummaryRow(label: protectPromiseFee, value: shipping ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.2.h),
                            child: Divider(color: dividerColor,height: 1),
                          ),
                          SummaryRow(label: total,value: displayAmount,isTotal: true),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: successColor.withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(1.h),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: successColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: blackColor.withValues(alpha: .7),
                                      ),
                                      children: [
                                        const TextSpan(text: 'You saved '),
                                        TextSpan(
                                          text: Functions.formatInr(savings),
                                          style: TextStyle(
                                            color: successColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        const TextSpan(text: ' on this order'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: shippingAddress,
                                style: CustomTextStyle.bold,
                                fontSize: 17.px,
                                maxLines: 1,
                              ),
                              Visibility(
                                visible: false,
                                child: TextButton(onPressed: () async {
                                  final result =  await getIt<AppRoutes>().push(AddressListRoute(isFrom: orderDetails,orderId: orderData?.id ?? 0));
                                  if (result == true) {
                                    addressBloc.add(AddressListEvent());
                                  }
                                }, child: CustomText(text: change,style: CustomTextStyle.bold,fontSize: 15.px,)),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          CustomText(
                            text: orderData?.address?.full_name ?? '',
                            style: CustomTextStyle.bold,
                            fontSize: 15.px,
                          ),
                          CustomText(
                            text: orderData?.address?.phone ?? '',
                            style: CustomTextStyle.regular,
                            fontSize: 15.px,
                            color: greyColor.withValues(alpha: .8),
                          ),
                          CustomText(
                            text: orderData?.address?.address_line ?? '',
                            style: CustomTextStyle.regular,
                            fontSize: 14.px,
                            color: greyColor.withValues(alpha: .6),
                          ),
                          CustomText(
                            text:
                            "${orderData?.address?.city ?? ''}, "
                                "${orderData?.address?.state ?? ''}, "
                                "${orderData?.address?.country ?? ''} - "
                                "${orderData?.address?.pincode ?? ''}",
                            fontSize: 14.px,
                            color: greyColor.withValues(alpha: .6),
                            maxLines: 5,
                            style: CustomTextStyle.regular,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Visibility(
                                visible: orderData?.status == orderPlaced ||
                                    orderData?.status == orderShipped,
                                child: Expanded(
                                  child: CustomButton(
                                    text: cancelOrder,
                                    onPressed: () {
                                      orderBloc.add(OrderCancelEvent(orderData?.id ?? 0));
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: orderData?.status == orderDelivered,
                                child: Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.w),
                                    child: CustomButton(
                                      text: invoice,
                                      onPressed: () {
                                        orderBloc.add(OrderInvoiceEvent(orderData?.id ?? 0));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),

                  );
                }
                return SizedBox();


            }
          ),
        ),
      ),
    );
  }
  static Widget infoTile({
      String title = '',
      String value = '',
      bool isHorizontal = false,
  }) {
    return isHorizontal? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: greyColor.withValues(alpha: .6),
        ),
        SizedBox(width: 2.w),
        CustomText(
          text: value,
          style: CustomTextStyle.bold,
          fontSize: 15.px,
        ),
      ],
    ):
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
            color: greyColor.withValues(alpha: .6),
        ),
        SizedBox(height: 1.h),
        CustomText(
          text: value,
            style: CustomTextStyle.bold,
            fontSize: 15.px,
        ),
      ],
    );
  }

}
