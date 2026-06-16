import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comm_user/bloc/category/category_bloc.dart';
import 'package:e_comm_user/bloc/category/category_event.dart';
import 'package:e_comm_user/bloc/category/category_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/category_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>  with SingleTickerProviderStateMixin{
  CategoryBloc categoryBloc = getIt<CategoryBloc>();
  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(_fade);

    categoryBloc.add(CategoryLoadEvent(1, limit));
  }
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        title: categories,
        showBackButton: false,
      ),
      body: BlocProvider.value(
        value: categoryBloc,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            // ── Full screen initial loading ──────────────────────────────────
            if (state is CategoryLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            // ── Full screen error (only for list load failure) ───────────────
            if (state is CategoryErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(Icons.error_outline,
                        size: 48, color: errorColor),
                    const SizedBox(height: 12),
                    CustomText(
                      text: state.error,
                      fontSize: 14,
                      color: greyColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        categoryBloc.add(CategoryLoadEvent(1, limit));
                      },
                      child: CustomText(text: retry),
                    ),
                  ],
                ),
              );
            }

            // ── Main content ─────────────────────────────────────────────────
            if (state is CategoriesSuccessState) {
              _animController.forward(from: 0);
              final categories = categoryBloc.allCategories;
              final hasMoreData = state.hasMore;
              final selectedIndex = state.selectedIndex;
              final selectedCategory = state.selectedCategory;
              final isLoadingDetails = state.isLoadingDetails;
              final detailsError = state.detailsError;
              final products = selectedCategory?.products ?? [];

              return Row(
                children: [
                  // ── LEFT: Category List ──────────────────────────────────
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                    color: whiteColor,
                      border: Border(right: BorderSide(color: blackColor,width: .2))
                    ),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!hasMoreData || categoryBloc.isLoadingMore) {
                          return false;
                        }
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 50) {
                          categoryBloc.add(
                            CategoryLoadEvent(
                              categoryBloc.pageNo + 1,
                              limit,
                            ),
                          );
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                        categories.length + (hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Pagination loader at the bottom
                          if (index == categories.length) {
                            return const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                ),
                              ),
                            );
                          }

                          final category = categories[index];
                          final isSelected = selectedIndex == index;
                          final img =
                          category.images?.isNotEmpty == true
                              ? category.images!.first.image_url ?? ''
                              : '';

                          return GestureDetector(
                            onTap: () {
                              if (selectedIndex == index) return;
                              categoryBloc.add(CategorySelectEvent(
                                category.id ?? 0,
                                index,
                              ));
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor.withValues(alpha: .12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(.5.h),
                                border: isSelected
                                    ? Border.all(
                                  color: primaryColor.withValues(
                                      alpha: .3),
                                  width: 1,
                                )
                                    : null,
                              ),
                              child: Column(
                                children: [
                                  // Category image
                                  img.isNotEmpty
                                      ? CachedNetworkImage(
                                    imageUrl: img,
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.contain,
                                    placeholder: (_, __) =>
                                    const SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Center(
                                        child:
                                        CircularProgressIndicator(
                                            strokeWidth: 1.5),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) =>
                                    const Icon(
                                      Icons.image_not_supported,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  )
                                      : const Icon(
                                    Icons.category,
                                    size: 28,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(height: 6),

                                  // Category name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: CustomText(
                                      text: category.name ?? '',
                                      textAlign: TextAlign.center,
                                      fontSize: 11,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: isSelected
                                          ? CustomTextStyle.bold
                                          : CustomTextStyle.regular,
                                      color: isSelected
                                          ? primaryColor
                                          : greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── RIGHT: Category Details + Products ───────────────────
                  Expanded(
                    child: isLoadingDetails
                        ? const Center(child: CircularProgressIndicator())
                        : detailsError != null
                        ? _buildDetailsError(detailsError)
                        : selectedCategory == null
                        ?   Center(
                      child: CustomText(
                        text: selectACategory,
                        fontSize: 14,
                        color: greyColor,
                      ),
                    )
                        :  _buildCategoryDetails(context, selectedCategory, products),

                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDetailsError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40, color: errorColor),
            const SizedBox(height: 10),
            CustomText(
              text: error,
              fontSize: 13,
              color: greyColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () {
                if (categoryBloc.selectedCategoryId != null) {
                  categoryBloc.add(
                    CategorySelectEvent(
                      categoryBloc.selectedCategoryId!,
                      categoryBloc.selectedCategoryIndex,
                    ),
                  );
                }
              },
              text: retry,
            ),
          ],
        ),
      ),
    );
  }

  // ── Category details + products grid ──────────────────────────────────────
  Widget _buildCategoryDetails(
      BuildContext context,
      CategoryData selectedCategory,
      List products,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      // color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category header card ─────────────────────────────────────────
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withValues(alpha: .1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Category image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: selectedCategory.images != null &&
                          selectedCategory.images!.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl:
                        selectedCategory.images!.first.image_url ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 60,
                          height: 60,
                          color: lightGreyColor,
                          child: const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: lightGreyColor,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 28,
                            color: Colors.grey,
                          ),
                        ),
                      )
                          : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: lightGreyColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.category,
                          size: 30,
                          color: greyColor,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Category name + product count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: selectedCategory.name ?? 'Category',
                            fontSize: 16,
                            style: CustomTextStyle.bold,
                            color: blackColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: '${selectedCategory.products_count ?? 0} products',
                            fontSize: 13,
                            color: greyColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Products grid ────────────────────────────────────────────────
          Expanded(
            child: products.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 10),
                  CustomText(
                    text: noProductsAvailable,
                    fontSize: 14,
                    color: greyColor,
                  ),
                ],
              ),
            )
                : TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
                  child: GridView.builder(
                                itemCount: products.length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.72,
                                ),
                                itemBuilder: (context, index) {
                                    final product = products[index];
                                    return _buildProductCard(context, product, index);
                                },
                              ),
                ),
          ),
        ],
      ),
    );
  }

  // ── Product card ───────────────────────────────────────────────────────────
  Widget _buildProductCard(
      BuildContext context, dynamic product, int index) {
    return GestureDetector(
      onTap: () {
        context.router.push(ProductDetailsRoute(productId: product.id ?? 0));
      },
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: greyColor.withValues(alpha: .1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  color: lightGreyColor,
                  child: product.images != null &&
                      product.images!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl:
                    product.images!.first.image_url ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 36,
                      color: Colors.grey,
                    ),
                  )
                      : const Icon(
                    Icons.image,
                    size: 36,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: product.name ?? 'Product ${index + 1}',
                    fontSize: 13,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle.medium,
                    color: blackColor,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text:'₹${Functions.formatPrice(product?.price)}',
                    style: CustomTextStyle.bold,
                    fontSize: 16,
                    color: blackColor.withValues(alpha: .2),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: blackColor.withValues(alpha: .2),
                  ),

                  const SizedBox(height: 4),
                  CustomText(
                    text: '₹${Functions.formatPrice(product.discount_price ?? 0)}',
                    fontSize: 14,
                    color: primaryColor,
                    style: CustomTextStyle.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
