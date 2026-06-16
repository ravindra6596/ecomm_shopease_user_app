// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/bloc/auth/auth_bloc.dart';
import 'package:e_comm_user/bloc/auth/auth_event.dart';
import 'package:e_comm_user/bloc/auth/auth_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/login_response_model.dart';
import 'package:e_comm_user/models/register_request_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  final String page = '/registerScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  AuthBloc authBloc = getIt<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: BlocProvider(
            create: (context) => authBloc,
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccessState) {
                  handleRegisterSuccess(context, state.loginResponseModel);
                } else if (state is AuthErrorState) {
                  Functions.showCustomSnackBar(context,  message: state.error,backgroundColor: errorColor);
                }
              },
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    CustomText(
                      text: createAnAccount,
                      style: CustomTextStyle.semiBold,
                      fontSize: 32.px,
                      color: blackColor,
                    ),
                    SizedBox(height: 8.sp),
                    CustomText(
                      text: letsCreateYourAccount,
                      style: CustomTextStyle.regular,
                      fontSize: 16.px,
                      color: greyColor,
                    ),
                    SizedBox(height: 5.h),
                    CustomTextField(
                      controller: nameController,
                      labelText: fullName,
                      hintText: enterYourFullName,
                      prefixIcon: Icons.person,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return pleaseEnterFullName;
                        }
                        if (value.length < 6) {
                          return pleaseEnterValidFullName;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),
                    CustomTextField(
                      controller: emailController,
                      labelText: email,
                      hintText: enterYourEmailAddress,
                      prefixIcon: Icons.email,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
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
                          prefixIcon: Icons.lock,
                          obscureText: !isPasswordVisible,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: greyColor,
                            ),
                            onPressed: () {
                              authBloc.add(TogglePasswordVisibilityEvent());
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return pleaseEnterPassword;
                            }
                            if (value.length < 6) {
                              return pleaseEnterValidPassword;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.px,
                          color: greyColor,
                          fontFamily: fontFamilyText,
                        ),
                        children: [
                          TextSpan(text: 'By signing up you agree to our '),
                          TextSpan(
                            text: terms,
                            style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ', '),
                          TextSpan(
                            text: privacyPolicy,
                            style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ', and '),
                          TextSpan(
                            text: cookieUse,
                            style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: createAnAccount,
                          isLoading: state is AuthLoadingState,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            if (nameController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              RegisterRequestModel registerRequestModel =
                                  RegisterRequestModel(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              authBloc.add(RegisterEvent(registerRequestModel));
                            } else {
                              Functions.showCustomSnackBar(context, message: pleaseFillAllFields, backgroundColor: errorColor);
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: '${alreadyHaveAccount.split('?')[0]}?',
                            style: CustomTextStyle.regular,
                            fontSize: 14.sp,
                            color: greyColor,
                          ),
                          TextButton(
                            onPressed: () {
                              getIt<AppRoutes>().pop();
                            },
                            child: CustomText(
                              text: logIn,
                              style: CustomTextStyle.semiBold,
                              fontSize: 14.sp,
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.sp),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  void handleRegisterSuccess(
      BuildContext context, LoginResponseModel loginResponseModel) async {
    Functions.showCustomSnackBar(context, message: loginResponseModel.message ?? '', backgroundColor: successColor);
    if (context.mounted) {
      getIt<AppRoutes>().pop();
    }
  }
}
