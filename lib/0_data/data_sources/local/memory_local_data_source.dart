import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';

class ToDoRepositoryLocal implements ToDoLocalDataSource {
  final List<ToDoCollectionModel> toDoCollections = [];
  final Map<String, List<ToDoEntryModel>> toDoEntries = {};

  @override
  Future<bool> createToDoCollection({required ToDoCollectionModel collection}) {
    try {
      toDoCollections.add(collection);
      toDoEntries.putIfAbsent(collection.id, () => []);
      return Future.value(true);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<bool> createToDoEntry(
      {required String collectionId, required ToDoEntryModel entry}) {
    try {
      toDoEntries[collectionId]!.add(entry);
      return Future.value(true);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getToDoCollectionIds() {
    // TODO: implement getToDoCollectionIds
    final List<String> toDoCollectionIds = [];
    try {
      for (int i = 0; i < toDoCollections.length; i++) {
        toDoCollectionIds.add(toDoCollectionIds[i]);
      }
      return Future.value(toDoCollectionIds);
    } on Exception catch (_) {
      throw CacheException();
    }
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) {
    // TODO: implement getToDoEntryIds
    final List<String> toDoEntryIds = [];
    try {
      if (toDoEntries.keys.toList().contains(collectionId)) {
        final entries = toDoEntries[collectionId];
        for (int i = 0; i < entries!.length; i++) {
          toDoEntryIds.add(entries[i].id);
        }
      }
    } on Exception catch (e) {
      throw CacheException();
    }
    throw UnimplementedError();
  }

  @override
  Future<ToDoEntryModel> getToDoEntry(
      {required String collectionId, required String entryId}) {
    // TODO: implement getToDoEntry
    throw UnimplementedError();
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry(
      {required String toDoCollectionId,
      required ToDoEntryModel todoEntryModel}) {
    // TODO: implement updateToDoEntry
    throw UnimplementedError();
  }

  @override
  Future<ToDoCollectionModel> getToDoCollection(
      {required String collectionId}) {
    // TODO: implement getToDoCollection
    throw UnimplementedError();
  }
}
