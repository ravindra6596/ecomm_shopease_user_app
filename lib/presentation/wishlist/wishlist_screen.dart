import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comm_user/bloc/navigation/navigation_bloc.dart';
import 'package:e_comm_user/bloc/navigation/navigation_event.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_bloc.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_event.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/cart/empty_cart_widget.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


@RoutePage()
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() =>
      _WishlistScreenState();
}

class _WishlistScreenState
    extends State<WishlistScreen> {
  WishlistBloc wishlistBloc = getIt<WishlistBloc>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (mounted) {
        if (!wishlistBloc.isClosed) {
          wishlistBloc.add(GetWishlistItemsEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,

      appBar: CustomAppBar(
        title: wishlist,
        showBackButton: false,
        backgroundColor: whiteColor,
      ),

      body: BlocProvider(
        create: (context) => wishlistBloc,
        child: BlocConsumer<
            WishlistBloc,
            WishlistState>(
          listenWhen: (previous, current) =>
          current
          is WishlistErrorState ||
              current
              is SyncWishlistSuccessState ||
              current
              is SyncWishlistFailureState,

          listener: (context, state) {
            if (state
            is WishlistErrorState) {
              Functions.showCustomSnackBar(
                context,
                message: state.error,
                backgroundColor:
                errorColor,
              );
            } else if (state
            is SyncWishlistSuccessState) {
              Functions.showCustomSnackBar(
                context,
                message: state.message,
                backgroundColor:
                successColor,
              );
            } else if (state
            is SyncWishlistFailureState) {
              Functions.showCustomSnackBar(
                context,
                message: state.error,
                backgroundColor:
                errorColor,
              );
            }
          },

          buildWhen: (previous, current) =>
          current
          is WishlistLoadingState ||
              current
              is WishlistLoadedState ||
              current
              is WishlistErrorState ||
              current
              is SyncWishlistLoadingState,

          builder: (context, state) {
            if (state
            is WishlistLoadingState &&
                wishlistBloc
                    .currentWishlistItems
                    .isEmpty) {
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            if (state
            is SyncWishlistLoadingState) {
              return Stack(
                children: [
                  _buildWishlistContent(
                    wishlistBloc
                        .currentWishlistItems,
                  ),

                  const Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (state
            is WishlistLoadedState) {
              return _buildWishlistContent(
                state.items,
              );
            }

            if (state
            is WishlistErrorState &&
                wishlistBloc
                    .currentWishlistItems
                    .isEmpty) {
              return Center(
                child: Text(state.error),
              );
            }

            if (wishlistBloc
                .currentWishlistItems
                .isNotEmpty) {
              return _buildWishlistContent(
                wishlistBloc
                    .currentWishlistItems,
              );
            }

            return const Center(
              child: Text(
                'Wishlist is empty',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistContent(
      List<WishlistItem> items,
      ) {
    if (items.isEmpty) {
      return EmptyCartWidget(
        title: wishlistEmpty,
        description: wishlistEmptyDesc,
        buttonTitle: exploreProducts,
        icon: Icons.favorite_border,
        onContinueShopping: () {
          context.read<NavigationBloc>().add(
            const NavigationTabChangedEvent(0),
          );
          context.router.popUntilRoot();
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        4.w,
        2.h,
        4.w,
        2.h,
      ),

      itemCount: items.length,

      itemBuilder: (context, index) {
        final item = items[index];

        final productId =
            item.product_id ?? 0;

        return WishlistItemWidget(
          item: item,

          onTap: productId > 0
              ? () => context.router.push(
            ProductDetailsRoute(
              productId:
              productId,
            ),
          )
              : null,

          onRemove: () {
            wishlistBloc.add(
              RemoveFromWishlistEvent(
                productId,
                wishlistItemId:
                item.id,
              ),
            );

            Functions.showCustomSnackBar(
              context,
              message:
              'Item removed from wishlist',
              backgroundColor:
              errorColor,
            );
          },
        );
      },
    );
  }
}
class WishlistItemWidget extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback? onTap;
  final VoidCallback onRemove;

  const WishlistItemWidget({
    super.key,
    required this.item,
    this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.product_image_url ?? '',
                width: 24.w,
                height: 24.w,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(
                      width: 24.w,
                      height: 24.w,
                      color: greyColor.withOpacity(0.1),
                      child: const Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    ),
                errorWidget:
                    (context, url, error) =>
                    Container(
                      width: 24.w,
                      height: 24.w,
                      color:
                      greyColor.withOpacity(0.1),
                      child: Icon(
                        Icons.image_not_supported,
                        color: greyColor,
                        size: 8.w,
                      ),
                    ),
              ),
            ),

            SizedBox(width: 3.w),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product_name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  ),

                   



                  SizedBox(height: 1.5.h),

                  Row(
                    children: [
                      Expanded(
                        child:Text(
                          '₹${item.product_price ?? 0}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      SizedBox(width: 2.w),

                      GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding:
                          EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: errorColor
                                .withOpacity(0.1),
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: errorColor,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ],
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
