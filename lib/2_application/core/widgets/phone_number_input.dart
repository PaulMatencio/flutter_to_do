
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({required this.focusNode,required this.cubit, super.key});

  final FocusNode focusNode;
  final  Function cubit;
  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
        return IntlPhoneField(
          initialValue: cubit().state.phoneNumber.value,
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
            errorText: cubit().state.phoneNumber.displayError != null
                ? 'Please ensure the phone number  entered is valid'
                : null,
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            cubit().phoneNumberChanged(cubit().state.phoneNumber,value.completeNumber);
          },
          onCountryChanged:(country) {
            debugPrint('Country changed to: ${country.name}');
          },
          textInputAction: TextInputAction.next,
        );
  }
}