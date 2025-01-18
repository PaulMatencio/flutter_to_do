import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String route;
    String text;
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        if (state is AuthCubitInitial && state.isLoggedIn) {
          route = 'profile';
          text = context.tr(route);
          return TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll<Color>(theme.colorScheme.onPrimary),
            ),
            onPressed: () {
              context.pushNamed(route);
            },
            child: Text(context.tr(text), style: theme.textTheme.displayMedium),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
