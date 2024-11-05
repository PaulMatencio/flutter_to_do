

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class DeleteToDoEntry implements UseCase<bool, ToDoEntryIdsParam> {
  const DeleteToDoEntry({required this.toDoRepository});

  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, bool>> call(ToDoEntryIdsParam params) async {
    // print('useCase: delete_todo_entry for  collection:  ${params.collectionId} - entry id: ${params.entryId}');
    try {
      final result = await toDoRepository.deleteToDoEntry(
        collectionId: params.collectionId,
        entryId: params.entryId,
      );
      return result.fold(
            (left) => Left(left),
            (right) {
              print('EntryId ${params.entryId}  is successfully  deleted');
              return Right(true);
            },
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
