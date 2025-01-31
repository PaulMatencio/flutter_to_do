import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/update_user_profile/bloc/cubit/update_user_profile_cubit.dart';

class EmailVerificationButton extends StatelessWidget {
  const EmailVerificationButton({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    Color color = theme.onTertiary;
    Function callBack;
    final text = context.tr('send verification email');
    callBack = () async {
      await context
          .read<UpdateUserProfileCubit>()
          .emailVerification()
          .then((result) {
        final message = result == true ? 'email verification is sent' : 'verification fails';
        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message)),
            );
        }
      });
    };

    return ElevatedButton(
      onPressed: () => callBack(),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
      child: Tooltip(
          message: 'email is not verified',
          child: Text(text, style: Theme.of(context).textTheme.displaySmall)),
    );
  }
}
