import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const CartErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
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
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 20.w,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 2.5.h),
            CustomText(
              text:
              'Something went wrong',
                fontSize: 18.sp,
                style: CustomTextStyle.semiBold,
                color: Colors.black87,
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomText(
                text:
                error,
                textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  style: CustomTextStyle.regular,
                  color: greyColor.withValues(alpha: .6),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              height: 5.5.h,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: CustomText(
                  text: 'Try Again',
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
