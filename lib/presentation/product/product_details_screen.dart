import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/bloc/cart/cart_event.dart';
import 'package:e_comm_user/bloc/cart/cart_state.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_bloc.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_event.dart';
import 'package:e_comm_user/bloc/onboarding/onboarding_state.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_bloc.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_event.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_state.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/error_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:e_comm_user/bloc/product/product_bloc.dart';
import 'package:e_comm_user/bloc/product/product_event.dart';
import 'package:e_comm_user/bloc/product/product_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';

@RoutePage()
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final int productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>   with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();
  final ProductBloc productBloc = getIt<ProductBloc>();
  final OnboardingBloc onboardingBloc = getIt<OnboardingBloc>();
  final CartBloc cartBloc = getIt<CartBloc>();
  final WishlistBloc wishlistBloc = getIt<WishlistBloc>();
  int currentImageIndex = 0;
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
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);
    _loadProductAndCart();
  }

  @override
  void didUpdateWidget(ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _loadProductAndCart();
    }
  }

  void _loadProductAndCart() {
    productBloc.add(ProductDetailsEvent(widget.productId));
    onboardingBloc.add(OnboardingPageChangedEvent(0));
    cartBloc.add(GetCartItemsEvent());
  }

  @override
  void dispose() {
    _animController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => productBloc),
        BlocProvider.value(value: cartBloc),
        BlocProvider.value(value: wishlistBloc),
      ],
      child: Scaffold(
        backgroundColor: whiteColor,
          appBar: CustomAppBar(
            title: productDetails,
            action: BlocBuilder<WishlistBloc,WishlistState>(
                builder: (context, state) {
                  final items =state is WishlistLoadedState
                      ? state.items : wishlistBloc.currentWishlistItems;

                  final isInWishlist = items.any(
                        (item) => item.product_id == widget.productId,
                  );
                  return IconButton(
                    onPressed: () {
                      if (isInWishlist) {
                        final wishlistItem =
                        items.firstWhere((item) =>
                          item.product_id == widget.productId,
                        );
                        wishlistBloc.add(
                          RemoveFromWishlistEvent(
                            widget.productId, wishlistItemId:  wishlistItem.id,
                          ),
                        );
                        Functions.showCustomSnackBar(context,
                          message: removedFromWishlist,
                          backgroundColor: errorColor,
                        );
                        return;
                      }
                      final productState =  productBloc.state;
                      if (productState is ProductDetailsSuccessState) {
                        final product = productState.product;
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          wishlistBloc.add(
                            AddToWishlistEvent(
                              widget.productId,
                              product.name ?? '',
                              product.price ?? 0,
                              product.discount ?? 0,
                              product.discount_price ?? 0,
                              productImageUrl: product.images  ?.isNotEmpty ==  true
                                  ? product.images!.first.image_url: null,
                            ),
                          );
                        },);
                        Functions.showCustomSnackBar(
                          context,
                          message: addedToWishlist,
                          backgroundColor:  successColor,
                        );
                      }
                    },

                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist  ? errorColor : blackColor,
                    ),
                  );
                },
              ),
          ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductDetailsErrorState) {
                  Functions.showCustomSnackBar(
                    context,
                    message: state.error,
                    backgroundColor: errorColor,
                  );
                }
              },
            ),
            BlocListener<CartBloc, CartState>(
              listenWhen: (previous, current) =>
                  (current is CartLoadedState &&
                      current.snackbarMessage != null) ||
                  current is CartErrorState,
              listener: (context, state) {
                if (state is CartLoadedState &&
                    state.snackbarMessage != null) {
                  Functions.showCustomSnackBar(
                    context,
                    message: state.snackbarMessage!,
                    backgroundColor: successColor,
                  );
                } else if (state is CartErrorState) {
                  Functions.showCustomSnackBar(
                    context,
                    message: state.error,
                    backgroundColor: errorColor,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductDetailsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductDetailsSuccessState) {
                _animController.forward(from: 0);
                return FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: _buildProductDetails(state.product),
                  ),
                );
              } else if (state is ProductDetailsErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: state.error,
                        style: CustomTextStyle.medium,
                      ),
                      SizedBox(height: 16.sp),
                      CustomButton(
                        text: retry,
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _loadProductAndCart();
                          });
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(Product product) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(product.images ?? []),
                SizedBox(height: 20.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: product.name ?? '',
                        style: CustomTextStyle.semiBold,
                        fontSize: 18.sp,
                        color: blackColor,
                      ),
                      SizedBox(height: 8.sp),
                      CustomText(
                        text: product.category_name ?? '',
                        style: CustomTextStyle.regular,
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                      SizedBox(height: 16.sp),
                      Row(
                        children: [
                          Icon(Icons.arrow_downward, size: 16,color: successColor),
                          CustomText(
                            text:'${product.discount}% ',
                            style: CustomTextStyle.bold,
                            fontSize: 20.px,
                            color: successColor,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: CustomText(
                              text:'₹${Functions.formatPrice(product.price)}',
                              style: CustomTextStyle.bold,
                              fontSize: 16,
                              color: blackColor.withValues(alpha: .2),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: blackColor.withValues(alpha: .2),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: CustomText(
                              text:'₹${Functions.formatPrice(product.discount_price)}',
                              style: CustomTextStyle.bold,
                              fontSize: 20.px,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                      if (product.description != null &&
                          product.description!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Description',
                              style: CustomTextStyle.semiBold,
                              fontSize: 16.sp,
                              color: blackColor,
                            ),
                            SizedBox(height: 8.sp),
                            Html(
                              data: product.description ?? '',
                              style: {
                                'body': Style(
                                  fontSize: FontSize(14.sp),
                                  color: greyColor,
                                  fontFamily: fontFamilyText,
                                ),
                                'p': Style(
                                  fontSize: FontSize(14.sp),
                                  color: greyColor,
                                  fontFamily: fontFamilyText,
                                  margin: Margins.only(bottom: 8.sp),
                                ),
                              },
                            ),
                          ],
                        ),
                      SizedBox(height: 20.sp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _ProductCartBar(
          productId: widget.productId,
          product: product,
        ),
      ],
    );
  }

  Widget _buildImageCarousel(List<ProductImage> images) {
    if (images.isEmpty) {
      return SizedBox(
        height: 40.h,
          width: double.infinity,
          child: ErrorImageWidget(),
      );
    }

    return BlocProvider(
      create: (context) => onboardingBloc,
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingPageChangedState) {
            currentImageIndex = state.currentPage;
          }
          return Column(
            children: [
              SizedBox(
                height: 46.h,
                width: double.infinity,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    onboardingBloc.add(OnboardingPageChangedEvent(index));
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: images[index].image_url ?? '',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => ErrorImageWidget(),
                      ),
                    );
                  },
                ),
              ),
              if (images.length > 1)
                Row(
                  children: List.generate(images.length, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.w),
                        height: .5.h,
                        decoration: BoxDecoration(
                          color: index == currentImageIndex
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.2),
                        ),
                      ),
                    );
                  }),
                ),
              Visibility(
                visible: false,
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: images.length,
                  effect: WormEffect(
                    dotWidth: 18.sp,
                    dotHeight: 8.sp,
                    activeDotColor: primaryColor,
                    dotColor: primaryColor.withValues(alpha: .3),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Cart button for one product — checks [productId] against cart items from DB/API.
class _ProductCartBar extends StatelessWidget {
  const _ProductCartBar({
    required this.productId,
    required this.product,
  });

  final int productId;
  final Product product;

  bool _isInCart(List<CartItem> items) {
    return items.any((item) => item.product_id == productId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: buyNowAt,
                  style: CustomTextStyle.regular,
                  fontSize: 12.px,
                  color: blackColor,
                ),
                SizedBox(height: 4.sp),
                CustomText(
                  text: '₹${Functions.formatPrice(product.discount_price ?? 0)}',
                  style: CustomTextStyle.bold,
                  fontSize: 24.px,
                  color: primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50.w - 40.sp,
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartBloc = context.read<CartBloc>();
                final items = state is CartLoadedState
                    ? state.items
                    : cartBloc.currentCartItems;
                final isInCart = _isInCart(items);

                if (isInCart) {
                  return CustomButton(
                    text: goToCart,
                    onPressed: () {
                      getIt<AppRoutes>().replaceAll([
                        MainRoute(key: UniqueKey(),selectedIndex: 3),
                      ]);
                    },
                  );
                }

                return CustomButton(
                  text: addToCart,
                  onPressed: () {
                    cartBloc.add(
                      AddToCartEvent(
                        productId,
                        product.name ?? '',
                        product.price ?? 0,
                        product.discount ?? 0,
                        product.discount_price ?? 0,
                        productImageUrl: product.images?.isNotEmpty == true
                            ? product.images!.first.image_url
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
