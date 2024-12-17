import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        if (state is AuthCubitInitial && state.isLoggedIn) {
          return TextButton(
            style: ButtonStyle(
              backgroundColor:
              WidgetStatePropertyAll<Color>(theme.colorScheme.onPrimary),
            ),
            onPressed: () {
                context.pushNamed('profile');
            },
            child: Text('profile', style: theme.textTheme.displayMedium),
          );
        }
        else {
          return const SizedBox();}
      },
    );
  }
}
