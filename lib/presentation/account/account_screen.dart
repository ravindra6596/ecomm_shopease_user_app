import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/auth/auth_bloc.dart';
import 'package:e_comm_user/bloc/auth/auth_event.dart';
import 'package:e_comm_user/bloc/auth/auth_state.dart';
import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/account_tile.dart';
import 'package:e_comm_user/widgets/cart/empty_cart_widget.dart';
import 'package:e_comm_user/widgets/custom_alert.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoggedIn = false;
  String? userEmail;
  int? userId;
  CartBloc cartBloc = getIt<CartBloc>();
  AuthBloc authBloc = getIt<AuthBloc>();
  var prefs = getIt<SharedPreferences>();
  @override
  void initState() {
    super.initState();
    isLoggedIn = prefs.getBool(SharedPrefHelper.isLoginPref) ?? false;
    authBloc.add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
          title: account,
          showBackButton: false,
          backgroundColor: whiteColor,
      ),
      body: BlocProvider(
        create: (context) => authBloc,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is LogoutSuccessState){
              Functions.showCustomSnackBar(context, message: state.logoutResponseModel.message!,backgroundColor: successColor);
            }
            else if(state is LogoutErrorState){
              Functions.showCustomSnackBar(context, message: state.error,backgroundColor: errorColor);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {

              // if (state is AuthenticatedState) {
              if (state is AuthSuccessState) {
                return buildLoggedInView();
              }

              // if (state is UnAuthenticatedState) {
              if (state is LogoutSuccessState) {
                return buildLoggedOutView();
              }

              // final isLoggedIn = prefs.getBool(SharedPrefHelper.isLoginPref) ?? false;

              // return isLoggedIn ? buildLoggedInView() : buildLoggedOutView();
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoggedInView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// ACCOUNT SECTION
          AccountTile(
            leadingIconName: ordersIcon,
            title: myOrders,
            onTap: () {getIt<AppRoutes>().push(OrdersListRoute());},
          ),

          AccountTile(
            leadingIconName: profileIcon,
            title: myDetails,
            onTap: () {
              getIt<AppRoutes>().push(ProfileRoute());
            },
          ),

          AccountTile(
            leadingIconName: addressIcon,
            title: addressBook,
            onTap: () {
              getIt<AppRoutes>().push(  AddressListRoute());
            },
          ),

          Visibility(
            visible: false,
            child: AccountTile(
              leadingIconName: paymentIcon,
              title: paymentMethods,
              onTap: () {},
            ),
          ),

          Visibility(
            visible: false,
            child: AccountTile(
              leadingIconName: notificationIcon,
              title: notifications,
              onTap: () {},
            ),
          ),

          /// HELP SECTION
          AccountTile(
            leadingIconName: faqIcon,
            title: faqs,
            onTap: () {
              getIt<AppRoutes>().push(FAQRoute());
            },
          ),

          AccountTile(
            leadingIconName: helpIcon,
            title: helpCenter,
            onTap: () {getIt<AppRoutes>().push(ChatbotRoute());},
          ),

          /// LOGOUT
          BlocProvider(
            create: (context) => authBloc,
            child: AccountTile(
              leadingIconName: logoutIcon,
              title: logout,
              titleColor: errorColor,
              onTap: () async{
                final accessToken = await SharedPrefHelper.getAccessToken();
                final shouldLogout = await CustomPopupDialog.show(
                  context,
                  title: logout,
                  description: areYouSureLogout,
                  positiveButtonText: logout,
                  negativeButtonText: cancel,
                  icon: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: errorColor.withValues(alpha: .1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: errorColor,
                      size: 35,
                    ),
                  ),
                );
                if (shouldLogout == true) {
                  authBloc.add(LogoutEvent(accessToken ?? ''));
                }

              },
            ),
          ),



        ],
      ),
    );
  }

  Widget buildLoggedOutView() {
    return EmptyCartWidget(
      title: youAreNotLoggedIn,
      description: loginToView,
      icon: Icons.person_off_outlined,
      buttonTitle: login,
      onContinueShopping: () => getIt<AppRoutes>().push(LoginRoute(),
      ),
    );
    /* return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: 15.h,
                width: 30.w,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: .5),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(accountUnselectedIcon,colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn),),
              ),
            ),
          ),
          SizedBox(height: 24),
          CustomText(
            text: youAreNotLoggedIn,
            style: CustomTextStyle.semiBold,
            fontSize: 24.px,
            color: blackColor,
          ),
          SizedBox(height: 1.h),
          CustomText(
            text: loginToView,
            style: CustomTextStyle.regular,
            fontSize: 16.px,
            color: greyColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          CustomButton(
            text: login,
            onPressed: () {
              getIt<AppRoutes>().push(LoginRoute());
            },
          ),
        ],
      ),
    );*/
  }
}
