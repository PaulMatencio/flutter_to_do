import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/2_application/core/models/display_name.dart';
import 'package:todo_app/2_application/core/models/email.dart';
import 'package:todo_app/2_application/core/models/photo_url.dart';
import 'package:todo_app/core/use_case.dart';
import '../../../../../1_domain/use_cases/authentication.dart';
import '../../../../core/models/phone_number.dart';

part 'update_user_profile_cubit_state.dart';

class UpdateUserProfileCubit extends Cubit<UpdateUserProfileCubitState> {
  UpdateUserProfileCubit({required this.updateUserProfile,required this.sendEmailVerification})
      : super(UpdateUserProfileCubitState());
  UpdateUserProfile updateUserProfile;
  SendEmailVerification sendEmailVerification;

  void emailChanged(Email email, String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email.isValid ? email : const Email.pure(),
        isValid: Formz.validate([email]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  ///
  ///   DisplayName
  ///

  void displayNameChanged(DisplayName displayName, String value) {
    final displayName = DisplayName.dirty(value);
    debugPrint('displayName changed ${displayName.value}');

    emit(
      state.copyWith(
        displayName:
            displayName.isValid ? displayName : const DisplayName.pure(),
        isValid: Formz.validate([displayName]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void displayNameUnfocused() {
    final displayName = DisplayName.dirty(state.displayName.value);
    emit(
      state.copyWith(
        displayName: displayName,
        isValid: Formz.validate([displayName]),
        status: FormzSubmissionStatus.initial,
      ),
    );
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
        isValid: Formz.validate([state.displayName, phoneNumber]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void phoneNumberUnfocused() {
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([state.displayName, phoneNumber]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  ///
  ///    PhoneNumber
  ///
  void photoUrlChanged(PhotoUrl photoUrl, String value) {
    final photoUrl = PhotoUrl.dirty(value);
    emit(
      state.copyWith(
        photoUrl: photoUrl.isValid ? photoUrl : const PhotoUrl.pure(),
        isValid: Formz.validate([state.displayName, photoUrl]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void photoUrlUnfocused() {
    final photoUrl = PhotoUrl.dirty(state.photoUrl.value);
    emit(
      state.copyWith(
        photoUrl: photoUrl.isValid ? photoUrl : const PhotoUrl.pure(),
        isValid: Formz.validate([state.displayName, photoUrl]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> updateProfile() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final user = UserEntity.empty();
    try {
      await updateUserProfile
          .call(UserParam(
              user: user.copyWith(
            displayName: state.displayName.value,
            photoURL: state.photoUrl.value,
          )))
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



  Future<bool> emailVerification() async {
    bool result = false;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await sendEmailVerification.call(NoParams());
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

}





String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final AuthenticationFailure e:
      return e.stackTrace ?? 'Update profile  Error ';
    default:
      return 'Update profile Error';
  }
}
