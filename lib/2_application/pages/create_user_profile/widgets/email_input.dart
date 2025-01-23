import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/create_user_profile/bloc/cubit/create_user_profile_cubit.dart';


class EmailInput extends StatelessWidget {
  const EmailInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    return BlocBuilder<CreateUserProfileCubit, CreateUserProfileCubitState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email.value,
          readOnly: true,
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.white),
            ),
            labelText: 'Email',
            helperText: 'A complete, valid email e.g. paul@gmail.com',
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) {
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
