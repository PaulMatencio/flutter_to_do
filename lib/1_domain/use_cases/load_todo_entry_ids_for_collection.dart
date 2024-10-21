

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

import '../entities/unique_id.dart';

class LoadToDoEntryIdsForCollection implements UseCase<List<EntryId>, CollectionIdParam> {

  const LoadToDoEntryIdsForCollection({
    required this.toDoRepository,
  });
  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, List<EntryId>>> call(CollectionIdParam params) async {
    try {
      final loadedEntry = toDoRepository.readToDoEntryIds(
        params.collectionId,
      );

      return loadedEntry.fold(
            (left) {
              return Left(left);},
            (right) => Right(right),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}