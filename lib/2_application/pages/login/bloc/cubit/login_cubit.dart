import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/authentication.dart';
import 'package:todo_app/2_application/core/models/confirmation_code.dart';
import 'package:todo_app/2_application/core/models/models.dart';
import 'package:todo_app/core/use_case.dart';
part 'login_cubit_state.dart';

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit(
      {required this.loginWithEmailAndPassword,
      required this.signOut,
      required this.signInWithPhoneNumber,

      /// repository sigInWithPhoneNumber
      required this.verifyPhoneNumber})
      : super(const LoginCubitState());

  final LoginWithEmailAndPassword loginWithEmailAndPassword;
  final SignOut signOut;
  final LoginWithPhoneNumber signInWithPhoneNumber;
  final VerifyPhoneNumber verifyPhoneNumber;

  ///
  ///  email
  ///

  void emailChanged(Email email, String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email.isValid ? email : const Email.pure(),
        isValid: Formz.validate([email, state.password]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void emailUnfocused(Email? email) {
    final email = Email.dirty(state.email.value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  ///
  /// password
  ///
  void passwordChanged({required Password password, required String value}) {
    // final Password password;
    //password.value = value;
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password.isValid ? password : const Password.pure(),
        isValid: Formz.validate([state.email, password]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void passwordUnfocused() {
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void togglePasswordVisible() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }


  ///
  ///    PhoneNumber
  ///
  void phoneNumberChanged(PhoneNumber phoneNumber, String value) {
    final phoneNumber = PhoneNumber.dirty(value);
    emit(
      state.copyWith(
        phoneNumber:
            phoneNumber.isValid ? phoneNumber : const PhoneNumber.pure(),
        isValid: Formz.validate([state.phoneNumber, phoneNumber]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void phoneNumberUnfocused(PhoneNumber? phoneNumber) {
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([state.phoneNumber, phoneNumber]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  ///
  ///   confirmation code
  ///

  void confirmationCodeChanged(
      ConfirmationCode confirmationCode, String value) {
    final confirmationCode = ConfirmationCode.dirty(value);
    emit(
      state.copyWith(
        confirmationCode: confirmationCode.isValid
            ? confirmationCode
            : const ConfirmationCode.pure(),
        isValid: Formz.validate([state.confirmationCode, confirmationCode]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }
  void confirmationCodeUnfocused(ConfirmationCode? confirmationCode) {
    final confirmationCode = ConfirmationCode.dirty(state.confirmationCode.value);
    emit(
      state.copyWith(
       confirmationCode: confirmationCode,
        isValid: Formz.validate([state.confirmationCode,confirmationCode]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }
  ///
  ///  call  use case loginWithEmailAndPassword
  ///
  ///
  Future<void> signInWithEmailAndPassword() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await loginWithEmailAndPassword
          .call(EmailAndPassWordParams(
              email: state.email, password: state.password))
          .then((result) => result.fold(
              (failure) => emit(state.copyWith(
                  errorMessage: _mapFailureToMessage(failure),
                  status: FormzSubmissionStatus.failure)),
              (user) =>
                  emit(state.copyWith(status: FormzSubmissionStatus.success))));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }


  ///
  ///  signInWithPhoneNumber send back  confirmationResult
  ///  The application need to conform  with a code ( confirmation Code)
  ///
  Future<void> logInWithPhoneNumber() async {
    if (!state.isValid) return ;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final result = await signInWithPhoneNumber
          .call(PhoneNumberParam(phoneNumber: state.phoneNumber));
      if (result.isRight) {
        ///
        /// save the confirmation result state which will be confirmed
        ///   later with the confirmation_code_page.dart
        ///
        emit(state.copyWith(confirmationResult: result.right));
      } else {
        emit(state.copyWith(
            errorMessage: _mapFailureToMessage(result.left),
            status: FormzSubmissionStatus.failure));
      }
    } on Exception catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: FormzSubmissionStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }

  }

  ///
  ///   confirmation result was returned by loginWithPhoneNumber()
  ///
  Future<UserCredential?> confirmResult()  async{
    UserCredential?  userCredential;
    final confirmationResult = state.confirmationResult;

    if (confirmationResult != null ) {
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
      try {
        print('sent confirm code');
        userCredential = await confirmationResult.confirm(state.confirmationCode.value);
        if (userCredential.user  != null) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else{
          emit(state.copyWith(
              errorMessage:state.loginError, status: FormzSubmissionStatus.failure));
        }
      } on Exception catch (e) {
        emit(state.copyWith(
            errorMessage: e.toString(), status: FormzSubmissionStatus.failure));
      }
    }
    return userCredential;
  }
  ///
  ///
  /// Android
  ///
  Future<void> checkPhoneNumber({required PhoneNumberParam param}) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await verifyPhoneNumber
          .call(PhoneNumberParam(phoneNumber: param.phoneNumber));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage:  e.toString()));
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> codeSent(String verificationId, int? resendToken) async {
    ///
    ///  todo -----  > update for getting the SMS code
    ///
    String smsCode = '123';
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    // await ignInWithCredential(credential);
  }

  Future<bool> logOut() async {
    bool result = false;
    if (!state.isValid) return result;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await signOut.call(NoParams());
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      result = true;
      // emit(LoginCubitState(isLoggedIn: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
    return result;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case final SignInWithEmailAndPasswordFailure e:
        return e.stackTrace ?? 'Sign In Error ';
      case final SignUpWithEmailAndPasswordFailure e:
        return e.stackTrace ?? 'Sign Up Error ';
      default:
        return 'Firebase error';
    }
  }
}
