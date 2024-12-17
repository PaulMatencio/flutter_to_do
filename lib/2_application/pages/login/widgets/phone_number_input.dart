
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    return BlocBuilder<LoginCubit, LoginCubitState>(
      builder: (context, state) {
        return IntlPhoneField(
          initialValue: state.phoneNumber.value,
          initialCountryCode: 'US',
          invalidNumberMessage: 'Invalid phone number',
          focusNode: focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.phone),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.white),
            ),
            labelText: 'Phone Number',
            helperText: 'A valid phone number',
            errorText: state.phoneNumber.displayError != null
                ? 'Please ensure the phone number  entered is valid'
                : null,
          ),
          keyboardType: TextInputType.phone,

          onChanged: (value) {
            context.read<LoginCubit>().phoneNumberChanged(state.phoneNumber,value.completeNumber);
          },
          onCountryChanged:(country) {
            print('Country changed to: ${country.name}');
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}