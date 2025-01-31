import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    Color color = theme.onTertiary;
    Function callBack;
    final text = context.tr('logout');
    callBack = () async {
      await context.read<LoginCubit>().logOut().then((result) {
        final message = result == true ? 'Logout successfully' : 'Logout fails';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(message)),
          );

        debugPrint('${context.mounted}   =>  dashboard');
        if (context.mounted) {
          context.goNamed(
            HomePage.pageConfig.name,
            pathParameters: {'tab': DashboardPage.pageConfig.name},
          );
        }
      });
    };

    return ElevatedButton(
      onPressed: () => callBack(),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
      child: Text(text, style: Theme.of(context).textTheme.displayMedium),
    );
  }
}
