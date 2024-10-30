
import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class CreateToDoEntry implements UseCase<bool,ToDoEntryParams> {

  CreateToDoEntry({
    required this.toDoRepository
  });

  // final collection toDoCollection;
  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, bool>> call(ToDoEntryParams params) async {
    try {
      final createToDoEntry =   await toDoRepository.createToDoEntry(
            collectionId: params.collectionId, toDoEntry: params.entry);

      return  createToDoEntry.fold(
            (left) => Left(left),
            (right) => Right(right),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}