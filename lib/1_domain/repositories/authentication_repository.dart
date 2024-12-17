
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/failures/failures.dart';


abstract class AuthenticationRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, bool>> signOut();

  Future<Either<Failure, bool>> deleteUser();

  Stream<UserEntity> authStateChanges();

  Future<Either<Failure, ConfirmationResult>> signInWithPhoneNumber(
      {required String phoneNumber});


  Future<Either<Failure, bool>> verifyPhoneNumber({
    required String phoneNumber,
    });

  Future<Either<Failure, bool>> signInWithCredential(
      {required PhoneAuthCredential credential});

}