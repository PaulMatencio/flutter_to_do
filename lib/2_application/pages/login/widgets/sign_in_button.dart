import 'package:flutter/material.dart';
import 'package:todo_app/2_application/core/models/login.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key,required this.login,required this.cubit});
  final Login login;
  final Function cubit;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final isValid = context.select((LoginCubit cubit) => cubit.state.isValid);
    final isValid = cubit().state.isValid;
    //final cubit = context.select((LoginCubit cubit) => cubit);
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimary)),
      onPressed: isValid
          ? () async {
        // print(login.name);
        switch (login.name)  {
          case 'mail':
            await cubit().signInWithEmailAndPassword();
            return;
          case 'phone':
            await cubit().logInWithPhoneNumber();
            return;
          case 'reset':

            await cubit().sendResetPassword();
            return;
          default:
            await cubit().confirmationCode();
        }
      }
          : null,
      child:  Text('Submit',style: Theme.of(context).textTheme.titleMedium),
    );
  }
}