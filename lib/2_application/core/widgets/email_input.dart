import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({required this.focusNode, required this.cubit, super.key});
  final FocusNode focusNode;
  final Function cubit;

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    final theme = Theme.of(context);
//final cubit = context.select((LoginCubit cubit) => cubit);
    return TextFormField(
      initialValue: cubit().state.email.value,
      focusNode: focusNode,
      decoration: InputDecoration(
        icon: const Icon(Icons.email),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary),
//borderSide: BorderSide(width: 1.0, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
//borderSide: BorderSide(width: 1.0, color: Colors.white),
          borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary),
        ),
        labelText: 'Email',
        helperText: 'A complete, valid email e.g. paul@gmail.com',
        errorText: cubit().state.email.displayError != null
            ? 'Please ensure the email entered is valid'
            : null,
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
//context.read<LoginCubit>().emailChanged(state.email,value);
        cubit().emailChanged(cubit().state.email, value);
      },
      textInputAction: TextInputAction.next,
    );
  }
}
