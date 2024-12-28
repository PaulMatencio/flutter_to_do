import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';

abstract class ToDoLocalDataSourceInterface {
  Future<ToDoEntryModel> getToDoEntry({required String collectionId, required String entryId});

  Future<ToDoCollectionModel> getToDoCollection({required String collectionId});

  Future<List<String>> getToDoEntryIds({required String collectionId});

  Future<List<String>> getToDoCollectionIds();

  /*   todo merge updateTodoEntry and modifyToDoEntry */
  Future<ToDoEntryModel> updateToDoEntry({required String collectionId, required String entryId});
  Future<ToDoEntryModel> updateTodoEntry({required String collectionId, required ToDoEntryModel  entryModel});
  Future<bool> modifyToDoEntry({required String collectionId, required ToDoEntryModel entryModel});

  Future<bool> createToDoEntry({required String collectionId, required ToDoEntryModel entryModel});

  Future<bool> deleteToDoEntry({required String collectionId, required String entryId});

  Future<bool> createToDoCollection({required ToDoCollectionModel collection});

  Future<bool> deleteToDoCollection({required String collectionId});
}
