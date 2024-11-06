import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';

class MemoryLocalDataSource implements ToDoLocalDataSourceInterface {
  final List<ToDoCollectionModel> toDoCollections = [];
  final Map<String, List<ToDoEntryModel>> toDoEntries = {};

  /*
  Future<List<ToDoCollectionModel>> getToDoCollections() {
    try {
      return Future.value(toDoCollections);
    } on Exception catch (e) {
      throw ServerException(stackTrace: e.toString());
    }
  }
   */

  @override
  Future<bool> createToDoCollection({required ToDoCollectionModel collection}) {
    toDoCollections.add(collection);
    toDoEntries.putIfAbsent(collection.id, () => []);
    return Future.value(true);
  }

  @override
  Future<bool> createToDoEntry(
      {required String collectionId, required ToDoEntryModel entryModel}) {
    if (toDoEntries.containsKey(collectionId)) {
      toDoEntries[collectionId]?.add(entryModel);
      return Future.value(true);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }

  /// @override
  /// Future<List<String>> getToDoCollectionIds() {
  ///   final List<String> toDoCollectionIds = [];
  ///   toDoCollections.map((collection) => {toDoCollectionIds.add(collection.id)});
  ///   return Future.value(toDoCollectionIds);
  /// }

  @override
  Future<List<String>> getToDoCollectionIds() {
    try {
      return Future.value(
        toDoCollections.map((collection) => collection.id).toList(),
      );
    } on Exception catch (e) {
      throw CacheException(stackTrace: e.toString());
    }
  }

  @override
  Future<ToDoEntryModel> getToDoEntry(
      {required String collectionId, required String entryId}) {
    try {
      if (toDoEntries.containsKey(collectionId)) {
        final entry = toDoEntries[collectionId]?.firstWhere(
              (entry) => entry.id == entryId,
          orElse: () => throw EntryNotFoundException(stackTrace: 'entry not found'),
        );

        return Future.value(entry);
      } else {
        throw CollectionNotFoundException(stackTrace: 'collection not found');
      }
    } on Exception catch (e) {
      throw CacheException(stackTrace: e.toString());
    }
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) {
    try {
      if (toDoEntries.containsKey(collectionId)) {
        return Future.value(
          toDoEntries[collectionId]?.map((entry) => entry.id).toList(),
        );
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (e) {
      throw CacheException(stackTrace: e.toString());
    }
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry(
      {required String collectionId, required String entryId}) {
    try {
      if (toDoEntries.containsKey(collectionId)) {
        final indexOfElement = toDoEntries[collectionId]
            ?.indexWhere((entry) => entry.id == entryId);
        if (indexOfElement == null || indexOfElement == -1) {
          throw EntryNotFoundException();
        }
        final entry = toDoEntries[collectionId]?[indexOfElement];
        if (entry == null) {
          throw EntryNotFoundException();
        }
        final updatedEntry = ToDoEntryModel(
          id: entry.id,
          description: entry.description,
          isDone: !entry.isDone,
        );
        toDoEntries[collectionId]?[indexOfElement] = updatedEntry;
        return Future.value(updatedEntry);
      } else {
        throw CollectionNotFoundException();
      }
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoCollectionModel> getToDoCollection({required String collectionId}) {
    try {
      final collectionModel = toDoCollections.firstWhere(
            (element) => element.id == collectionId,
        orElse: () => throw CollectionNotFoundException(),
      );

      return Future.value(collectionModel);
    } on Exception catch (e) {
      throw CacheException(stackTrace: e.toString());
    }
  }


  @override
  Future<bool> modifyToDoEntry(
      {required String collectionId, required ToDoEntryModel entryModel}) {
    // TODO: implement update2ToDoEntry
    try {
      if (toDoEntries.containsKey(collectionId)) {
        final index = toDoEntries[collectionId]!
            .indexWhere(((entry) => entry.id == entryModel.id));
        if (index >= 0) {
          final toDoEntry = toDoEntries[collectionId]![index];
          //  update the todoEntry model
          final updateToDoEntry =
              toDoEntry.copyWith(description: entryModel.description);
          // update the todoEntries repository
          toDoEntries[collectionId]?[index] = updateToDoEntry;

          return Future.value(true);
        } else {
          throw EntryNotFoundException(stackTrace: 'entry not found');
        }
      } else {
        throw CollectionNotFoundException(stackTrace: 'collection not found');
      }
    } on Exception catch (e) {
      throw CacheException(stackTrace: e.toString());
    }
  }

  @override
  Future<bool> deleteToDoEntry(
      {required String collectionId, required String entryModelId}) {
    //  throw  ServerException(stackTrace:'Ups server exception');
    // print('deleteToDoEntry model id $entryModelId');
    try {
      if (toDoEntries.containsKey(collectionId)) {
        toDoEntries[collectionId]
            ?.removeWhere((entry) => entry.id == entryModelId);
        return Future.value(true);
      } else {
        throw CollectionNotFoundException(stackTrace: 'collection not found');
      }
    } on Exception catch (e) {
      throw CacheException(stackTrace: e.toString());
    }
  }
}
