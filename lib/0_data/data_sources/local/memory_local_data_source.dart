import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source_interface.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';

class MemoryLocalDataSource implements ToDoLocalDataSourceInterface {
  final List<ToDoCollectionModel> toDoCollections = [];
  final Map<String, List<ToDoEntryModel>> toDoEntries = {};

  ///
  ///    createToDoCollection :
  ///    input : CollectionModelModel
  ///    output : bool
  ///    Exception: Collection  not found/ CacheException
  ///

  @override
  Future<bool> createToDoCollection({required ToDoCollectionModel collection}) {
    toDoCollections.add(collection);
    toDoEntries.putIfAbsent(collection.id, () => []);
    return Future.value(true);
  }


  @override
  Future<bool> deleteToDoCollection({required String collectionId}) {
    // TODO: implement deleteToDoCollection
    throw UnimplementedError();
  }

  ///
  ///    createToDoEntry :
  ///    input : CollectionModelId
  ///            ToDoEntryModel
  ///    output : bool
  ///    Exception: Collection  not found
  ///
  @override
  Future<bool> createToDoEntry({required String collectionId, required ToDoEntryModel entryModel}) {
    if (toDoEntries.containsKey(collectionId)) {
      toDoEntries[collectionId]?.add(entryModel);
      return Future.value(true);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }

  ///
  ///    getToDoCollections ->  List<CollectionModelId>
  ///
  @override
  Future<List<String>> getToDoCollectionIds() {
    return Future.value(
      toDoCollections.map((collection) => collection.id).toList(),
    );
  }

  ///
  ///
  ///   getToDoEntry
  ///   input :  CollectionModelId
  ///            EntryModelId
  ///   outPut :  EntryModel
  ///   Exception :  EntryNotFound , CollectionNotFound, CacheException
  ///
  ///

  @override
  Future<ToDoEntryModel> getToDoEntry({required String collectionId, required String entryId}) {
    if (toDoEntries.containsKey(collectionId)) {
      final entry = toDoEntries[collectionId]?.firstWhere(
        (entry) => entry.id == entryId,
        orElse: () => throw EntryNotFoundException(stackTrace: 'entry not found'),
      );

      return Future.value(entry);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) {
    if (toDoEntries.containsKey(collectionId)) {
      return Future.value(
        toDoEntries[collectionId]?.map((entry) => entry.id).toList(),
      );
    } else {
      throw CollectionNotFoundException();
    }
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry({required String collectionId, required String entryId}) {
    if (toDoEntries.containsKey(collectionId)) {
      final indexOfElement = toDoEntries[collectionId]?.indexWhere((entry) => entry.id == entryId);
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
  }

  @override
  Future<ToDoEntryModel> updateTodoEntry({required String collectionId, required ToDoEntryModel entryModel}) {
    // TODO: implement updateTodoEntry
    throw UnimplementedError();
  }



  @override
  Future<ToDoCollectionModel> getToDoCollection({required String collectionId}) {
    final collectionModel = toDoCollections.firstWhere(
      (element) => element.id == collectionId,
      orElse: () => throw CollectionNotFoundException(),
    );

    return Future.value(collectionModel);
  }

  @override
  Future<bool> modifyToDoEntry({required String collectionId, required ToDoEntryModel entryModel}) {
    if (toDoEntries.containsKey(collectionId)) {
      final index = toDoEntries[collectionId]!.indexWhere(((entry) => entry.id == entryModel.id));
      if (index >= 0) {
        final toDoEntry = toDoEntries[collectionId]![index];
        final updateToDoEntry = toDoEntry.copyWith(description: entryModel.description);
        toDoEntries[collectionId]?[index] = updateToDoEntry;
        return Future.value(true);
      } else {
        throw EntryNotFoundException(stackTrace: 'entry not found');
      }
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }

  @override
  Future<bool> deleteToDoEntry({required String collectionId, required String entryId}) {
    if (toDoEntries.containsKey(collectionId)) {
      toDoEntries[collectionId]?.removeWhere((entry) => entry.id == entryId);
      return Future.value(true);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }
}
