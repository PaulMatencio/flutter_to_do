


class AuthenticationException implements Exception {
  final String stackTrace;
  AuthenticationException({required this.stackTrace});
}

class ResetPasswordException implements Exception {
  final String stackTrace;
  ResetPasswordException({required this.stackTrace});
}

/*
class DeleteUserException implements Exception {
  final String stackTrace;
  DeleteUserException({required this.stackTrace});
}

 */

class CreateUserProfileException implements Exception {
  final String stackTrace;
  CreateUserProfileException({required this.stackTrace});
}


