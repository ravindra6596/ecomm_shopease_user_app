import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/filter/filter_bloc.dart';
import 'package:e_comm_user/bloc/filter/filter_event.dart';
import 'package:e_comm_user/bloc/filter/filter_state.dart';
import 'package:e_comm_user/bloc/navigation/navigation_bloc.dart';
import 'package:e_comm_user/bloc/order/order_bloc.dart';
import 'package:e_comm_user/bloc/order/order_event.dart';
import 'package:e_comm_user/bloc/order/order_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/cart/cart_item_widget.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:e_comm_user/widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  OrderBloc orderBloc = getIt<OrderBloc>();
  NavigationBloc navigationBloc = getIt<NavigationBloc>();
  FilterBloc filterBloc = getIt<FilterBloc>();
  var searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int? selectedCategoryId;
  final minController = TextEditingController();
  final maxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    orderBloc.add(OrderListEvent(pageNo, limit, ''));
    scrollController.addListener(onScroll);
  }
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    orderBloc.close();
    super.dispose();
  }
  onScroll(){
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200
        && !isLoadingMore && hasMoreData){
      isLoadingMore = true;
      pageNo++;
      orderBloc.add(OrderListEvent(pageNo, limit, searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(title: orders),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => orderBloc),
          BlocProvider(create: (context) => navigationBloc),
          BlocProvider(create: (context) => filterBloc),
        ],
        child: RefreshIndicator(
          onRefresh: () async{
            orderBloc.add(OrderListEvent(pageNo, limit, ''));
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                  Expanded(
                    child: CustomTextField(
                      controller: searchController,
                      hintText: 'Search orders...',
                      labelText: '',
                      prefixIcon:  Icons.search ,
                      onChanged: (value) {
                        orderBloc.add(OrderListEvent(pageNo, limit, value,));
                      },
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        orderBloc.add(OrderListEvent(pageNo, limit, value,));
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.only(top: 1.5.h),
                        child: IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            showFilterBottomSheet(context);
                          },
                          icon: SvgPicture.asset(state.orderFilter.isFilterApplied ? filterIcon : noFilterIcon),
                        ),
                      );
                    },
                  ),
                ],
                ),
              ),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoadingState) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  else if (state is OrderSuccessState) {
                    orderResponseModel = state.orderResponseModel;
                    isLoadingMore = false;

                    if ((state.orderResponseModel.data?.items?.length ?? 0) < pageNo * limit) {
                      hasMoreData = false;
                    }
                    return state.orderResponseModel.data!.items!.isEmpty ?
                    Expanded(
                      child: NoDataFoundWidget(
                        title: noOrdersFound,
                        subtitle: '',

                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: (orderResponseModel.data?.items?.length ?? 0) + 1,
                        padding: EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          if (index == orderResponseModel.data?.items?.length) {
                            return state.hasMore
                                ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),)
                                : const SizedBox();
                          }
                          final order = orderResponseModel.data?.items?[index];
                          final subtotal = order?.total_amount ?? 0;
                          final discount = order?.total_discount_price ?? 0;
                          final shipping = order?.shipping ?? 0;

                          final totalAmount = shipping + discount;
                          return GestureDetector(
                            onTap: () {
                              getIt<AppRoutes>().push(OrderDetailsRoute(orderId: order?.id ?? 0));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: dividerColor),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductThumbnail(imageUrl: order?.items![0].image_url ?? ''),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomText(
                                                text: order?.items![0].product_name ?? '',
                                                style: CustomTextStyle.semiBold,
                                                fontSize: 15.sp,
                                                color: blackColor,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CustomText(
                                                text: Functions.formatInr(subtotal),
                                                style: CustomTextStyle.bold,
                                                fontSize: 15.sp,
                                                color: greyColor,
                                                decoration: TextDecoration.lineThrough,
                                                decorationColor: greyColor,
                                              ),
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                text: Functions.formatInr(totalAmount),
                                                style: CustomTextStyle.bold,
                                                fontSize: 15.sp,
                                                color: successColor,
                                              ),
                                            ),
                                        /// STATUS
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3.w,
                                                vertical: .7.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: getOrderStatusColor(
                                                  order?.status ?? '',
                                                ).withValues(alpha: .1),
                                                borderRadius: BorderRadius.circular(.8.h),
                                                border: Border.all(
                                                  color: getOrderStatusColor(
                                                    order?.status ?? '',
                                                  ),
                                                ),
                                              ),
                                              child: CustomText(
                                                text: (order?.status ?? '').toUpperCase(),
                                                style: CustomTextStyle.bold,
                                                fontSize: 12.sp,
                                                color: getOrderStatusColor(
                                                  order?.status ?? '',
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                        SizedBox(height: 1.2.h),

                                      ],
                                    ),
                                        CustomText(
                                          text: Functions.formatDateTime(order?.created_at ?? '',format: 'dd MMM yyyy'),
                                          style: CustomTextStyle.medium,
                                          fontSize: 12.px,
                                          color: greyColor,
                                        ),
                                 ] ),
                            ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  else if(state is OrderErrorState){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(child: CustomText(text: state.message, color: errorColor)),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showFilterBottomSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      builder: (_) {
        return BlocProvider.value(
          value: filterBloc,
          child: BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              final filter = state.orderFilter;
              return Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    CustomText(
                      text: filters,
                      fontSize: 20.px,
                      style: CustomTextStyle.bold,
                    ),
                    SizedBox(height: 3.h),
                    /// ORDER STATUS
                    CustomText(text: 'Order Status'),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: orderStatusOptions.map((e) {
                        return filterChip(
                          title: e['title'].toString(),
                          isSelected: filter.order_status == e['value'],
                          onTap: () {
                            filterBloc.add(
                              UpdateOrderStatusEvent(
                                e['value'].toString(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(height: 2.h),
                    /// PAYMENT METHOD
                    CustomText(text: 'Payment Method'),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                      paymentMethodOptions.map((e) {
                        return filterChip(
                          title: e['title'].toString(),
                          isSelected: filter.payment_method == e['value'],
                          onTap: () {
                            filterBloc.add(
                              UpdatePaymentMethodEvent(
                                e['value'].toString(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),
                    /// SORT BY
                    CustomText(text: sortBy),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: orderSortOptions.map((e) {
                        return filterChip(
                          title: e['title'].toString(),
                          isSelected: filter.sort_by == e['value'],
                          onTap: () {
                            filterBloc.add(
                              UpdateOrderSortByEvent(
                                e['value'].toString(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),
                    /// ORDER
                    CustomText(text: order),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: orderOptions.map((e) {
                        return filterChip(
                          title: e['title'].toString(),
                          isSelected: filter.order == e['value'],
                          onTap: () {
                            filterBloc.add(
                              UpdateOrderSortEvent(
                                e['value'].toString(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 3.h),
                    /// BUTTONS
                    Row(
                      children: [
                        /// CLEAR
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                  filterBloc.add(ClearOrderFilterEvent());
                                  pageNo = 1;
                                  orderBloc.add(OrderListEvent(pageNo, limit, ''));
                                  getIt<AppRoutes>().pop();
                                },
                              );
                            },
                            backgroundColor:primaryColor.withValues(alpha: .7),
                            text: clearFilter,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        /// APPLY
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              filterBloc.add(ApplyOrderFilterEvent());
                              pageNo = 1;
                              orderBloc.add(OrderListEvent(pageNo,limit,'',filter));
                              context.router.pop();
                            },
                            text: applyFilter,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  Widget filterChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : greyColor,
          ),
        ),
        child: CustomText(
          text: title,
          color: isSelected
              ? whiteColor
              : blackColor,
          style: CustomTextStyle.semiBold,
        ),
      ),
    );
  }
}