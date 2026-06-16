import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final productName = item.product_name ?? 'Unknown Product';
    final productPrice = item.product_price ?? 0;
    final quantity = item.quantity ?? 1;
    final imageUrl = item.product_image_url ?? '';

    return GestureDetector(
      onTap: onTap,
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
            ProductThumbnail(imageUrl: imageUrl),
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
                          text: productName,
                          style: CustomTextStyle.semiBold,
                          fontSize: 15.sp,
                          color: blackColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Icon(
                            Icons.delete_outline,
                            color: errorColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  CustomText(
                    text: Functions.formatInr(productPrice),
                    style: CustomTextStyle.bold,
                    fontSize: 15.sp,
                    color: blackColor,
                  ),
                  SizedBox(height: 1.2.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: QuantityStepper(
                      quantity: quantity,
                      onQuantityChanged: onQuantityChanged,
                    ),
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

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 22.w,
        height: 22.w,
        color: whiteColor,
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: 22.w,
                height: 22.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: greyColor,
                  size: 24.sp,
                ),
              )
            : Icon(
                Icons.shopping_bag_outlined,
                color: greyColor,
                size: 24.sp,
              ),
      ),
    );
  }
}

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantityStepper({super.key, 
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StepperButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
          ),
          Container(
            width: 9.w,
            alignment: Alignment.center,
            child: CustomText(
              text: quantity.toString(),
              style: CustomTextStyle.semiBold,
              fontSize: 14.sp,
              color: blackColor,
            ),
          ),
          StepperButton(
            icon: Icons.add,
            onTap: () => onQuantityChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const StepperButton({super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 8.w,
        height: 8.w,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 16.sp,
          color: onTap != null ? blackColor : greyColor,
        ),
      ),
    );
  }
}
