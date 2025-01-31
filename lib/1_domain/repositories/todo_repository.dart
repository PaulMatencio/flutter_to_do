import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_dashboard.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';

import '../entities/todo_entry.dart';

abstract class ToDoRepository {
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections();
  Future<Either<Failure, ToDoEntry>> readToDoEntry(CollectionId collectionId, EntryId entryId);
  Future<Either<Failure, ToDoEntry>> updateToDoEntry({required CollectionId collectionId, required EntryId entryId});
  Future<Either<Failure, ToDoEntry>> updateTodoEntry({required CollectionId collectionId, required ToDoEntry todoEntry});
  Future<Either<Failure, bool>> deleteToDoEntry({required CollectionId collectionId, required EntryId entryId});
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(CollectionId collectionId);
  Future<Either<Failure, List<EntryId>>> deleteToDoEntries(CollectionId collectionId);
  Future<Either<Failure, bool>> createToDoCollection(ToDoCollection todoCollection);
  Future<Either<Failure, bool>> deleteToDoCollection(CollectionId collectionId);
  Future<Either<Failure, bool>> deleteUserCollections();
  Future<Either<Failure, bool>> createToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry});
  Future<Either<Failure, bool>> modifyToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry});
  Future<Either<Failure,ToDoDashboard>> createToDoDashboard();
}
