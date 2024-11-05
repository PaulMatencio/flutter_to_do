

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class ModifyToDoEntry implements UseCase<bool,ToDoEntryParams> {

  ModifyToDoEntry({
    required this.toDoRepository
  });

  // final collection toDoCollection;
  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, bool>> call(ToDoEntryParams params) async {
   //  print('useCase: modify_todo_entry for collection: ${params.collectionId} - entry description: ${params.entry.description}');
    try {
      final result  =   await toDoRepository.modifyToDoEntry(
          collectionId: params.collectionId, toDoEntry: params.entry);

      return  result.fold(
            (left) => Left(left),
            (right) => Right(right),
      );
    } on Exception catch (e) {

      switch (e) {
        case final ServerFailure _:
          return Left(ServerFailure());
        case final GeneralFailure  e:
          return Left(GeneralFailure(stackTrace: e.stackTrace));
        case final CacheFailure _:
          return Left(CacheFailure());
        default:
          return Left(GeneralFailure());
      }


      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}