import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/0_data/data_sources/interfaces/todo_remote_data_source_interface.dart';
import 'package:todo_app/0_data/exceptions/firebase_firestore.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';


///
///  https://firebase.google.com/docs/firestore/manage-data/add-data
///
/// https://firebase.google.com/docs/firestore/query-data/get-data
///


///
///   collection(String(collectionPath)  ->  CollectionReference
///   Gets a CollectionReference instance that refers to the collection at the specified path.
///   The collectionPath parameter is a slash-separated path to a collection.
///
///   doc(String documentPath) → DocumentReference
///
///
class FireStoreRemoteDatasource implements ToDoRemoteDataSourceInterface {
  late FirebaseFirestore db;
  bool initialized = false;

  ///
  ///   initialize an instance of Cloud  FireStore
  Future<void> init() async {
    if (!initialized) {
      db = FirebaseFirestore.instance;
      initialized = true;
    }
  }

  @override
  Future<bool> createToDoCollection({
    required String userId,
    required ToDoCollectionModel collection,
  }) async {
    return db
        .collection(userId)
        .doc(collection.id)
        .set(collection.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }

  @override
  Future<bool> createToDoEntry(
      {required String userId,
      required String collectionId,
      required ToDoEntryModel entryModel}) {
    // TODO: implement createToDoEntry
    return db
        .collection(userId)
        .doc(collectionId)
        .collection('entries')
        .doc(entryModel.id)
        .set(entryModel.toJson())
        .then((value) => true)
        .catchError((error) => false);

  }

  @override
  Future<ToDoCollectionModel> getToDoCollection(
      {required String userId, required String collectionId}) async {
    final docSnapshot = await db.collection(userId).doc(collectionId).get();
    if (docSnapshot.exists || docSnapshot.data() != null) {
      return ToDoCollectionModel.fromJson(docSnapshot.data()!);
    } else {
      throw FireStoreCollectionNotFoundException(
          stackTrace: '$collectionId not found');
    }
    //  throw UnimplementedError();
  }

  @override
  Future<List<String>> getToDoCollectionIds({required String userId}) async {
    try {
      final querySnapshot = await db.collection(userId).get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } on Exception catch (e) {
      throw FirebaseFireStoreException(stackTrace: e.toString());
    }
  }

  @override
  Future<ToDoEntryModel> getToDoEntry(
      {required String userId,
      required String collectionId,
      required String entryId}) async {
    final docSnapshot = await db
        .collection(userId)
        .doc(collectionId)
        .collection('entries')
        .doc(entryId)
        .get();
    if (docSnapshot.exists || docSnapshot.data() != null) {
      return ToDoEntryModel.fromJson(docSnapshot.data()!);
    } else {
      throw FireStoreEntryNotFoundException(stackTrace: '$collectionId . $entryId} not found');
    }
  }

  @override
  Future<List<String>> getToDoEntryIds(
      {required String userId, required String collectionId}) async {
    try {
      final querySnapshot = await db
          .collection(userId)
          .doc(collectionId)
          .collection('entries')
          .get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } on Exception catch (e) {
      throw FirebaseFireStoreException(stackTrace: e.toString());
    }
  }

  @override
  Future<bool> deleteToDoCollection(
      {required String userId, required String collectionId}) async {
    try {
      await db.collection(userId).doc(collectionId).delete();
      return true;
    }  catch (e) {
      throw FirebaseFireStoreException(stackTrace: e.toString());
    }
  }


  //!  The problem  for deleteUserCollections(
  /// No Direct Delete: FireStore doesn't have a single command to delete an entire collection.
  /// You must delete each document within the collection individually.
  /// SubCollections: If your collection contains subCollections, you also need to recursively delete those as well.
  ///
  //! The Strategy
  ///
  /// 1) Query the Collection: Get all documents within the collection.
  /// 2) Delete Each Document: Iterate through the documents and delete them.
  /// 3) Recurse for SubCollections: For each document, check if it has subCollections.
  ///    A subCollection is  a map (cf.  entries) , iterate through the map and delete the items first
  ///    Then  call the same deletion function on those subCollection
  ///

  @override
  Future<bool> deleteUserCollections({required String userId})  async{
    debugPrint('deleting  $userId  collection');
    try{
      await deleteEverything(userId);
      return true;
    } on Exception catch (e) {
      throw FirebaseFireStoreException(stackTrace: e.toString());
    }
  }

  Future<void> deleteEverything(String startingCollection) async {
    await deleteCollection(startingCollection);
  }

  Future<void> deleteCollection(String collectionPath) async {
    QuerySnapshot collectionSnapshot = await db.collection(collectionPath).get();
    for (final doc in collectionSnapshot.docs) {
      final docRef  =  doc.reference;
     // debugPrint('id: ${docRef.id}  path:${docRef.path}');
      try {
        ///  delete  sub collections  recursively
        await deleteSubCollections(docRef);
        ///  delete the document  itself
        await docRef.delete();
      }  catch(e) {
        throw FirebaseFireStoreException(stackTrace: e.toString());
      }
      //debugPrint('Deleted document: ${doc.id} from $collectionPath');
    }
    //debugPrint('Deleted collection: $collectionPath');
  }
  Future<void> deleteSubCollections(DocumentReference docRef) async {
    final  collectionRef = docRef.collection('entries');
    QuerySnapshot subCollectionsSnapshot = await collectionRef.get();
    for (final subCollectionDoc in subCollectionsSnapshot.docs) {
     // debugPrint('delete document   ${docRef.path}/entries/${subCollectionDoc.id}');
      try {
       // await deleteCollection('${docRef.path}/entries/${subCollectionDoc.id}');
        await  subCollectionDoc.reference.delete();
      } catch (e) {
        //debugPrint(e.toString());
        throw FirebaseFireStoreException(stackTrace: e.toString());
      }
    }
    if (collectionRef.path.isNotEmpty) {
        //debugPrint('delete ${collectionRef.path}');
        await deleteCollection(collectionRef.path);
    }
  }



  @override
  Future<bool> deleteToDoEntry(
      {required String userId,
      required String collectionId,
      required String entryId}) async {
    // TODO: implement deleteToDoEntry
    try {
      await db
          .collection(userId)
          .doc(collectionId)
          .collection('entries')
          .doc(entryId)
          .delete();
      return true;
    } on Exception catch (e) {
      throw FirebaseFireStoreException(stackTrace: e.toString());
    }

    throw UnimplementedError();
  }

  @override
  Future<bool> modifyToDoEntry(
      {required String userId,
      required String collectionId,
      required ToDoEntryModel entryModel}) {
    return db
        .collection(userId)
        .doc(collectionId)
        .collection('entries')
        .doc(entryModel.id)
        .set(entryModel.toJson(),SetOptions(merge: true))
        .then((value) => true)
        .catchError((error) => false);
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry(
      {required String userId,
      required String collectionId,
      required String entryId}) async {

    // Read the document
    final docSnapshot = await db
        .collection(userId)
        .doc(collectionId)
        .collection('entries')
        .doc(entryId)
        .get();
    /// update tge document
    if (docSnapshot.exists || docSnapshot.data() != null) {
      final entry = ToDoEntryModel.fromJson(docSnapshot.data()!);
      final updatedEntry = ToDoEntryModel(
        id: entry.id,
        description: entry.description,
        isDone: !entry.isDone,
      );
      /// write the document
      await db
          .collection(userId)
          .doc(collectionId)
          .collection('entries')
          .doc(entryId)
          .set(updatedEntry.toJson())
          .then((value) => true)
          .catchError((error) =>
              throw FirebaseFireStoreException(stackTrace: error.toString()));
      return updatedEntry;
    } else {
      throw FireStoreEntryNotFoundException(stackTrace: '$entryId not found');
    }
  }

  @override
  Future<ToDoEntryModel> updateTodoEntry({
    required String userId,
    required String collectionId,
    required ToDoEntryModel entryModel,
  }) async {
    await db
        .collection(userId)
        .doc(collectionId)
        .collection('entries')
        .doc(entryModel.id)
        .set(entryModel.toJson(), SetOptions(merge: true))
    .then((value)=> true)
    .catchError((error)  =>
    throw FirebaseFireStoreException(stackTrace: error.toString()));
    return entryModel;
  }





}







