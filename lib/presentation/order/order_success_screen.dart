// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class OrderSuccessScreen extends StatefulWidget {
  OrderSuccessScreen({super.key,this.orderCreateModel});
  OrderCreateModel? orderCreateModel;
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController scaleController;
  late AnimationController circleController;
  late AnimationController checkController;
  late AnimationController contentController;
  late AnimationController buttonController;

  late Animation<double> scaleAnimation;
  late Animation<double> circleAnimation;
  late Animation<double> checkAnimation;
  late Animation<Offset> contentAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> buttonAnimation;
  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    playSuccessSound();
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    );

    circleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: circleController,
        curve: Curves.easeOutBack,
      ),
    );

    checkAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: checkController,
        curve: Curves.easeOut,
      ),
    );

    contentAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: contentController,
        curve: Curves.easeOut,
      ),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(contentController);

    buttonAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.elasticOut,
      ),
    );

    startAnimations();
  }

  Future<void> startAnimations() async {
    await scaleController.forward();
    await circleController.forward();
    await checkController.forward();
    await contentController.forward();
    await buttonController.forward();
  }
  Future<void> playSuccessSound() async {
    await audioPlayer.play(
      AssetSource(orderSuccessSound),
    );
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    scaleController.dispose();
    circleController.dispose();
    checkController.dispose();
    contentController.dispose();
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            /// BACKGROUND GLOW
            Positioned(
              top: -120,
              left: -80,
              child: Container(
                height: 28.h,
                width: 65.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: successColor.withValues(alpha:.15),
                ),
              ),
            ),

            Positioned(
              bottom: -150,
              right: -120,
              child: Container(
                height: 30.h,
                width: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: successColor.withValues(alpha:.15),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// SUCCESS ANIMATION
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        scaleController,
                        circleController,
                        checkController,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: scaleAnimation.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              /// OUTER RIPPLE
                              Container(
                                height: 20.h,
                                width: 42.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: successColor.withValues(alpha:.1),
                                ),
                              ),

                              Container(
                                height: 20.h,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: successColor.withValues(alpha:.15),
                                ),
                              ),

                              /// MAIN CIRCLE
                              Transform.scale(
                                scale: circleAnimation.value,
                                child: Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        successColor,
                                        successColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: successColor.withValues(alpha:.15),
                                        blurRadius: 30,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: checkAnimation.value),
                                      duration: const Duration(milliseconds: 400),
                                      builder: (context, value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.scale(
                                            scale: value,
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: whiteColor,
                                              size: 8.h,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),
                    /// CONTENT
                    FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: contentAnimation,
                        child: Column(
                          children: [
                            CustomText(
                              text: orderPlacedSuccessfully,
                              textAlign: TextAlign.center,
                                fontSize: 27.px,
                                style: CustomTextStyle.bold,
                                color: primaryColor,
                            ),

                            SizedBox(height: 2.h),

                            CustomText(
                              text: orderDeliverySoon,
                              textAlign: TextAlign.center,
                                fontSize: 16,
                                height: 1.5,
                                color: greyColor.withValues(alpha:.8),
                                style: CustomTextStyle.medium,
                            ),
                            SizedBox(height: 4.h),
                            /// ORDER CARD
                            Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(2.h),
                                boxShadow: [
                                  BoxShadow(
                                    color: blackColor.withValues(alpha:.3),
                                    blurRadius: 25,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                border: Border.all(
                                  color: greyColor.withValues(alpha:.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  rowItem(orderId,"#${widget.orderCreateModel?.data?.order_id ?? 0}"),
                                  SizedBox(height: 1.5.h),
                                  rowItem( payment,widget.orderCreateModel?.data?.payment_method?.toUpperCase() ?? ''),
                                  SizedBox(height: 1.5.h),
                                  rowItem(orderDate,  Functions.formatDateTime(widget.orderCreateModel?.data?.order_date ?? '',format: 'dd MMM yyyy')),
                                  SizedBox(height: 1.5.h),
                                  rowItem(delivery,  Functions.formatDateTime(widget.orderCreateModel?.data?.delivery_date ?? '',format: 'dd MMM yyyy')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5.h),

                    /// BUTTONS
                    ScaleTransition(
                      scale: buttonAnimation,
                      child: Column(
                        children: [
                          CustomButton(text: trackOrder, onPressed: (){
                            getIt<AppRoutes>().replace(OrderDetailsRoute(orderId: widget.orderCreateModel?.data?.order_id ?? 0,isFrom:orderSuccess));
                          }),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: greyColor.withValues(alpha:.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                getIt<AppRoutes>().replaceAll([
                                  MainRoute(key: UniqueKey(),selectedIndex: 0),
                                ]);
                              },
                              child: CustomText(
                               text: continueShopping,
                                  color: blackColor,
                                  style: CustomTextStyle.bold,
                                  fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
            fontSize: 15.px,
            color: greyColor.withValues(alpha:.8),
            style: CustomTextStyle.medium,
        ),
        CustomText(
          text:  value,
            fontSize: 15.px,
          style: CustomTextStyle.bold,

        ),
      ],
    );
  }
}