

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return BlocBuilder<LoginCubit, LoginCubitState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.password.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                  state.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: theme.colorScheme.primary
              ),
              onPressed: () {
                context.read<LoginCubit>().togglePasswordVisible();
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
            errorText: state.password.displayError != null
                ? '''Password must be at least 10 characters and contain at least one letter and number'''
                : null,
          ),
          obscureText: !state.passwordVisible,
          onChanged: (value) {
            context.read<LoginCubit>().
            passwordChanged(password: state.password,value: value);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}