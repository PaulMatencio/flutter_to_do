

import 'package:formz/formz.dart';
enum ConfirmedPasswordValidationError {
  invalid
}

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure() : super.pure('');
  const ConfirmedPassword.dirty([super.value = '']) : super.dirty();
  static final _passwordRegExp =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{10,}$');
  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}