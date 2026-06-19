import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/saved_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartSummaryWidget extends StatelessWidget {
  final int subtotal;
  final int shipping;
  final int vat;
  final int totalAmount;
  final int discountAmount;
  final VoidCallback onCheckout;

  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    this.shipping = 0,
    this.vat = 0,
    required this.totalAmount,
    this.discountAmount=0,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final totalDiscount = (subtotal - discountAmount).round();
    final shippingFeeAmount = (totalDiscount *10/100).round();
    final grandTotalAmount = discountAmount + shippingFeeAmount;
    final savings = totalDiscount - shippingFeeAmount;
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(top: BorderSide(color: dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SummaryRow(label: subTotal, value: subtotal),
          SizedBox(height: 0.8.h),
          SummaryRow(label: discount, value: totalDiscount, isDiscount: true),
          SizedBox(height: 0.8.h),
          SummaryRow(label: protectPromiseFee, value: shippingFeeAmount ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.2.h),
            child: Divider(color: dividerColor, height: 1),
          ),
          SummaryRow(label: total, value: grandTotalAmount, isTotal: true),
          SizedBox(height: 2.h),
          SavedPriceWidget(savingAmount: savings),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: Functions.formatInr(totalAmount),
                    fontSize: 12.px,
                    style: CustomTextStyle.regular,
                    color: greyColor,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: greyColor,
                    ),
                    CustomText(text: Functions.formatInr(grandTotalAmount),
                    fontSize: 25.px,
                    style: CustomTextStyle.bold,),
                  ],
                ),
              ),
              Expanded(
                child: CustomButton(
                  text: checkout,
                  onPressed: onCheckout,
                  textColor: whiteColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final int value;
  final bool isTotal;
  final bool isDiscount;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          style: isTotal ? CustomTextStyle.bold : CustomTextStyle.regular,
          fontSize: isTotal ? 16.sp : 14.sp,
          color: isTotal ? blackColor : greyColor,
        ),
        CustomText(
          text:
          '${isDiscount ? '- ' : ''}${Functions.formatInr(value)}',
          style: isTotal ? CustomTextStyle.bold : CustomTextStyle.medium,
          fontSize: isTotal ? 18.sp : 14.sp,
          color: isDiscount ? successColor : blackColor,
        ),
      ],
    );
  }
}
