
part of 'failures.dart';


class AuthenticationFailure  extends Failure with EquatableMixin  {
  AuthenticationFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}

class CreateUserProfileFailure  extends Failure with EquatableMixin  {
  CreateUserProfileFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}


class DeleteUserProfileFailure  extends Failure with EquatableMixin  {
  DeleteUserProfileFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}


class FirebaseAuthFailure  extends Failure with EquatableMixin  {
  FirebaseAuthFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}