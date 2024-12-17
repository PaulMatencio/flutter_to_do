
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    final theme =Theme.of(context);
    return BlocBuilder<LoginCubit, LoginCubitState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width:1.0,color:theme.colorScheme.primary),
              //borderSide: BorderSide(width: 1.0, color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              //borderSide: BorderSide(width: 1.0, color: Colors.white),
              borderSide: BorderSide(width:1.0,color:theme.colorScheme.primary),
            ),
            labelText: 'Email',
            helperText: 'A complete, valid email e.g. paul@gmail.com',
            errorText: state.email.displayError != null
                ? 'Please ensure the email entered is valid'
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<LoginCubit>().emailChanged(state.email,value);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}