import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          CustomText(
            text:
            'Loading your cart...',
               fontSize: 16.sp,
              style: CustomTextStyle.regular,
              color: greyColor.withValues(alpha: .6),
           ),
        ],
      ),
    );
  }
}

class SyncCartLoadingWidget extends StatelessWidget {
  const SyncCartLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor.withValues(alpha: .5),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12.w,
                height: 12.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              CustomText(
                text:
                'Syncing your cart...',
                   fontSize: 15.sp,
                  style: CustomTextStyle.medium,
                  color: blackColor.withValues(alpha: .7),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
