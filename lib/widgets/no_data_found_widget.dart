import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? iconPath;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const NoDataFoundWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconPath,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON
            if (iconPath != null)
              Image.asset(
                iconPath!,
                height: 140,
              )
            else
              Icon(
                Icons.inbox_outlined,
                size: 90,
                color: Colors.grey.shade400,
              ),

            const SizedBox(height: 20),

            /// TITLE
            CustomText(
              text: title,
              style: CustomTextStyle.bold,
              fontSize: 22,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            /// SUBTITLE
            CustomText(
              text: subtitle,
              style: CustomTextStyle.medium,
              fontSize: 15,
              color: Colors.grey,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),

            const SizedBox(height: 25),

            /// ACTION BUTTON (optional)
            if (onActionPressed != null && actionText != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: CustomText(
                    text: actionText!,
                    style: CustomTextStyle.semiBold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}