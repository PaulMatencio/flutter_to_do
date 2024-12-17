

class FirebaseAuthenticationException implements Exception {
  final String? stackTrace;
  FirebaseAuthenticationException({required this.stackTrace});
}

class SignInWithEmailAndPasswordException implements Exception {
  final String stackTrace;
  SignInWithEmailAndPasswordException({required this.stackTrace});
}

class SignUpWithEmailAndPasswordException implements Exception {
  final String stackTrace;
  SignUpWithEmailAndPasswordException({required this.stackTrace});
}


class SignUpWithPhoneNumberException implements Exception {
  final String stackTrace;
  SignUpWithPhoneNumberException({required this.stackTrace});
}


class SignOutException implements Exception {
  final String stackTrace;
  SignOutException({required this.stackTrace});
}


class DeleteUserException implements Exception {
  final String stackTrace;
  DeleteUserException({required this.stackTrace});
}


class  VerificationException  implements Exception{
  final String stackTrace;
  VerificationException({required this.stackTrace});
}