// ignore_for_file: must_be_immutable
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comm_user/bloc/category/category_bloc.dart';
import 'package:e_comm_user/bloc/category/category_event.dart';
import 'package:e_comm_user/bloc/filter/filter_bloc.dart';
import 'package:e_comm_user/bloc/filter/filter_event.dart';
import 'package:e_comm_user/bloc/filter/filter_state.dart';
import 'package:e_comm_user/bloc/product/product_bloc.dart';
import 'package:e_comm_user/bloc/product/product_event.dart';
import 'package:e_comm_user/bloc/product/product_state.dart';
import 'package:e_comm_user/bloc/search_filed/search_field_bloc.dart';
import 'package:e_comm_user/bloc/search_filed/search_field_state.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_bloc.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_event.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  final String page = '/productsScreen';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc productBloc = getIt<ProductBloc>();
  CategoryBloc categoryBloc = getIt<CategoryBloc>();
  FilterBloc filterBloc = getIt<FilterBloc>();
  WishlistBloc wishlistBloc = getIt<WishlistBloc>();
  // SearchBloc searchBloc = getIt<SearchBloc>();
  ProductResponseModel? productResponseModel;
  List<String> homeItems = [];
  var searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int? selectedCategoryId;
  final minController = TextEditingController();
  final maxController = TextEditingController();
