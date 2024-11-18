
import 'package:todo_app/1_domain/entities/todo_dashboard.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

//   implements UseCase<List<>,noParams>
class  CreateTodoDashboard implements UseCase<ToDoDashboard, NoParams> {
  const CreateTodoDashboard({required this.toDoRepository});

  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, ToDoDashboard>> call(NoParams params) async {
    try {
      final  result = toDoRepository.createToDoDashboard();
      return result.fold(
            (left) => Left(left),
            (right) => Right(right),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(stackTrace: e.toString()),
      );
    }
  }
}