///  The LoginState consists of an Email, Password, and FormzStatus.
///  The Email and Password models extend FormzInput from the formz packa
part of 'login_cubit.dart';

final class LoginCubitState extends Equatable {
  const LoginCubitState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordVisible = false,
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.emailVerified = false,
    this.confirmationCode = const ConfirmationCode.pure(),
    this.loginError = 'Login error',
    this.confirmationResult,
    this.errorMessage,
  });

  final Email email;
  final bool emailVerified;
  final Password password;
  final bool passwordVisible;
  final PhoneNumber phoneNumber;
  final FormzSubmissionStatus status;
  final String loginError;
  final bool isValid;
  final ConfirmationCode confirmationCode;
  final ConfirmationResult? confirmationResult;
  final String? errorMessage;

  LoginCubitState copyWith({
    Email? email,
    Password? password,
    PhoneNumber? phoneNumber,
    ConfirmationCode? confirmationCode,
    bool? passwordVisible,
    bool?  emailVerified,
    FormzSubmissionStatus? status,
    ConfirmationResult? confirmationResult,
    bool? isValid,
    String? errorMessage,
  }) {
    return LoginCubitState(
      email: email ?? this.email,
      emailVerified: emailVerified??  this.emailVerified,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      confirmationResult: confirmationResult ?? this.confirmationResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        emailVerified,
        password,
        passwordVisible,
        phoneNumber,
        confirmationResult,
        status,
        isValid,
        errorMessage
      ];
}
