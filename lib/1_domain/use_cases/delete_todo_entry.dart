

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class DeleteToDoEntry implements UseCase<bool, ToDoEntryIdsParam> {
  const DeleteToDoEntry({required this.toDoRepository});

  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, bool>> call(ToDoEntryIdsParam params) async {
    try {
      final result = await toDoRepository.deleteToDoEntry(
        collectionId: params.collectionId,
        entryId: params.entryId,
      );
      return result.fold(
            (left) => Left(left),
            (right) => Right(true),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
