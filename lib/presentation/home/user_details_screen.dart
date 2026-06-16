import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm_user/bloc/user/user_bloc.dart';
import 'package:e_comm_user/bloc/user/user_event.dart';
import 'package:e_comm_user/bloc/user/user_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/user_model.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_text.dart';

@RoutePage()
class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({super.key, this.userId = 0});
  final int userId;
  final String page = 'userDetails';
  UserBloc userBloc = getIt<UserBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: userDetails, style: CustomTextStyle.semiBold),
      ),
      body: BlocProvider(
        create: (context) => userBloc..add(UserDetailEvent(userId)),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if(state is UserLoadingState){
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is UserDetailsLoadedState){
              Users users = state.userDetailsModel.data!;
              return Column(
                spacing: 10,
                children: [
                  CustomText(text: 'name ${users.name}', style: CustomTextStyle.medium),
                  CustomText(text: 'email ${users.email}'),
                  CustomText(text: 'designation ${users.designation}'),
                  CustomText(text: 'department ${users.department}'),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
