import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';


class LoginButton extends StatelessWidget {
  const LoginButton({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        String route;
        Color color;
        final theme = Theme.of(context).colorScheme;
        Function callBack;
        if (state is AuthCubitInitial && state.isLoggedIn) {
          route = 'profile';
          color = theme.onTertiary;
          callBack =() => context.pushNamed(route);
        } else {
          route =  'login';
          color = theme.onPrimary;
          callBack = () => context.pushNamed(route);
        }
        String text = context.tr(route);

        return ElevatedButton(
          onPressed: () => callBack(),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
          child: Text(text, style: Theme.of(context).textTheme.displaySmall),
        );
      },
    );
  }
}
