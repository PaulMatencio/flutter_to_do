
part of 'update_user_profile_cubit.dart';

final class UpdateUserProfileCubitState extends Equatable {
  const UpdateUserProfileCubitState({
    this.email = const Email.pure(),
    this.isEmailVerified = false,
    this.phoneNumber = const PhoneNumber.pure(),
    this.displayName = const DisplayName.pure(),
    this.photoUrl = const PhotoUrl.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.updateUserprofileError = 'Update User Profile  error',
    this.errorMessage,
  });


  final Email email;
  final bool isEmailVerified;
  final DisplayName displayName;
  final PhoneNumber phoneNumber;
  final PhotoUrl  photoUrl;
  final FormzSubmissionStatus status;
  final String updateUserprofileError;
  final bool isValid;
  final String? errorMessage;

  UpdateUserProfileCubitState copyWith({
    Email? email,
    bool? isEmailVerified,
    DisplayName? displayName,
    PhoneNumber? phoneNumber,
    PhotoUrl? photoUrl,
    String ? photoURL,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return UpdateUserProfileCubitState(
      email: email ?? this.email,
      isEmailVerified: isEmailVerified?? this.isEmailVerified,
      displayName: displayName?? this.displayName,
      phoneNumber: phoneNumber?? this.phoneNumber,
      photoUrl: photoUrl?? this.photoUrl,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email,displayName,photoUrl, status, isValid, errorMessage];

}