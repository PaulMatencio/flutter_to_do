


import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/repositories/authentication_repository.dart';
import 'package:todo_app/core/use_case.dart';
import '../failures/failures.dart';


///
///  Login if it is not already logged In
///
class GetUserProfile implements UseCase<UserEntity,EmailAndPassWordParams> {
  const GetUserProfile({required  this.authenticationRepository});
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