@override
  void initState() {
    super.initState();
    pageNo = 1;
    hasMoreData = true;
    isLoadingMore = false;
    productBloc.add(ProductListEvent(pageNo, limit, ''));
    categoryBloc.add(const TopCategoryLoadEvent());
    scrollController.addListener(onScroll);
  }
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    productBloc.close();
    categoryBloc.close();
    super.dispose();
  }
  onScroll(){
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200
        && !isLoadingMore && hasMoreData){
      isLoadingMore = true;
      pageNo++;
      productBloc.add(ProductListEvent(pageNo, limit, searchController.text, selectedCategoryId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => productBloc),
          BlocProvider(create: (context) => categoryBloc),
          BlocProvider(create: (context) => filterBloc),
          BlocProvider(create: (context) => wishlistBloc),
          // BlocProvider(create: (context) => searchBloc),
          BlocProvider(create: (context) => SearchBloc(
            allItems: homeItems, // use same list for suggestions if needed
            hints: homeItems,    // rotating hints come from API
          )),
        ],
        child: Column(
          children: [
            SizedBox(height: 2.h,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            CustomTextField(
                              controller: searchController,
                              hintText: '',
                              labelText: '',
                              prefixIcon:  Icons.search ,
                              onChanged: (value) {
                                // productBloc.add(ProductSearchEvent(value));
                                productBloc.add(ProductListEvent(pageNo, limit, value, selectedCategoryId));
                              },
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                productBloc.add(ProductListEvent(pageNo, limit, value, selectedCategoryId));
                              },
                            ),
                            ValueListenableBuilder(
                                valueListenable: searchController,
                                builder: (_, value, __) {
                                return Visibility(
                                  visible:(value.text.isEmpty),
                                  child: IgnorePointer(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 13.w,top: .7.h),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        child: CustomText(
                                          text:state.hint,
                                          key: ValueKey(state.hint),
                                            color: greyColor.withValues(alpha: .5),
                                            fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                          ],
                        );
                      }
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
                          icon: SvgPicture.asset(state.productFilter.isFilterApplied ? filterIcon : noFilterIcon),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (state is ProductSuccessState) {
                    productResponseModel = state.productResponseModel;
                    isLoadingMore = false;
              
                    if ((state.productResponseModel.data?.items?.length ?? 0) < pageNo * limit) {
                      hasMoreData = false;
                    }
                    return ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   childAspectRatio: 0.62,
                      //   crossAxisSpacing: 10,
                      //   mainAxisSpacing: 10,
                      // ),
                      itemCount: (productResponseModel?.data?.items?.length ?? 0) + 1,
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        if (index == productResponseModel?.data?.items?.length) {
                          return state.hasMore
                              ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),)
                              : const SizedBox();
                        }
                        final product = productResponseModel?.data?.items?[index];
                        final days = Functions.getEstimatedDeliveryDays(product?.id.toString());

                        final deliveryDate = DateTime.now().add(Duration(days: days));

                        final productDeliveryDate = "Delivery by ${Functions.formatDateTime(
                          deliveryDate.toString(),
                          format: 'dd MMM yyyy',
                        )}";
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: GestureDetector(
                            onTap: () {
                              getIt<AppRoutes>().push(ProductDetailsRoute(productId: product?.id ?? 0));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all( Radius.circular(10)),
                                      child: product?.images != null && product!.images!.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: product.images![0].image_url ?? '',
                                              fit: BoxFit.cover,
                                              width: 30.w,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            )
                                          : Container(
                                              color: Colors.grey[200],
                                              child: Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                                            ),
                                    ),
                                    Positioned(
                                         right: 0.w,
                                        child: BlocBuilder<WishlistBloc,WishlistState>(
                                          builder: (context, state) {
                                            final items =state is WishlistLoadedState
                                                ? state.items : wishlistBloc.currentWishlistItems;

                                            final isInWishlist = items.any(
                                                  (item) => item.product_id == product?.id,
                                            );
                                            return IconButton(

                                              onPressed: () {
                                                if (isInWishlist) {
                                                  final wishlistItem =
                                                  items.firstWhere((item) => item.product_id == product?.id,
                                                  );
                                                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                  wishlistBloc.add(
                                                    RemoveFromWishlistEvent(
                                                       product?.id ?? 0, wishlistItemId:  wishlistItem.id,
                                                    ),
                                                  );
                                                  });
                                                  Functions.showCustomSnackBar(context,
                                                    message: removedFromWishlist,
                                                    backgroundColor: errorColor,
                                                  );
                                                  return;
                                                }

                                                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                    wishlistBloc.add(
                                                      AddToWishlistEvent(
                                                        product?.id ?? 0,
                                                        product?.name ?? '',
                                                        product?.price ?? 0,
                                                        product?.discount ?? 0,
                                                        product?.discount_price ?? 0,
                                                        productImageUrl: product?.images  ?.isNotEmpty ==  true
                                                            ? product?.images!.first.image_url: null,
                                                      ),
                                                    );
                                                  },);
                                                  Functions.showCustomSnackBar(
                                                    context,
                                                    message: addedToWishlist,
                                                    backgroundColor:  successColor,
                                                  );

                                              },
                                              icon: Icon(
                                                isInWishlist ? Icons.favorite : Icons.favorite_border,
                                                color: isInWishlist  ? errorColor : blackColor,
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:product?.name ?? '',
                                            style: CustomTextStyle.bold,
                                            fontSize: 14,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: List.generate(5, (index) {
                                            double rating = Functions.getRating(product?.id ?? 0);

                                            return Icon(
                                              index < rating ? Icons.star : Icons.star_border,
                                              color: successColor,
                                              size: 18,
                                            );
                                          }),
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          children: [
                                            Icon(Icons.arrow_downward, size: 16,color: successColor),
                                            CustomText(
                                              text:'${product?.discount}% ',
                                              style: CustomTextStyle.bold,
                                              fontSize: 20.px,
                                              color: successColor,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: CustomText(
                                                text:'₹${Functions.formatPrice(product?.price)}',
                                                   style: CustomTextStyle.bold,
                                                  fontSize: 16,
                                                  color: blackColor.withValues(alpha: .2),
                                                decoration: TextDecoration.lineThrough,
                                                decorationColor: blackColor.withValues(alpha: .2),
                                               ),
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                text:'₹${Functions.formatPrice(product?.discount_price)}',
                                                   style: CustomTextStyle.bold,
                                                  fontSize: 16,
                                                  color: blackColor,
                                               ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        CustomText(
                                          text: product?.category_name ?? '',
                                             fontSize: 12,
                                            color: greyColor,
                                        ),
                                        SizedBox(height: 4),
                                        CustomText(
                                          text: productDeliveryDate,
                                          fontSize: 12,
                                          color: greyColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else if(state is ProductErrorState){
                    return Center(child: CustomText(text: state.error, color: errorColor));
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showFilterBottomSheet(BuildContext context,) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      builder: (_) {
        return BlocProvider.value(
            value: filterBloc,
          child: BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              final filter = state.productFilter;
              minController.text = filter.min_price.toInt().toString();
              maxController.text = filter.max_price.toInt().toString();
              return Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisSize:MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: filters,fontSize: 20.px,style: CustomTextStyle.bold,),
                    SizedBox(height: 3.h),
                    /// PRICE
                    CustomText(text: priceRange),
                    RangeSlider(
                      values: RangeValues(
                        filter.min_price,
                        filter.max_price,
                      ),
                      min: 0,
                      max: 50000,
                      activeColor: primaryColor,
                      inactiveColor: primaryColor.withValues(alpha: .5),
                      divisions: 100,
                      labels: RangeLabels(
                        filter.min_price.toInt().toString(),
                        filter.max_price .toInt().toString(),
                      ),
                      onChanged: (values) {
                        filterBloc.add(UpdatePriceRangeEvent(values));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: filter.min_price.toStringAsFixed(2)),
                        CustomText(text: filter.max_price.toStringAsFixed(2)),
                      ],
                    ),
                    Visibility(
                      visible: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: minController,
                              keyboardType:TextInputType.number,
                              onChanged: (value) {
                                final min = double.tryParse(value) ?? 0;
                                if (min <= filter.max_price){
                                  filterBloc.add(
                                    UpdatePriceRangeEvent(
                                      RangeValues(min, filter.max_price),
                                    ),
                                  );
                                }
                              }, labelText: minPrice,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomTextField(
                              controller: maxController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final max = double.tryParse(value) ??  500000;
                                if (max >= filter.min_price){
                                  filterBloc.add(
                                    UpdatePriceRangeEvent(
                                      RangeValues(filter.min_price, max),
                                    ),
                                  );
                                }
                              }, labelText: maxPrice,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// SORT BY
                    CustomText(text: sortBy),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: sortOptions.map((e) {
                        return filterChip(
                          title: e['title'].toString(),
                          isSelected: filter.sort_by == e['value'],
                          onTap: () {
                            filterBloc.add(
                              UpdateSortByEvent(
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
                          isSelected: filter.order ==e['value'],
                          onTap: () {
                            filterBloc.add(
                              UpdateOrderEvent(e['value'].toString()),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                filterBloc.add(ClearFilterEvent());
                                productBloc.add( ProductListEvent(pageNo, limit, ''));
                                getIt<AppRoutes>().pop();
                              },);
                            },
                            backgroundColor: primaryColor.withValues(alpha: .7),
                            text: clearFilter,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              filterBloc.add(ApplyFilterEvent());
                              productBloc.add( ProductListEvent(pageNo, limit, '',selectedCategoryId,filter));
                              context.router.pop();
                            },
                            text: applyFilter,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h)
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
