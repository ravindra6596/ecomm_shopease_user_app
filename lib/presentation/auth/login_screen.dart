// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/service/notification_service.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm_user/bloc/auth/auth_bloc.dart';
import 'package:e_comm_user/bloc/auth/auth_event.dart';
import 'package:e_comm_user/bloc/auth/auth_state.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/login_request_model.dart';
import 'package:e_comm_user/models/login_response_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  final String page = '/loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  AuthBloc authBloc = getIt<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    authBloc.add(LoadRememberMeEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: BlocProvider(
          create: (context) => authBloc,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccessState) {
                handleLoginSuccess(context, state.loginResponseModel);
              } else if (state is AuthErrorState) {
                Functions.showCustomSnackBar(context, message: state.error, backgroundColor: errorColor);
                if(state.error == 'No registered user!'){
                  getIt<AppRoutes>().push(RegisterRoute());
                }
              }
              else  if (state is RememberMeCredentialsLoadedState) {
                emailController.text = state.email;
                passwordController.text = state.password;
              }
            },
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  CustomText(
                    text: loginToYourAccount,
                    style: CustomTextStyle.semiBold,
                    fontSize: 32.px,
                    color: blackColor,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    text: itsGreatToSeeYouAgain,
                    style: CustomTextStyle.regular,
                    fontSize: 16.px,
                    color: greyColor,
                  ),
                  SizedBox(height: 5.h),
                  CustomTextField(
                    controller: emailController,
                    labelText: email,
                    hintText: enterYourEmailAddress,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return pleaseEnterEmail;
                      }
                      if (!value.contains('@')) {
                        return pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) => current is AuthPasswordVisibilityState,
                    builder: (context, state) {
                      final isPasswordVisible = state is AuthPasswordVisibilityState ? state.isPasswordVisible : false;
                      return CustomTextField(
                        controller: passwordController,
                        labelText: password,
                        hintText: enterYourPassword,
                        prefixIcon: Icons.lock_outline,
                        obscureText: !isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return pleaseEnterPassword;
                          }
                          if (value.length < 6) {
                            return pleaseEnterValidPassword;
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: greyColor,
                          ),
                          onPressed: () {
                            authBloc.add(TogglePasswordVisibilityEvent());
                          },
                        ),
                        textInputAction: TextInputAction.done,
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember me
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          bool rememberMe = authBloc.rememberMe;
                          return Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  authBloc.add(ToggleRememberMeEvent(value ?? false));
                                },
                              ),
                              CustomText(text: rememberMeText),
                            ],
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: CustomText(
                          text: forgotYourPassword,
                          style: CustomTextStyle.medium,
                          fontSize: 12.px,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 3.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: login,
                        isLoading: state is AuthLoadingState,
                        onPressed: () async {
                          final fcmToken = await NotificationService().getFCMToken();
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            LoginRequestModel loginRequestModel =
                                LoginRequestModel(
                              email: emailController.text,
                              password: passwordController.text,
                              fcmToken: fcmToken
                            );
                            log('fcmToken: $fcmToken');
                            log('Login request: ${loginRequestModel.toJson()}');
                            authBloc.add(LoginEvent(loginRequestModel));
                          } else {
                            Functions.showCustomSnackBar(
                              context,
                              message: pleaseFillAllFields,
                              backgroundColor: errorColor,
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: dontHaveAccount,
                          style: CustomTextStyle.medium,
                          fontSize: 14.px,
                          color: greyColor,
                        ),
                        TextButton(
                          onPressed: () {
                            getIt<AppRoutes>().push(RegisterRoute());
                          },
                          child: CustomText(
                            text: join,
                            style: CustomTextStyle.semiBold,
                            fontSize: 14.px,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  void handleLoginSuccess(
      BuildContext context, LoginResponseModel loginResponseModel) async {
    if (loginResponseModel.data?.access_token != null) {
      // SAVE TOKENS
      await SharedPrefHelper.saveTokens(
        loginResponseModel.data!.access_token!,
        loginResponseModel.data!.refresh_token ?? '',
      );
      // SAVE USER INFO
      if (loginResponseModel.data?.user != null) {
        await SharedPrefHelper.saveUserInfo(
          loginResponseModel.data!.user!.id!,
          loginResponseModel.data!.user!.email!,
          loginResponseModel.data!.user!.role ?? 'user',
        );
      }
      // GENERATE NEW GUEST ID OLD GUEST CART ALREADY MERGED
      await SharedPrefHelper.saveGuestId(const Uuid().v4());
      if (context.mounted) {
        Functions.showCustomSnackBar(context, message: loginResponseModel.message ?? '', backgroundColor: successColor);
        getIt<AppRoutes>().replace(MainRoute());
      }
    }
  }
}
