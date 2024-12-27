import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/0_data/data_sources/interfaces/firebase_authentication_interface.dart';
import 'package:todo_app/0_data/exceptions/authentication.dart';
import 'package:todo_app/0_data/models/user_model.dart';
import 'package:todo_app/firebase_options.dart';

class FirebaseAuthentication implements FirebaseAuthenticationInterface {
  bool isInitialized = false;
  late FirebaseApp app;
  late FirebaseAuth auth;


  ///
  /// The AuthenticationRepository exposes a Stream<UserModel> which we can subscribe to in order to be notified of when a User changes.
  /// In addition, it exposes methods to signUp signInWithEmailAndPassword, and signOut
  ///
  ///    Stream of UserModel
  ///
  Stream<UserModel> authStateChanges() {
    ///  convert the authStateChanges stream of  User to return of stream UserModel

    return auth.authStateChanges().map((firebaseUser) {
      final user = (firebaseUser == null)
          ? UserModel.empty()
          : UserModel.fromFirebaseUser(firebaseUser);
      return user;
    });
  }

  Future<void> init() async {
    if (!isInitialized) {
      app = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      auth = FirebaseAuth.instanceFor(app: app);
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );
      ///  initialize  Cloud FireStore


      isInitialized = true;
    } else {
      debugPrint('Firebase was already initialized!');
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final user = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) => userCredential.user);
      return Future.value(user);
    } on FirebaseException catch (e) {
      // debugPrint(e.code);
      throw SignUpWithEmailAndPasswordException(stackTrace: e.code);
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final user = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) => userCredential.user);
      return Future.value(user);
    } on FirebaseException catch (e) {
      //debugPrint(e.code);
      throw SignInWithEmailAndPasswordException(stackTrace: e.code);
    }
  }

  ///
  /// https://firebase.flutter.dev/docs/auth/phone/
  ///
  @override
  Future<void> verifyPhoneNUmber({
    required String phoneNumber,
    Duration? timeout,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout ?? const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential)=> verificationCompleted(credential),
      verificationFailed: (FirebaseAuthException e) => verificationFailed(e),
      codeSent: (String verificationId, int? resendToken)=> codeSent(verificationId,resendToken),
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);
  }

  void verificationFailed(FirebaseAuthException e) {
    throw VerificationException(stackTrace: e.code);
  }
  ///   todo for Android
  void codeSent( String verificationId , int ? resendToken) async {
    String smsCode = 'xxxx';
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await auth.signInWithCredential(credential);

  }

  ///
  ///   Web platform
  ///   return   confirmation result
  ///
  @override
  Future<ConfirmationResult> signInWithPhoneNumber(
      {required String phoneNumber}) async {
    try {
      final confirmationResult = await auth.signInWithPhoneNumber(phoneNumber);
      return confirmationResult;
    } on FirebaseException catch (e) {
      debugPrint(e.code);
      throw SignUpWithPhoneNumberException(stackTrace: e.code);
    }
  }

  @override
  Future<UserCredential>  confirmationCode({required String verificationCode, required ConfirmationResult confirmationResult}) async {
    // TODO: implement confirmationCode
    UserCredential userCredential;
    try {
     userCredential= await confirmationResult.confirm(verificationCode);
    }  on FirebaseException catch (e) {
      debugPrint(e.code);
      throw SignUpWithPhoneNumberException(stackTrace: e.code);
    }
    return userCredential;
  }



  ///
  /// logout
  ///
  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseException catch (e) {
      throw SignOutException(stackTrace: e.code);
    }
  }


  ///
  /// delete account
  ///
  @override
  Future<void> deleteUser() async {
    try {
      await auth.currentUser?.delete();
    } on FirebaseException catch (e) {
      throw DeleteUserException(stackTrace: e.code);
    }
  }
}
