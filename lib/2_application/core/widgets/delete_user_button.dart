import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/register/bloc/cubit/register_cubit.dart';

class DeleteUserButton extends StatelessWidget {
  const DeleteUserButton({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).colorScheme;
    Color color = theme.onTertiary;
    final text = context.tr('delete account');
    return ElevatedButton(
      onPressed: () {
        showAlertDialog(
          context: context,
          colorScheme: theme
        );
      },
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
      child: Tooltip(
          message: 'delete an account',
          child: Text(text, style: Theme.of(context).textTheme.displayMedium)),
    );
  }
}

///
///   Show Alert  before delete
///
///
showAlertDialog({
  required BuildContext context,
  required ColorScheme colorScheme,
}) {
  /// set up the Cancel button
  final theme = colorScheme;
  Function callBack;
  final currentUser =  FirebaseAuth.instance.currentUser;
  if (currentUser == null ) {
    context.pop();
  }
  final  lastLogin =  currentUser!.metadata.lastSignInTime;
  Color color = theme.onTertiary;
  final text = context.tr('delete');
  final cubit = context.read<RegisterCubit>;
  callBack = () async {
    await cubit().deleteUser().then((result) {
      final message = result == true
          ? 'Delete account successfully'
          : cubit().state.errorMessage;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              duration: Duration(seconds: 5),
              content: Text(message ?? 'Delete account fails')),
        );
      if (context.mounted) {
        result
            ? context.goNamed(
                HomePage.pageConfig.name,
                pathParameters: {'tab': DashboardPage.pageConfig.name},
              )
            : context.pop();
      }
    });
  };

  Widget cancelButton = TextButton(
      child:
          Text('cancel'.tr(), style: Theme.of(context).textTheme.displaySmall),
      onPressed: () => context.pop());

  ///  Setup the continue button
  Widget continueButton = ElevatedButton(
    onPressed: () => callBack(),
    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
    child: Tooltip(
        message: 'delete an account',
        child: Text(text, style: Theme.of(context).textTheme.displaySmall)),
  );

  ///
  /// Set up the AlertDialog
  ///
  AlertDialog alert = AlertDialog(
    title: Text('AlertDialog'),
    content: Text(context.tr('delete_account_confirmation_message', ),
        style: Theme.of(context).textTheme.displaySmall),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog

  ///
  ///    Build the AlertDialog
  ///
  Duration since = Duration(minutes: 0);
  if (lastLogin != null) {
    since= DateTime.now().difference(lastLogin);
  }
  if (since   >  Duration(minutes: 5)) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
            duration: Duration(seconds: 5),
            content: Text('Delete user is a sensitive operation. Please re-login first (logout then login) and delete it' ),
      ));
  }  else {
    showDialog(
      context: context,
      useRootNavigator: false, //  use go router instead
      builder: (BuildContext context) {
        return alert; //
      },
    );
  }
}
