import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/core/models/login.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key,required this.login});
  final Login login;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValid = context.select((LoginCubit cubit) => cubit.state.isValid);

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimary)),
      onPressed: isValid
          ? () async {
        print(login.name);
        switch (login.name)  {
          case 'mail':
            await context.read<LoginCubit>().signInWithEmailAndPassword();
            return;
          case 'phone':
            await context.read<LoginCubit>().logInWithPhoneNumber();
            return;
          default:
             await context.read<LoginCubit>().confirmResult();
        }
      }
          : null,
      child:  Text('Submit',style: Theme.of(context).textTheme.titleMedium),
    );
  }
}