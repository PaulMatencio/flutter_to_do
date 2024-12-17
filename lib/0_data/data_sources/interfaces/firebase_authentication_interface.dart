import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthenticationInterface {
  Future<User> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<User> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<void> signOut();

  Future<void> deleteUser();

  Future<ConfirmationResult> signInWithPhoneNumber(
      {required String phoneNumber});

  Future<void> verifyPhoneNUmber({
    required String phoneNumber,
    Duration timeout,
  });
}
