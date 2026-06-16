import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: greyColor.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(1.h),
        ),
        child: CustomText(
          text: date,
            fontSize: 12.px,
            style: CustomTextStyle.semiBold,
          color: blackColor,
        ),
      ),
    );
  }
}