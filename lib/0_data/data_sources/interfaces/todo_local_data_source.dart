import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';

abstract class ToDoLocalDataSource {

  Future<ToDoEntryModel> getToDoEntry(
      {required String collectionId, required String entryId});

  Future<ToDoCollectionModel> getToDoCollection({required String collectionId});


  Future<List<String>> getToDoEntryIds({required String collectionId});


  Future<List<String>> getToDoCollectionIds();

  Future<ToDoEntryModel> updateToDoEntry(
      { required String toDoCollectionId,
        required ToDoEntryModel todoEntryModel});

  Future<bool> createToDoEntry({
    required String collectionId,
    required ToDoEntryModel entry});

  Future<bool> createToDoCollection(
      {required ToDoCollectionModel collection});
}
