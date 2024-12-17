

import 'package:formz/formz.dart';

enum ConfirmationCodeValidationError {
  invalid
}

class ConfirmationCode extends FormzInput<String, ConfirmationCodeValidationError> {
  const ConfirmationCode.pure() : super.pure('123456');
  const ConfirmationCode.dirty([super.value = '']) : super.dirty();
  ///   must match 6 digits
  static final RegExp _confirmationCodeRegExp = RegExp(
    r'^[1-9][0-9]{5}$',
  );

  @override
  ConfirmationCodeValidationError? validator(String? value) {
    return _confirmationCodeRegExp.hasMatch(value ?? '')
        ? null
        : ConfirmationCodeValidationError.invalid;
  }
}