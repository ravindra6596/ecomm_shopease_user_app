import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor.withValues(alpha: .1),
      height: 15.h,
      width: 30.w,
      child: Container(
        transform: Matrix4.translationValues(0, 2.h, 0),
        child: Image.asset(appLogo,
          fit: BoxFit.cover,),
      ),
    );
  }
}
