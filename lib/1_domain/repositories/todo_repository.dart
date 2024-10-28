
import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';


import '../entities/todo_entry.dart';

abstract class ToDoRepository {
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections();
  Future<Either<Failure, ToDoEntry>> readToDoEntry(CollectionId collectionId, EntryId entryId);
  Future<Either<Failure, ToDoEntry>> updateToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry});
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(CollectionId collectionId);
  Future<Either<Failure, CollectionId>> createToDoCollection(ToDoCollection todoCollection);
  Future<Either<Failure, EntryId>> createToDoEntry({required CollectionId collectionId,required ToDoEntry toDoEntry});
  //Future<Either<Failure, bool>> createToDoCollection(ToDoCollection todoCollection);
}

