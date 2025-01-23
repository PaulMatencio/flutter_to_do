
import 'package:formz/formz.dart';

enum DisplayNameValidationError {
  invalid
}

class DisplayName extends FormzInput<String, DisplayNameValidationError> {
  const DisplayName.pure() : super.pure('');
  const DisplayName.dirty([super.value = '']) : super.dirty();

  static final RegExp _fullNameRegExp = RegExp(
     // r"^[a-z ,.'-]+$"
      r"^[a-zA-Z ,.'-]{4,}(?: [a-zA-Z ,.'-]+){0,2}$"

  );

  @override
  DisplayNameValidationError? validator(String? value) {
    return _fullNameRegExp.hasMatch(value ?? '')
        ? null
        : DisplayNameValidationError.invalid;
  }
}
