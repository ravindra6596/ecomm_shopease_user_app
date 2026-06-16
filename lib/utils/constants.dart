import 'package:e_comm_user/models/address_request_model.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/models/home_response_model.dart';
import 'package:e_comm_user/models/order_response_model.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/models/user_model.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

UserResponseModel userResponseModel = UserResponseModel();
ProductResponseModel productResponseModel = ProductResponseModel();
AddressResponseModel addressResponseModel = AddressResponseModel();
AddressData addressDataModel = AddressData();
AddressRequestModel addressRequestModel = AddressRequestModel();
OrderResponseModel orderResponseModel = OrderResponseModel();
OrderDetailsResponseModel orderDetailsResponseModel = OrderDetailsResponseModel();
HomeResponseModel homeResponseModel = HomeResponseModel();

int pageNo = 1;
int limit = 10;
bool isLoadingMore = false;
bool hasMoreData = true;
final sortOptions = [
  {'title': 'Name','value': 'name'},
  {'title': 'Newest First','value': 'created_at'},
  {'title': 'Price','value': 'price'},
];
final orderOptions = [
  {'title': 'ASC', 'value': 'asc'},
  {'title': 'DESC','value': 'desc'}
];final orderStatusOptions = [
  // {'title': 'Pending', 'value': 'pending'},
  {'title': 'Placed', 'value': 'placed'},
  {'title': 'Shipped', 'value': 'shipped'},
  {'title': 'Delivered', 'value': 'delivered'},
  {'title': 'Cancelled', 'value': 'cancelled'},
];

final paymentStatusOptions = [
  {'title': 'Pending', 'value': 'pending'},
  {'title': 'Success', 'value': 'success'},
  {'title': 'Failed', 'value': 'failed'},
];

final paymentMethodOptions = [
  {'title': 'COD', 'value': 'cod'},
  {'title': 'Online', 'value': 'online'},
];

final orderSortOptions = [
  {'title': 'Order ID', 'value': 'id'},
  {'title': 'Amount', 'value': 'total_amount'},
  {'title': 'User Name', 'value': 'user_name'},
  {'title': 'Order Status', 'value': 'status'},
  {'title': 'Payment Status', 'value': 'payment_status'},
  {'title': 'Payment Method', 'value': 'payment_method'},
  {'title': 'Created Date', 'value': 'created_at'},
  {'title': 'Updated Date', 'value': 'updated_at'},
];
Color getOrderStatusColor(String status) {

  switch (status.toLowerCase()) {

    case 'pending':
    case 'placed':
      return pendingOrder;
    case 'shipped':
      return primaryColor;
    case 'delivered':
      return successColor;
    case 'cancelled':
      return errorColor;
    default:
      return greyColor;
  }
}
final statusSteps = [
  'placed',
  'shipped',
  'delivered',
];
final List<Map<String, String>> faqList = [

  {
    "question": "What is GST charged on products?",
    "answer": "GST varies by category and is included in the final product price at checkout.",
  },
  {
    "question": "How much is the shipping fee?",
    "answer": "Shipping charges depend on your location and order value. Orders above ₹499 have free shipping.",
  },
  {
    "question": "How long does delivery take?",
    "answer": "Delivery usually takes 2–5 business days depending on your location.",
  },
  {
    "question": "Can I cancel my order?",
    "answer": "Yes, orders can be cancelled before they are shipped from the My Orders section.",
  },
  {
    "question": "How do I track my order?",
    "answer": "Go to My Orders and tap on any order to track real-time status.",
  },
  {
    "question": "What is the refund process?",
    "answer": "Refunds are processed within 5–7 business days after approval.",
  },
  {
    "question": "How do I return a product?",
    "answer": "Go to My Orders → Select product → Click Return and follow steps.",
  },
  {
    "question": "Is Cash on Delivery available?",
    "answer": "Yes, COD is available for selected pin codes and products.",
  },
  {
    "question": "Why is my order delayed?",
    "answer": "Delays may occur due to weather conditions, courier issues, or high demand.",
  },
  {
    "question": "How can I change my delivery address?",
    "answer": "You can update your address before shipment from Account settings.",
  },
  {
    "question": "Do you provide GST invoices?",
    "answer": "Yes, GST invoices are available for all orders in the order details page.",
  },
  {
    "question": "Can I modify my order after placing it?",
    "answer": "No, orders cannot be modified after confirmation. You can cancel and reorder.",
  },
  {
    "question": "What payment methods are supported?",
    "answer": "We support UPI, Credit/Debit cards, Net Banking, Wallets, and COD.",
  },
  {
    "question": "How do I contact customer support?",
    "answer": "You can contact support via Help & Support section in the app.",
  },
  {
    "question": "Why did my payment fail?",
    "answer": "Payment may fail due to bank issues, insufficient balance, or network errors.",
  },
  {
    "question": "Can I order without creating an account?",
    "answer": "No, account creation is required to place orders.",
  },
  {
    "question": "How do I reset my password?",
    "answer": "Go to login screen → Click Forgot Password → Follow instructions.",
  },
  {
    "question": "How can I change my email address?",
    "answer": "You can update your email from Profile settings.",
  },
  {
    "question": "Is my personal data safe?",
    "answer": "Yes, we follow strict security measures to protect your data.",
  },
  {
    "question": "Do you deliver to all locations?",
    "answer": "We deliver to most PIN codes across India, subject to courier availability.",
  },
  {
    "question": "What if I receive a damaged product?",
    "answer": "You can request a return or replacement within the return window.",
  },
  {
    "question": "How do I apply a coupon code?",
    "answer": "Enter coupon code on checkout page before payment.",
  },
  {
    "question": "Why is my refund delayed?",
    "answer": "Refunds may take longer due to bank processing delays.",
  },
  {
    "question": "Can I change payment method after placing order?",
    "answer": "No, payment method cannot be changed after order confirmation.",
  },
  {
    "question": "Do you offer customer support 24/7?",
    "answer": "Yes, our support team is available 24/7 for assistance.",
  },
  {
    "question": "Can I reorder a previous order?",
    "answer": "Yes, you can use the 'Buy Again' option in My Orders.",
  },
  {
    "question": "How do I update my profile details?",
    "answer": "Go to Account → Profile → Edit details and save changes.",
  },
  {
    "question": "What happens if delivery fails?",
    "answer": "Courier will retry delivery or contact you for rescheduling.",
  },
  {
    "question": "Can I add multiple addresses?",
    "answer": "Yes, you can save multiple addresses in your account.",
  },
  {
    "question": "How do I delete my account?",
    "answer": "Please contact support to request account deletion.",
  },

];