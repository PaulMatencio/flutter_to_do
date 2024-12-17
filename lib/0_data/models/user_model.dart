import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Equatable {
  final String email;
  final String? uid;
  final String? photoURL;
  final String? phoneNumber;
  final String? displayName;

  const UserModel(
      {required this.email,
      required this.displayName,
      required this.uid,
      this.photoURL,
      this.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'],
      uid: json['uid'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      photoURL: json['photoUrl']);

  factory UserModel.fromFirebaseUser(User user) => UserModel(
      email: user.email ?? '',
      uid: user.uid,
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '');

  factory UserModel.empty() {
    return UserModel(
        email: '', uid: null, photoURL: null, displayName: null, phoneNumber: null);
  }

  @override
  List<Object?> get props => [email, uid, phoneNumber, photoURL];
}
