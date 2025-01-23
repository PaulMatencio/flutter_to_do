
part of 'create_user_profile_cubit.dart';

final class CreateUserProfileCubitState extends Equatable {
  const CreateUserProfileCubitState({
    this.email = const Email.pure(),
    this.isEmailVerified = false,
    this.phoneNumber = const PhoneNumber.pure(),
    this.displayName = const DisplayName.pure(),
    this.photoURL = '',
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.createUserprofileError = 'Create User Profile  error',
    this.errorMessage,
  });


  final Email email;
  final bool isEmailVerified;
  final DisplayName displayName;
  final PhoneNumber phoneNumber;
  final String photoURL;
  final FormzSubmissionStatus status;
  final String createUserprofileError;
  final bool isValid;
  final String? errorMessage;

  CreateUserProfileCubitState copyWith({
    Email? email,
    bool? isEmailVerified,
    DisplayName? displayName,
    PhoneNumber? phoneNumber,
    String ? photoURL,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return CreateUserProfileCubitState(
      email: email ?? this.email,
      isEmailVerified: isEmailVerified?? this.isEmailVerified,
      displayName: displayName?? this.displayName,
      phoneNumber: phoneNumber?? this.phoneNumber,
      photoURL: photoURL?? this.photoURL,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email,displayName,status, isValid, errorMessage];

}