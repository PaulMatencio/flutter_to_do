

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/repositories/authentication_repository.dart';
import 'package:todo_app/core/use_case.dart';
import '../failures/failures.dart';


class RegisterWithEmailAndPassword implements UseCase<UserEntity,EmailAndPassWordParams> {
  const RegisterWithEmailAndPassword({required  this.authenticationRepository});
  final  AuthenticationRepository  authenticationRepository;

  @override
  Future<Either<Failure,UserEntity>> call(EmailAndPassWordParams params) async {

    try {
      final  result = await authenticationRepository.signUpWithEmailAndPassword(
          email: params.email.value, password: params.password.value);
      return result.fold(
            (left) => Left(left),
            (right) => Right(right),
      );
    } on Exception catch(e){
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}


class DeleteUser implements UseCase<bool, NoParams> {
  const DeleteUser({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final result = await authenticationRepository.deleteUser();
      return result.fold(
            (failure) => Left(failure),
            (right) => Right(right),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}



class LoginWithEmailAndPassword implements UseCase<UserEntity,EmailAndPassWordParams> {
  const LoginWithEmailAndPassword({required  this.authenticationRepository});
  final  AuthenticationRepository  authenticationRepository;

  @override
  Future<Either<Failure,UserEntity>> call(EmailAndPassWordParams params) async {
    try {
      final  result = await authenticationRepository.signInWithEmailAndPassword(
          email: params.email.value, password: params.password.value);

      return result.fold(
            (left) {
          return Left(left);},
            (right) => Right(right),
      );
    } on Exception catch(e){
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}

class LoginWithPhoneNumber implements UseCase<ConfirmationResult,PhoneNumberParam> {
  const LoginWithPhoneNumber({required  this.authenticationRepository});
  final  AuthenticationRepository  authenticationRepository;

  @override
  ///
  ///   signIn with phone number (web)
  ///
  Future<Either<Failure,ConfirmationResult>> call(PhoneNumberParam  param) async {
   //  print('login with ${param.phoneNumber.value}');
    try {
      final  result = await authenticationRepository.signInWithPhoneNumber(
          phoneNumber: param.phoneNumber.value);

      return result.fold(
            (left) => Left(left),
            (right) => Right(right),
      );
    } on Exception catch(e){
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}

class VerificationCode implements UseCase<UserCredential,VerificationCodeParam> {
  const VerificationCode({required  this.authenticationRepository});
  final  AuthenticationRepository  authenticationRepository;
  @override
  Future<Either<Failure,UserCredential>> call(VerificationCodeParam  param) async {
    //  print('login with ${param.phoneNumber.value}');
    try {
      final  result = await authenticationRepository.confirmationCode(
          confirmationResult: param.confirmationResult, verificationCode: param.verificationCode);

      return result.fold(
            (left) => Left(left),
            (right) => Right(right)
      );
    } on Exception catch(e){
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}


///
/// Verify Phone number ( Android)
///
///
class VerifyPhoneNumber implements UseCase<bool,PhoneNumberParam> {

  const VerifyPhoneNumber({required  this.authenticationRepository});
  final  AuthenticationRepository  authenticationRepository;
  @override
  Future<Either<Failure,bool>> call(
      PhoneNumberParam  param,
      ) async {
    try {
      final  result = await authenticationRepository.verifyPhoneNumber(
        phoneNumber: param.phoneNumber.value,
        ///  on Android device
      );
      return result.fold(
            (left) {
          return Left(left);},
            (right) => Right(right),
      );
    } on Exception catch(e){
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}


class SignOut implements UseCase<bool, NoParams> {
  const SignOut({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final result = await authenticationRepository.signOut();
      return result.fold(
            (failure) => Left(failure),
            (right) => Right(right),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
