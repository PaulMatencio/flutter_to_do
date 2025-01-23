import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/user_profile/bloc/cubit/user_profile_cubit.dart';
import 'package:todo_app/2_application/pages/user_profile/view_states/user_profile_loaded.dart';
import 'package:todo_app/2_application/pages/user_profile/view_states/user_profile_loading.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'user_profile',
    child: Placeholder(),
  );
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit,UserProfileCubitState>(
        builder: (context,state) {
          if (state is UserProfileCubitLoadingState) {
            return UserProfileLoading();
          }  else if (state is UserProfileCubitLoadedState) {
            return UserProfileLoaded();
          }

          return Placeholder();
        });
  }
}