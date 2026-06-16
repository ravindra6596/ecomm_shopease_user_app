// ignore_for_file: must_be_immutable
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback onContinueShopping;
  String title;
  String description;
  String buttonTitle;
  IconData icon;

  EmptyCartWidget({
    super.key,
    this.title = '',
    this.description = '',
    this.buttonTitle = '',
    this.icon = Icons.shopping_cart_outlined,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: greyColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24.w,
                color: primaryColor.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 3.h),
            CustomText(
              text: title,
                fontSize: 20.sp,
                style: CustomTextStyle.semiBold,
                color: blackColor,

            ),
            SizedBox(height: 1.h),
            CustomText(
              text: description,

              textAlign: TextAlign.center,

                fontSize: 15.sp,
              style: CustomTextStyle.regular,
                color: greyColor.withValues(alpha: 0.6),

            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              height: 5.5.h,
              child: OutlinedButton(
                onPressed: onContinueShopping,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(
                    color: primaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: CustomText(
                  text: buttonTitle,
                    color: primaryColor,
                    fontSize: 16.sp,
                  style: CustomTextStyle.semiBold,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
