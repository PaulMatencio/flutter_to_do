
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/authentication.dart';
import 'package:todo_app/2_application/core/models/models.dart';
import 'package:todo_app/core/use_case.dart';



part 'register_cubit_state.dart';

class RegisterCubit extends Cubit<RegisterCubitState> {
  RegisterCubit({ required this.registerWithEmailAndPassword})
      : super(const RegisterCubitState());

  final RegisterWithEmailAndPassword registerWithEmailAndPassword;

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


  void confirmedPasswordChanged(
      {required ConfirmedPassword password, required String value}) {
    final confirmedPassword = ConfirmedPassword.dirty(value);
    bool isValid = state.confirmedPassword.value == state.password.value ? true: false;
    emit(
      state.copyWith(
        confirmedPassword:confirmedPassword.isValid ? confirmedPassword : const ConfirmedPassword.pure(),
        isValid: Formz.validate([state.email, state.password,confirmedPassword])  && isValid,
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

  void confirmedPasswordUnfocused() {
    final confirmedPassword = ConfirmedPassword.dirty(state.confirmedPassword.value);
    bool isValid = state.confirmedPassword.value == state.password.value ? true: false;
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([state.email, state.password,confirmedPassword])  && isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void togglePasswordVisible() {
    emit (
      state.copyWith(
        passwordVisible: !state.passwordVisible
      )
    );
  }

  ///
  ///  call  use case loginWithEmailAndPassword
  ///
  Future<void> signUpWithEmailAndPassword() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await registerWithEmailAndPassword
          .call(EmailAndPassWordParams(email: state.email, password: state.password))
          .then((result) =>
          result.fold(
                  (failure) =>
                  emit(state.copyWith(
                      errorMessage: _mapFailureToMessage(failure),
                      status: FormzSubmissionStatus.failure)),
                  (right) =>
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
}

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case final SignInWithEmailAndPasswordFailure e:
        return e.stackTrace??'Sign In Error ';
      case final SignUpWithEmailAndPasswordFailure e:
        return e.stackTrace??'Sign Up Error ';
      default: return 'Firebase error';
    }
  }
