import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'custom_text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final int? maxLength;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final Color? fillColor;


    const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
      this.onSubmitted,
      this.maxLength,
      this.enabled,
      this.textInputAction,
      this.fillColor
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(visible:labelText.isNotEmpty,child: CustomText(text: labelText, color: blackColor)),
          SizedBox(height: 1.h),
          Theme(
            data: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: primaryColor,
                selectionColor: textSelection,
                selectionHandleColor: selectionHandle,
              ),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              maxLength: maxLength,
              textInputAction: textInputAction ?? TextInputAction.done,
              enabled: enabled ?? true,
              onTap: ()=> onTap,
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              cursorColor: primaryColor,
              style: TextStyle(fontFamily: fontFamilyText,color: blackColor),
              onChanged: onChanged ?? (value) {},
              onFieldSubmitted: onSubmitted ?? (value) {},
              validator: validator,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                hintText: hintText,filled: true,
                fillColor: fillColor ?? Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: BorderSide(color: primaryColor)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: BorderSide(
                    color: textFieldDisableColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: BorderSide(
                    color: errorColor,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: BorderSide(
                    color: errorColor,
                  ),
                ),
                errorStyle: TextStyle(color: errorColor),
                prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
