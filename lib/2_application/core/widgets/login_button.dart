import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        String text;
        final theme = Theme.of(context).colorScheme;
        Color color = theme.onTertiary;
        Function callBack;

        if (state is AuthCubitInitial && state.isLoggedIn) {
          // text = 'profile';
          // callBack = ()=> context.pushNamed(text) ;ScaffoldMessenger.of(context)
          //             ..hideCurrentSnackBar()
          //             ..showSnackBar(
          //               const SnackBar(content: Text('Sign in successfully')),
          //             );
          text = 'logout';
          callBack = () async {
           await context.read<LoginCubit>().logOut().then((result) {
            // await context.read<LoginCubit>().signOut().then((result) {
              final message =
                  result == true ? 'Logout successfully' : 'Logout fails';
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(message)),
                );
              context.goNamed(
                HomePage.pageConfig.name,
                pathParameters: {'tab': DashboardPage.pageConfig.name},
              );
            });
          };
        } else {
          text = 'login';
          color = theme.onPrimary;
          callBack = () => context.pushNamed(text);
        }

        return ElevatedButton(
          onPressed: () => callBack(),

          ///
          // onPressed: callBack.call(),  /// cause an  error
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
          child: Text(text, style: Theme.of(context).textTheme.displaySmall),
        );
      },
    );
  }
}
