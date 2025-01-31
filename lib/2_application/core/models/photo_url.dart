

import 'package:formz/formz.dart';

enum PhotoUrlValidationError {
  invalid
}

class  PhotoUrl extends FormzInput<String, PhotoUrlValidationError> {
  const PhotoUrl.pure() : super.pure('');
  const PhotoUrl.dirty([super.value = '']) : super.dirty();

  static final RegExp _fullNameRegExp = RegExp(
      r'(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?'
  );

  @override
  PhotoUrlValidationError? validator(String? value) {
    return _fullNameRegExp.hasMatch(value ?? '')
        ? null
        : PhotoUrlValidationError.invalid;
  }
}