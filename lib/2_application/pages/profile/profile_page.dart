

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/profile/bloc/cubit/profile_cubit.dart';
import 'package:todo_app/2_application/pages/profile/view_states/profile_Loaded.dart';
import 'package:todo_app/2_application/pages/profile/view_states/profile_loading.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'profile',
    child: Placeholder(),
  );
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileCubitState>(
        builder: (context,state) {
          if (state is ProfileCubitLoadingState) {
            return ProfileLoading();
          }  else if (state is ProfileCubitLoadedState) {
            return ProfileLoaded();
          }

          return Placeholder();
        });
  }
}

