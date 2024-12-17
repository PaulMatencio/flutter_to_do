
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/2_application/pages/register/bloc/cubit/register_cubit.dart';

class ConfirmedPasswordInput extends StatelessWidget {
  const ConfirmedPasswordInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<RegisterCubit, RegisterCubitState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.confirmedPassword.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                state.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                context.read<RegisterCubit>().togglePasswordVisible();
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width:1.0,color: theme.colorScheme.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width:1.0,color:theme.colorScheme.onPrimary),
            ),
            helperMaxLines: 2,
            labelText: 'Confirm password',
            errorMaxLines: 2,
            errorText: state.confirmedPassword.displayError != null
                ? '''both passwords must be the same'''
                : null,
          ),
          obscureText: !state.passwordVisible,
          onChanged: (value) {
            context.read<RegisterCubit>().
            confirmedPasswordChanged(password: state.confirmedPassword,value: value);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}