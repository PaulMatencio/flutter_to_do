
part of 'register_cubit.dart';

final class RegisterCubitState extends Equatable {
  const RegisterCubitState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordVisible= false,
    this.confirmedPassword  = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.signUpError = 'Sign Up error',
    this.errorMessage,
  });


  final Email email;
  final Password password;
  final bool passwordVisible;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final String signUpError;
  final bool isValid;
  final String? errorMessage;

  RegisterCubitState copyWith({
    Email? email,
    Password? password,
    bool ? passwordVisible,
    ConfirmedPassword?confirmedPassword,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return RegisterCubitState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisible: passwordVisible??this.passwordVisible,
      confirmedPassword: confirmedPassword?? this.confirmedPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, passwordVisible, confirmedPassword,status, isValid, errorMessage];

}
