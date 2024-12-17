

import 'package:todo_app/0_data/models/user_model.dart';

class UserEntity {
  final String email;
  final String ? uid;
  final String ? photoURL;
  final String ? phoneNumber;
  final String ? displayName;


  const UserEntity({
    required this.email,
    this.displayName,
    this.uid,
    this.photoURL,
    this.phoneNumber });

  factory UserEntity.empty() {
    return UserEntity(
        email: '',
        uid: null,
        photoURL: null,
        displayName: null,
        phoneNumber: null
    );
  }

  factory UserEntity.fromUserModel(UserModel user) => UserEntity(
      email: user.email ?? '',
      uid: user.uid,
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '');


}