import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Functions {
  static dynamic getErrorResponse(Exception exception) {
    DioException err = exception as DioException;
    if (err.response == null) {
      return {
        'message': 'Network error or server unavailable',
        'statusCode': -1
      };
    }
    var res = err.response.toString();
    try {
      return jsonDecode(res);
    } catch (e) {
      return {
        'message': 'Error decoding response: ${e.toString()}',
        'statusCode': -1
      };
    }
  }
  static void showCustomSnackBar(
      BuildContext context, {
        required String message,
        Color backgroundColor = Colors.black87,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: message,color: whiteColor,fontSize: 15.px,),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  static String formatPrice(dynamic price) {
    final number = num.tryParse(price.toString()) ?? 0;
    return NumberFormat('#,##,##0', 'en_IN').format(number);
  }

  /// Full INR display (e.g. ₹45,999) — prices are stored as whole rupees.
  static String formatInr(dynamic price) => '₹${formatPrice(price)}';
  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (e) {
      log("error");
    }
  }
  static String formatDateTime(
      String dateStr, {
        String format = 'dd MMM yyyy hh:mm:ss a',
      }) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat(format).format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }
  static int getEstimatedDeliveryDays(String? input) {
    final base = DateTime.now().millisecondsSinceEpoch;

    final hash = (input ?? '').hashCode;

    // creates stable variation per product
    final value = (base + hash) % 5; // 0–4

    return 2 + value; // final range: 2 to 6 days
  }
  static double getRating(int id) {
    return 3 + (id % 3) * 0.5; // 3.0, 3.5, 4.0, 4.5
  }
}