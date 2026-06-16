import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/presentation/account/account_screen.dart';
import 'package:e_comm_user/presentation/address/address_list_screen.dart';
import 'package:e_comm_user/presentation/address/create_address_screen.dart';
import 'package:e_comm_user/presentation/auth/login_screen.dart';
import 'package:e_comm_user/presentation/auth/register_screen.dart';
import 'package:e_comm_user/presentation/cart/cart_screen.dart';
import 'package:e_comm_user/presentation/categories/categories_screen.dart';
import 'package:e_comm_user/presentation/chatbot/chat_boat_screen.dart';
import 'package:e_comm_user/presentation/faq/faq_screen.dart';
import 'package:e_comm_user/presentation/home/home_screen.dart';
import 'package:e_comm_user/presentation/home/user_details_screen.dart';
import 'package:e_comm_user/presentation/main/main_screen.dart';
import 'package:e_comm_user/presentation/offers/offers_screen.dart';
import 'package:e_comm_user/presentation/onboarding/onboarding_screen.dart';
import 'package:e_comm_user/presentation/order/check_out_screen.dart';
import 'package:e_comm_user/presentation/order/order_details_screen.dart';
import 'package:e_comm_user/presentation/order/order_success_screen.dart';
import 'package:e_comm_user/presentation/order/orders_list_screen.dart';
import 'package:e_comm_user/presentation/product/product_details_screen.dart';
import 'package:e_comm_user/presentation/product/products_screen.dart';
import 'package:e_comm_user/presentation/profile/profile_screen.dart';
import 'package:e_comm_user/presentation/splash/splash_screen.dart';
import 'package:e_comm_user/presentation/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';

part  'app_routes.gr.dart';

@AutoRouterConfig()
class AppRoutes extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  // Service locator setup
  void setupLocator() {
    // Register your services and dependencies
    getIt.registerSingleton<AppRoutes>(AppRoutes());
  }

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: "/"),
    AutoRoute(page: ProductsRoute.page),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: MainRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: UserDetailsRoute.page),
    AutoRoute(page: CategoriesRoute.page),
    AutoRoute(page: ProductDetailsRoute.page),
    AutoRoute(page: CheckoutRoute.page),
    AutoRoute(page: AddressListRoute.page),
    AutoRoute(page: CreateAddressRoute.page),
    AutoRoute(page: OrdersListRoute.page),
    AutoRoute(page: OrderSuccessRoute.page),
    AutoRoute(page: OrderDetailsRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: FAQRoute.page),
    AutoRoute(page: ChatbotRoute.page),
    AutoRoute(page: OffersRoute.page),
  ];
}