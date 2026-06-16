import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomPopupDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositiveTap;
  final VoidCallback? onNegativeTap;
  final Widget? icon;
  final Color? titleColor;
  final Color? descriptionColor;
  final bool barrierDismissible;
  const CustomPopupDialog({
    super.key,
    this.title,
    this.description,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositiveTap,
    this.onNegativeTap,
    this.icon,
    this.titleColor,
    this.descriptionColor,
    this.barrierDismissible = true,
  });

  static Future<bool?> show(
      BuildContext context, {
        String? title,
        String? description,
        String? positiveButtonText,
        String? negativeButtonText,
        VoidCallback? onPositiveTap,
        VoidCallback? onNegativeTap,
        Widget? icon,
        Color? titleColor,
        Color? descriptionColor,
        bool barrierDismissible = true,
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return CustomPopupDialog(
          title: title,
          description: description,
          positiveButtonText: positiveButtonText,
          negativeButtonText: negativeButtonText,
          onPositiveTap: onPositiveTap,
          onNegativeTap: onNegativeTap,
          icon: icon,
          titleColor: titleColor,
          descriptionColor: descriptionColor,
          barrierDismissible: barrierDismissible,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ICON
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 18),
            ],

            /// TITLE
            if (title != null)
              CustomText(
                text: title!,
                style: CustomTextStyle.bold,
                fontSize: 20,
                color: titleColor ?? blackColor,
                textAlign: TextAlign.center,
              ),

            if (title != null)
              const SizedBox(height: 10),

            /// DESCRIPTION
            if (description != null)
              CustomText(
                text: description!,
                style: CustomTextStyle.medium,
                fontSize: 14,
                color: descriptionColor ?? greyColor,
                textAlign: TextAlign.center,
                maxLines: 5,
              ),

            if (description != null)
              const SizedBox(height: 24),

            /// BUTTONS
            Row(
              children: [

                /// NEGATIVE BUTTON
                if (negativeButtonText != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);

                        onNegativeTap?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: greyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: CustomText(
                        text: negativeButtonText!,
                        style: CustomTextStyle.medium,
                        fontSize: 14,
                        color: greyColor,
                      ),
                    ),
                  ),

                if (negativeButtonText != null &&
                    positiveButtonText != null)
                  const SizedBox(width: 12),

                /// POSITIVE BUTTON
                if (positiveButtonText != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);

                        onPositiveTap?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: CustomText(
                        text: positiveButtonText!,
                        style: CustomTextStyle.semiBold,
                        fontSize: 14,
                        color: whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}