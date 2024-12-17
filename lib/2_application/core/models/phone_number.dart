import 'package:formz/formz.dart';

enum PhoneNumberValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty([super.value = '']) : super.dirty();


  static final RegExp americanPhoneRegExp =
      RegExp(r'''^(\+)(\d{1,})([(]{1}\d{1,3}[)]){0,}\d{2}\d{3}\d{5}$''');



  @override
  PhoneNumberValidationError? validator(String? value) {
    final phoneNumber = value ?? '';

    final valid =
        americanPhoneRegExp.hasMatch(phoneNumber)   ;

    return valid
        ? null
        : PhoneNumberValidationError.invalid;
  }
}
