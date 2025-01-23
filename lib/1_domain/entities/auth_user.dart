import 'package:todo_app/0_data/models/user_model.dart';

class UserEntity {
  final String email;
  final String? uid;
  final String? photoURL;
  final String? phoneNumber;
  final String? displayName;
  final bool?  emailVerified;

  const UserEntity(
      {required this.email,
        this.emailVerified,
      this.displayName,
      this.uid,
      this.photoURL,
      this.phoneNumber});

  factory UserEntity.empty() {
    return UserEntity(
        email: '',
        uid: null,
        emailVerified: false,
        photoURL: null,
        displayName: null,
        phoneNumber: null);
  }

  factory UserEntity.fromUserModel(UserModel user) => UserEntity(
      email: user.email ?? '',
      emailVerified: user.emailVerified,
      uid: user.uid,
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '');


  UserEntity copyWith({String? email, String? displayName, String ? phoneNumber,
  String ? photoURL}) {
    return UserEntity(
        uid: uid,
        email: email ?? this.email,
        emailVerified: emailVerified??  this.emailVerified,
        displayName: displayName ?? this.displayName,
        phoneNumber: phoneNumber??  this.phoneNumber,
        photoURL: photoURL ?? this.photoURL
    );
  }
}
