
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/register/bloc/cubit/register_cubit.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((RegisterCubit cubit) => cubit.state.isValid);
    return ElevatedButton(
      onPressed: isValid
          ? () async {
        await context.read<RegisterCubit>().signUpWithEmailAndPassword();
      }
          : null,
      child: Text('Sign Up',style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
