

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryLocal implements ToDoRepository {

  @override
  Future<Either<Failure, bool>> createToDoCollection(ToDoCollection todoCollection) {
    // TODO: implement createToDoCollection
    throw UnimplementedError();
  }


  @override
  Future<Either<Failure, bool>> createToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry}) {
    // TODO: implement createToDoEntry
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections() {
    // TODO: implement readToDoCollections
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ToDoEntry>> readToDoEntry(CollectionId collectionId, EntryId entryId) {
    // TODO: implement readToDoEntry
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry}) {
    // TODO: implement updateToDoEntry
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(CollectionId collectionId) {
    // TODO: implement readToDoEntryIds
    throw UnimplementedError();
  }



}