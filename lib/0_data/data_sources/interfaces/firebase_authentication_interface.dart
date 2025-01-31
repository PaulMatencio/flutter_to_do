import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/0_data/models/user_model.dart';

abstract class FirebaseAuthenticationInterface {
  Future<User> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<void> createUserProfile({required UserModel user});

  Future<void> resetPassword({required String email});


  Future<User> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<void> updateUserProfile(
      {required UserModel userModel});

  Future<void> sendEmailVerification({required User  user}) ;

  Future<void> signOut();

  Future<void> deleteUser();


  Future<ConfirmationResult> signInWithPhoneNumber(
      {required String phoneNumber});

  Future<void> verifyPhoneNUmber({
    required String phoneNumber,
    Duration timeout,
  });

  Future<UserCredential> confirmationCode({
    required String verificationCode,
    required ConfirmationResult confirmationResult,
  });
}
