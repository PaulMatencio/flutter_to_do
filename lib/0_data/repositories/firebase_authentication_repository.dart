import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/0_data/data_sources/firebase/firebase_authentication.dart';
import 'package:todo_app/0_data/exceptions/authentication.dart';
import 'package:todo_app/0_data/models/user_model.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/authentication_repository.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  FirebaseAuthenticationRepository({required this.authentication});

  FirebaseAuthentication authentication;

  @override
  Stream<UserEntity> authStateChanges() {
    return authentication.authStateChanges().map((userModel) {
      final user = userModel.uid == null
          ? UserEntity.empty()
          : UserEntity.fromUserModel(userModel);
      return user;
    });
  }


  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await authentication.createUserWithEmailAndPassword(
          email: email, password: password);

      return Right(userToUserEntity(result));
    } on AuthenticationException catch (e) {
      debugPrint(e.stackTrace);
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserProfile({required userEntity}) async {
    // TODO: implement updateUserProfile
    try {
      await authentication.updateUserProfile(userModel: UserModel.fromUserEntity(userEntity));
      return Right(true);
    } on AuthenticationException catch (e) {
    debugPrint(e.stackTrace);
    return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }

  @override
  Future<Either<Failure, bool>> sendEmailVerification() async {
    // TODO: implement updateUserProfile
    final  user = authentication.auth.currentUser;
    if (user != null) {
      try {
        await authentication.sendEmailVerification(user:user);
        return Right(true);
      } on AuthenticationException catch (e) {
        debugPrint(e.stackTrace);
        return Left(AuthenticationFailure(stackTrace: e.stackTrace));
      }
    }  else {
      return Left(AuthenticationFailure(stackTrace: 'user must be logged in first'));
    }

  }


  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final user = await authentication.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(userToUserEntity(user));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }



  @override
  Future<Either<Failure, bool>> resetPassword(
      {required String email}) async {
    try {
         await authentication.resetPassword(
          email: email);
      return Right(true);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }


  @override
  Future<Either<Failure, ConfirmationResult>> signInWithPhoneNumber(
      {required String phoneNumber}) async {
    try {
      final confirmationResult =
      await authentication.signInWithPhoneNumber(phoneNumber: phoneNumber);
      //  print('Result .... $confirmationResult');
      return Right(confirmationResult);
    } on AuthenticationException catch (e) {
      debugPrint(e.stackTrace);
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }


  @override
  Future<Either<Failure, UserCredential>> confirmationCode(
      {required ConfirmationResult confirmationResult, required String verificationCode}) async {
    try {
      final result = await confirmationResult.confirm(verificationCode);
      return Right(result);
    } on AuthenticationException catch (e) {
      debugPrint(e.stackTrace);
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }


  @override
  Future<Either<Failure, bool>> signInWithCredential(
      {required PhoneAuthCredential credential}) {
    // TODO: implement signInWithCredential
    throw UnimplementedError();
  }

  ///
  ///
  ///  todd
  ///
  @override
  Future<Either<Failure, bool>> verifyPhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      final result = await authentication.verifyPhoneNUmber(
        phoneNumber: phoneNumber,
      );

      return Right(true);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }

  ///
  ///  todo
  ///
  verificationFailed(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      debugPrint('The provided phone number is not valid.');
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await authentication.signOut();
      return Right(true);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    try {
      await authentication.deleteUser();
      return Right(true);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(stackTrace: e.stackTrace));
    }
  }
  ///
  ///
  ///  Create user profile in fire store
  ///
  @override
  Future<Either<Failure, bool>> createUserProfile(
      {required UserEntity  user}) async {
    try {
      await authentication.createUserProfile(
          user: UserModel.fromUserEntity(user));
      return Right(true);
    } on CreateUserProfileException catch (e) {
      return Left(CreateUserProfileFailure(stackTrace: e.stackTrace));
    }
  }

  ///
  ///   firebase user to UserEntity
  ///
  UserEntity userToUserEntity(User user) {
    return UserEntity(
        email: user.email ?? '',
        emailVerified: user.emailVerified?? false,
        displayName: user.displayName ?? '',
        uid: user.uid,
        photoURL: user.photoURL ?? '');
  }

}