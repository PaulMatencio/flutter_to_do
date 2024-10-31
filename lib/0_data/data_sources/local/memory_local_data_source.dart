import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
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
      {required String collectionId, required ToDoEntryModel entryModel}) {
    try {
      if (toDoEntries.containsKey(collectionId)) {
        toDoEntries[collectionId]!.add(entryModel);
        return Future.value(true);
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getToDoCollectionIds() {
    final List<String> toDoCollectionIds = [];
    try {
      for (int i = 0; i < toDoCollections.length; i++) {
        toDoCollectionIds.add(toDoCollections[i].id);
      }
      return Future.value(toDoCollectionIds);
    } on Exception catch (_) {
      throw CacheException();
    }
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) {
    final List<String> toDoEntryIds = [];
    try {
      if (toDoEntries.containsKey(collectionId)) {
        final entries = toDoEntries[collectionId];
        for (int i = 0; i < entries!.length; i++) {
          toDoEntryIds.add(entries[i].id);
        }
        return Future.value(toDoEntryIds);
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoEntryModel> getToDoEntry(
      {required String collectionId, required String entryId}) {
    // TODO: implement getToDoEntry
    try {
      if (toDoEntries.containsKey(collectionId)) {
        final index =
            toDoEntries[collectionId]!.indexWhere((item) => item.id == entryId);
        if (index > 0) {
          return Future.value(toDoEntries[collectionId]![index]);
        } else {
          throw EntryNotFoundException();
        }
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry(
      {required String collectionId, required ToDoEntryModel entryModel}) {
    // TODO: implement updateToDoEntry
    try {
      if (toDoEntries.containsKey(collectionId)) {
        final int index = toDoEntries[collectionId]!
            .indexWhere(((item) => item.id == entryModel.id));
        if (index > 0) {
          final toDoEntry = toDoEntries[collectionId]![index];
          final updateToDoEntry = toDoEntry.copyWith(isDone: !toDoEntry.isDone);
          toDoEntries[collectionId]![index] = updateToDoEntry;
          return Future.value(updateToDoEntry);
        } else {
          throw EntryNotFoundException();
        }
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoCollectionModel> getToDoCollection(
      {required String collectionId}) {
    try {
      final index =
          toDoCollections.indexWhere((item) => item.id == collectionId);
      if (index > 0) {
        return Future.value(toDoCollections[index]);
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (_) {
      throw CacheException();
    }
  }
}
