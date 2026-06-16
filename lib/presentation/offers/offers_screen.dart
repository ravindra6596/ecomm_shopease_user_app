// ignore_for_file: must_be_immutable
import 'dart:developer';

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
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OffersScreen extends StatefulWidget {
    OffersScreen({super.key,this.categoryId  });
  int? categoryId = 0;

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>  with SingleTickerProviderStateMixin{
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
    log('Category Id Offer ${widget.categoryId}');
    // categoryBloc.add(CategorySelectEvent( widget.categoryId ?? 1,0));
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
        title: offersText,
       ),
      body: BlocProvider (
       create: (context) => categoryBloc..add(CategoryDetailsEvent( widget.categoryId ?? 1 )),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            // ── Full screen initial loading ──────────────────────────────────
            if (state is CategoryDetailsLoadingState) {
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
            if (state is CategoryDetailsSuccessState) {
              CategoryData categoryData= state.categoryData;
              _animController.forward(from: 0);

              final products = categoryData.products ?? [];

              return Row(
                children: [
                  // ── RIGHT: Category Details + Products ───────────────────
                  Expanded(
                    child: _buildCategoryDetails(context, categoryData, products),

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
                    text: '₹${Functions.formatPrice(product.price ?? 0)}',
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
