
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class ConfirmationCodeInput extends StatelessWidget {
  const ConfirmationCodeInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginCubitState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.confirmationCode.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.code),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width:1.0,color:theme.colorScheme.primary),
            ),
            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(width:1.0,color:theme.colorScheme.primary),
            ),
            labelText: 'Confirmation Code',
            helperText: 'Must be 8 digits',
            errorText: state.confirmationCode.displayError != null
                ? 'Please ensure the confirmation code  entered is valid'
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            context.read<LoginCubit>().confirmationCodeChanged(state.confirmationCode,value);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}