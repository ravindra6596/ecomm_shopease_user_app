// ignore_for_file: must_be_immutable
import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/bloc/profile/profile_bloc.dart';
import 'package:e_comm_user/bloc/profile/profile_event.dart';
import 'package:e_comm_user/bloc/profile/profile_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/profile_response_model.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  ProfileBloc profileBloc = getIt<ProfileBloc>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  bool isEditing = false;
  String getInitials(String fullName) {
    List<String> parts = fullName.trim().split(" ");
    if (parts.isEmpty) return "";
    String first = parts.first.isNotEmpty ? parts.first[0] : "";
    String last = parts.length > 1 ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => profileBloc,
      child: Scaffold(
        backgroundColor: whiteColor,

        appBar: CustomAppBar(
          title: userDetails,

          action:
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              /// ENABLE EDIT
              if (state is ProfileSuccessState && state.isEditing) {
                Functions.showCustomSnackBar(
                  context,
                  message: editModeEnabled,
                  backgroundColor: primaryColor,
                );
              }

              /// PROFILE UPDATED
              if (state is ProfileUpdatedState) {
                Functions.showCustomSnackBar(
                  context, message: state.message,
                  backgroundColor: successColor,
                );
              }
              /// ERROR
              if (state is ProfileErrorState) {
                Functions.showCustomSnackBar(
                  context, message: state.error, backgroundColor: errorColor,
                );
              }

            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              bloc: profileBloc,
              builder: (context, state) {

                if (state is ProfileSuccessState) {
                  isEditing = state.isEditing;
                }

                return IconButton(
                  onPressed: () {
                    if (isEditing) {
                      profileBloc.add(
                        UpdateProfileEvent(
                          UpdateProfileRequestModel(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                          ),
                        ),
                      );
                    } else {
                      profileBloc.add(
                        ToggleEditProfileEvent(),
                      );
                    }
                  },
                  icon: Icon(
                    isEditing
                        ? Icons.check
                        : Icons.edit,
                  ),
                );
              },
            ),
          ),

        ),

        body: BlocProvider(
          create: (_) =>
          profileBloc..add(LoadProfileEvent()),

          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState && state is ProfileUpdatingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProfileErrorState) {
                return Center(
                  child: CustomText(
                    text: state.error,
                  ),
                );
              }

              if (state is ProfileSuccessState) {
                final userData =
                    state.profileResponseModel.data;

                nameController.text =
                    userData?.name ?? '';

                emailController.text =
                    userData?.email ?? '';

                return SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [

                      /// INITIALS
                      Container(
                        alignment: Alignment.center,
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: CustomText(
                          text: getInitials(
                            userData?.name ?? '',
                          ),
                          color: whiteColor,
                          fontSize: 22.px,
                          style: CustomTextStyle.bold,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      /// NAME
                      CustomTextField(
                        controller: nameController,
                        labelText: name,
                        enabled: state.isEditing,
                        textInputAction: TextInputAction.next,
                      ),

                      SizedBox(height: 2.h),

                      /// EMAIL
                      CustomTextField(
                        controller: emailController,
                        labelText: email,
                        enabled: state.isEditing,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),

                      SizedBox(height: 2.h),

                      /// JOINED DATE
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: "$memberSince : ${Functions.formatDateTime(
                            userData?.created_at ?? '', format: 'dd MMM yyyy',
                          )}",
                          fontSize: 14.px,
                          color: greyColor,
                        ),
                      ),
                      /// Last updated
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: "$lastUpdated : ${Functions.formatDateTime(
                            userData?.updated_at ?? '', format: 'dd MMM yyyy',
                          )}",
                          fontSize: 14.px,
                          color: greyColor,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      /// STATUS
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: userData?.is_active == true
                                ? successColor.withValues(alpha: .1)
                                : errorColor.withValues(alpha: .1),
                            borderRadius:
                            BorderRadius.circular(1.h),
                          ),
                          child: CustomText(
                            text: userData?.is_active == true
                                ? active
                                : inactive,
                            color:
                            userData?.is_active == true
                                ? successColor
                                : errorColor,
                            fontSize: 12.px,
                            style: CustomTextStyle.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}