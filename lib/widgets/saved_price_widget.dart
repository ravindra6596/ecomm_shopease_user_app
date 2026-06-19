// ignore_for_file: must_be_immutable
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SavedPriceWidget extends StatefulWidget {
  final int savingAmount;
  const SavedPriceWidget({
    super.key,
    required this.savingAmount,
  });

  @override
  State<SavedPriceWidget> createState() => _SavedPriceWidgetState();
}

class _SavedPriceWidgetState extends State<SavedPriceWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scale;
  late final Animation<double> glow;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    scale = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    glow = Tween<double>(
      begin: 0.1,
      end: 0.25,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: scale.value,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(1.h),
              boxShadow: [
                BoxShadow(
                  color: successColor.withValues(alpha: glow.value),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: successColor.withValues(alpha: .7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration_rounded,
                  color: successColor,
                ),
                SizedBox(width: 1.w),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: blackColor.withValues(alpha: 0.75),
                        fontFamily: fontFamilyText
                      ),
                      children: [
                        TextSpan(text: youSaved),
                        TextSpan(
                          text: Functions.formatInr(widget.savingAmount),
                          style: TextStyle(
                            color: successColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        TextSpan(text: onThisOrder),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
