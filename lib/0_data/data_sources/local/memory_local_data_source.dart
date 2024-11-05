import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';

class MemoryLocalDataSource implements ToDoLocalDataSource {
  final List<ToDoCollectionModel> toDoCollections = [];
  final Map<String, List<ToDoEntryModel>> toDoEntries = {};

  Future<List<ToDoCollectionModel>> getToDoCollections() {
    try {
      return Future.value(toDoCollections);
    } on Exception catch (e) {
      throw ServerException(stackTrace: e.toString());
    }
  }

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

  @override
  Future<bool> deleteToDoEntry({required String collectionId, required String entryModelId}) {
   //  throw  ServerException(stackTrace:'Ups server exception');
    print('deleteToDoEntry model id $entryModelId');
    if (toDoEntries.containsKey(collectionId)) {
      toDoEntries[collectionId]?.removeWhere((entry) => entry.id == entryModelId);
      return Future.value(true);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
    throw UnimplementedError();
  }


  @override
  Future<List<String>> getToDoCollectionIds() {
    final List<String> toDoCollectionIds = [];
    toDoCollections.map( (collection) => {
      toDoCollectionIds.add(collection.id)
    });

    return Future.value(toDoCollectionIds);
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) {
    final List<String> toDoEntryIds = [];

    if (toDoEntries.containsKey(collectionId)) {
      final entries = toDoEntries[collectionId];
      for (int i = 0; i < entries!.length; i++) {
        toDoEntryIds.add(entries[i].id);
      }
      return Future.value(toDoEntryIds);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }

  @override
  Future<ToDoEntryModel> getToDoEntry(
      {required String collectionId, required String entryId}) {
    // TODO: implement getToDoEntry
    if (toDoEntries.containsKey(collectionId)) {
      final index =
          toDoEntries[collectionId]!.indexWhere((entry) => entry.id == entryId);
      if (index >= 0) {
        return Future.value(toDoEntries[collectionId]?[index]);
      } else {
        throw EntryNotFoundException(stackTrace: 'entry not found');
      }
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry(
      {required String collectionId, required ToDoEntryModel entryModel}) {
    // TODO: implement updateToDoEntry

    if (toDoEntries.containsKey(collectionId)) {
      final index = toDoEntries[collectionId]!.indexWhere(((entry) => entry.id == entryModel.id));
      if (index >= 0 ) {
        final toDoEntry = toDoEntries[collectionId]![index];
        final updateToDoEntry = toDoEntry.copyWith(isDone: !toDoEntry.isDone);
        toDoEntries[collectionId]![index] = updateToDoEntry;
        return Future.value(updateToDoEntry);
      } else {
        throw EntryNotFoundException(stackTrace: 'entry not found');
      }
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }



  @override
  Future<bool> modifyToDoEntry({required String collectionId, required ToDoEntryModel entryModel}) {
    // TODO: implement update2ToDoEntry
    if (toDoEntries.containsKey(collectionId)) {
      final index = toDoEntries[collectionId]!.indexWhere(((entry) => entry.id == entryModel.id));
      if (index >= 0 ) {
        final toDoEntry = toDoEntries[collectionId]![index];
        //  update the todoEntry model
        final updateToDoEntry = toDoEntry.copyWith(
            description: entryModel.description);
        // update the todoEntries repository
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
  Future<ToDoCollectionModel> getToDoCollection(
      {required String collectionId}) {
    final index = toDoCollections
        .indexWhere((collection) => collection.id == collectionId);
    if (index > 0) {
      return Future.value(toDoCollections[index]);
    } else {
      throw CollectionNotFoundException(stackTrace: 'collection not found');
    }
  }
}
