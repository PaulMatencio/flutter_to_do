import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class DeleteToDoEntries implements UseCase<List<EntryId>, CollectionIdParam> {
  DeleteToDoEntries({required this.toDoRepository});

  // final collection toDoCollection;
  final ToDoRepository toDoRepository;

  @override
  Future<Either<Failure, List<EntryId>>> call(CollectionIdParam params) async {
    try {
      final result = await toDoRepository.deleteToDoEntries(params.collectionId);
      return result.fold(
            (left) => Left(left),
            (right) => Right(right),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}