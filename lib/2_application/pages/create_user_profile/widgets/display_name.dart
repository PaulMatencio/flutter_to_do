import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/pages/create_user_profile/bloc/cubit/create_user_profile_cubit.dart';
import 'package:todo_app/2_application/pages/register/bloc/cubit/register_cubit.dart';

class DisplayNameInput extends StatelessWidget {
  const DisplayNameInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    return BlocBuilder<CreateUserProfileCubit, CreateUserProfileCubitState>(
      builder: (context, state) {
        return TextFormField(
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.white),
            ),
            labelText: 'Full name',
            helperText: 'Optionally enter your full name',
            errorText: state.displayName.displayError != null
                ? 'Please ensure the full name entered is valid - minimum 4 characters'
                : null,
          ),
          //keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<CreateUserProfileCubit>().displayNameChanged(state.displayName,value);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}