

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({required this.focusNode, required this.cubit, super.key});
  final FocusNode focusNode;
  final Function  cubit;

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    //final cubit  = context.select((LoginCubit cubit) => cubit);
    return TextFormField(
      initialValue: cubit().state.password.value,
      focusNode: focusNode,
      decoration: InputDecoration(
        icon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              cubit().state.passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: theme.colorScheme.primary
          ),
          onPressed: () {
            cubit().togglePasswordVisible();
          },
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width:1.0,color:theme.colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width:1.0,color:theme.colorScheme.primary),
        ),
        helperText:
        '''Password should be at least 10 characters with at least one letter and number''',
        helperMaxLines: 2,
        labelText: 'Password',
        errorMaxLines: 2,
        errorText: cubit().state.password.displayError != null
            ? '''Password must be at least 10 characters and contain at least one letter and number'''
            : null,
      ),
      obscureText: !cubit().state.passwordVisible,
      onChanged: (value) {
        cubit().
        passwordChanged(password: cubit().state.password,value: value);
      },
      textInputAction: TextInputAction.done,
    );

  }
}