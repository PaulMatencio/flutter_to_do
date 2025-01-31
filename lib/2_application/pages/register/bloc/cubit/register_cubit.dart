import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/authentication.dart';
import 'package:todo_app/1_domain/use_cases/delete_user_collections.dart';
import 'package:todo_app/2_application/core/models/models.dart';
import 'package:todo_app/core/use_case.dart';

part 'register_cubit_state.dart';

class RegisterCubit extends Cubit<RegisterCubitState> {
  RegisterCubit(
      {required this.registerWithEmailAndPassword,
      required this.deleteAccount,
      required this.deleteUserCollections})
      : super(const RegisterCubitState());

  final RegisterWithEmailAndPassword registerWithEmailAndPassword;
  final DeleteAccount deleteAccount;
  final DeleteUserCollections deleteUserCollections;

  ///
  ///   Email
  ///
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
  ///   password
  ///
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

  ///
  ///
  ///   ConfirmedPassword
  ///
  void confirmedPasswordChanged(
      {required ConfirmedPassword password, required String value}) {
    final confirmedPassword = ConfirmedPassword.dirty(value);
    bool isValid =
        confirmedPassword.value == state.password.value ? true : false;
    /*
       debugPrint('password valid: ${state.password.isValid}  ${state.password.value}  '
        'c_password valid  ${confirmedPassword.isValid} ${confirmedPassword.value } '
        'isValid $isValid');
     */
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword.isValid
            ? confirmedPassword
            : const ConfirmedPassword.pure(),
        isValid:
            Formz.validate([state.email, state.password, confirmedPassword]) &&
                isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void confirmedPasswordUnfocused() {
    final confirmedPassword =
        ConfirmedPassword.dirty(state.confirmedPassword.value);
    bool isValid =
        (confirmedPassword.value == state.password.value) ? true : false;

    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid:
            Formz.validate([state.email, state.password, confirmedPassword]) &&
                isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void togglePasswordVisible() {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  ///
  ///  call  use case loginWithEmailAndPassword
  ///
  Future<void> signUpWithEmailAndPassword() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await registerWithEmailAndPassword
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

  Future<void> createUserProfile() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress,
    errorMessage: ''));
    try {
      await registerWithEmailAndPassword
          .call(EmailAndPassWordParams(
              email: state.email, password: state.password))
          .then((result) => result.fold(
                  (failure) => emit(state.copyWith(
                      errorMessage: _mapFailureToMessage(failure),
                      status: FormzSubmissionStatus.failure)), (user) {
                emit(state.copyWith(status: FormzSubmissionStatus.success));
              }));
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

  Future<bool> deleteUser() async {
    bool ok = false;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress,
    errorMessage: ''));
    ///
    /// delete  all user data
    /// if ok => delete firebase user
    ///
    ///
    try {
      await deleteUserCollections.call(NoParams()).then((result) => result.fold(
              (failure) => emit(state.copyWith(
                  errorMessage: _mapFailureToMessage(failure),
                  status: FormzSubmissionStatus.failure)), (right) async {
            emit(state.copyWith(status: FormzSubmissionStatus.success));
            debugPrint('delete user collections ok ? $right');
            if (right) {
              await deleteAccount.call(NoParams()).then((result1) =>
                  result1.fold(
                          (failure) => emit(state.copyWith(
                          errorMessage: _mapFailureToMessage(failure),
                          status: FormzSubmissionStatus.failure)),
                          (right) {
                    emit(state.copyWith(
                       password: Password.pure(),
                        confirmedPassword: ConfirmedPassword.pure(),
                        status: FormzSubmissionStatus.success));
                    ok = right;
                  }));
            }

          }));
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
    return ok;
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final AuthenticationFailure e:
      return e.stackTrace ?? 'Create account  Error ';
    case final AuthenticationFailure e:
      return e.stackTrace ?? 'Create account  Error ';
    default:
      return 'Create account error';
  }
}
