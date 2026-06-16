import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:flutter/material.dart';

enum CustomTextStyle {
  regular,
  medium,
  semiBold,
  bold,
}

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextStyle style;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;

  const CustomText({
    super.key,
    required this.text,
    this.style = CustomTextStyle.regular,
    this.fontSize,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.decoration,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamilyText,
        fontWeight: _getFontWeight(),
        fontSize: fontSize ?? 14,
        color: color ?? blackColor,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  FontWeight _getFontWeight() {
    switch (style) {
      case CustomTextStyle.regular:
        return FontWeight.w400;
      case CustomTextStyle.medium:
        return FontWeight.w500;
      case CustomTextStyle.semiBold:
        return FontWeight.w600;
      case CustomTextStyle.bold:
        return FontWeight.w700;
    }
  }
}
