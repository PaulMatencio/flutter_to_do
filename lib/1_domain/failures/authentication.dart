
part of 'failures.dart';

class SignUpWithEmailAndPasswordFailure  extends Failure with EquatableMixin  {
     SignUpWithEmailAndPasswordFailure({this.stackTrace});
     final String? stackTrace;
     @override
     List<Object?> get props => [stackTrace];
}

class SignInWithEmailAndPasswordFailure  extends Failure with EquatableMixin  {
  SignInWithEmailAndPasswordFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}

class SignInWithPhoneNumberFailure  extends Failure with EquatableMixin  {
  SignInWithPhoneNumberFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}

class SignOutFailure  extends Failure with EquatableMixin  {
  SignOutFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}

class VerificationFailure  extends Failure with EquatableMixin  {
  VerificationFailure({this.stackTrace});
  final String? stackTrace;
  @override
  List<Object?> get props => [stackTrace];
}
