// ignore_for_file: must_be_immutable
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AccountTile extends StatelessWidget {
  AccountTile({super.key,this.leadingIconName = '',this.title = '',this.trailingIconName,this.titleColor  , this.onTap});
  String?  leadingIconName;
  String  title;
  String?  trailingIconName;
  VoidCallback? onTap;
  Color? titleColor;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          border: Border.all(color: greyColor.withValues(alpha: .1)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(leadingIconName ?? ''),
            SizedBox(width: 3.w),
            Expanded(
              child: CustomText(
                text: title  ,
                style: CustomTextStyle.medium,
                fontSize: 15.px,
                color: titleColor ?? blackColor,
              ),
            ),
            SvgPicture.asset(trailingIconName ?? rightArrowIcon),
          ],
        ),
      ),
    );
  }
}
