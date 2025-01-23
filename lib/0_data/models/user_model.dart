import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';

class UserModel extends Equatable {
  final String email;
  final bool ? emailVerified ;
  final String? uid;
  final String? photoURL;
  final String? phoneNumber;
  final String? displayName;

  const UserModel(
      {required this.email,
        this.emailVerified,
      this.displayName,
      this.uid,
      this.photoURL,
      this.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'],
      emailVerified: json['emailVerified'],
      uid: json['uid'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      photoURL: json['photoUrl']);

  Map<String, dynamic> toJson() => <String, dynamic>{'uid': uid,
    'email': email,
    'isEmailVerified': emailVerified?? false,
    'displayName': displayName?? '',
    'phoneNumber': phoneNumber??'',
    'photoUrl': photoURL??'',
    'createdAt': FieldValue.serverTimestamp()
  };


  factory UserModel.fromFirebaseUser(User user) => UserModel(
      email: user.email ?? '',
      emailVerified: user.emailVerified??  false,
      uid: user.uid,
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '');

  factory UserModel.fromUserEntity(UserEntity user) => UserModel(
      email: user.email ?? '',
      emailVerified: user.emailVerified,
      uid: user.uid,
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '');


  factory UserModel.empty() {
    return UserModel(
        email: '', emailVerified:false, uid: null, photoURL: null, displayName: null, phoneNumber: null);
  }



  @override
  List<Object?> get props => [email,emailVerified, uid, displayName, phoneNumber, photoURL];
}
