import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:todo_app/2_application/core/models/display_name.dart';
import 'package:todo_app/2_application/core/models/email.dart';
import '../../../../../1_domain/use_cases/authentication.dart';
import '../../../../core/models/phone_number.dart';

part 'create_user_profile_cubit_state.dart';

class CreateUserProfileCubit extends Cubit<CreateUserProfileCubitState> {
  CreateUserProfileCubit({required this.createUserProfile1})
      : super(CreateUserProfileCubitState());
  CreateUserProfile createUserProfile1;

  ///
  ///   DisplayName
  ///

  void displayNameChanged(DisplayName displayName, String value) {
    final displayName = DisplayName.dirty(value);
    // debugPrint(displayName.value);
    emit(
      state.copyWith(
        displayName: displayName,
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
        isValid: Formz.validate([state.phoneNumber, phoneNumber]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void phoneNumberUnfocused() {
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([state.phoneNumber, phoneNumber]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> createUserProfile() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
  }
}
