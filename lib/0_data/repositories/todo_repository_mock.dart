import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

final int collectionNumber = 10;
final int entriesPerCollection = 10;
final int entriesNumber = collectionNumber * entriesPerCollection;

class ToDoRepositoryMock implements ToDoRepository {
  final toDoCollections = generateToDoCollections();
  final Map<CollectionId, List<ToDoEntry>> toDoEntries = generateToDoEntries();

  @override
  //!    @override readToDoCollections()
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections() {
    try {
      return Future.delayed(
        const Duration(milliseconds: 200),
        () => Right(toDoCollections),
        // () => Left(ServerFailure())
      );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  //! @override readToDoEntry
  Future<Either<Failure, ToDoEntry>> readToDoEntry(
      CollectionId collectionId, EntryId entryId) {
    try {
      /*
      final selectedEntryItem = toDoEntries.firstWhere(
        (element) => element.id == entryId,
      );
      */
      final ToDoEntry selectedEntryItem;
      if (toDoEntries.containsKey(collectionId)) {
        final entries = toDoEntries[collectionId];
        selectedEntryItem = entries!.firstWhere(
          (element) => element.id == entryId,
        );
      } else {
         selectedEntryItem = ToDoEntry.empty();
      }

      // ------------------------------------------------------
      //   change to 20 to test reload when item error
      //    and select collection id 2
      //  ----------------------------------------------------
      Random rand = Random();
      int r = rand.nextInt(10);
      if (['20', '30'].contains(entryId.value) && r.isEven) {
        return Future.delayed(
            Duration(milliseconds: 300), () => Left(ServerFailure()));
      } else {
        return Future.delayed(
          const Duration(milliseconds: 200),
          () => Right(selectedEntryItem),
          // ()  => Left(ServerFailure()),
        );
      }
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateToDoEntry({
    required CollectionId collectionId,
    required ToDoEntry toDoEntry,
  }) {
    final index = toDoEntries[collectionId]!
        .indexWhere((element) => element.id == toDoEntry.id);
    final entryToUpdate = toDoEntries[collectionId]![index];
    final updatedEntry = entryToUpdate.copyWith(isDone: !entryToUpdate.isDone);
    toDoEntries[collectionId]![index] = updatedEntry;
    return Future.delayed(
        const Duration(milliseconds: 100), () => Right(updatedEntry));

    // return Future.delayed(const Duration(milliseconds: 100), () => Left(ServerFailure()));
  }

  @override
  Future<Either<Failure, bool>> deleteToDoEntry({required CollectionId collectionId, required EntryId entryId}) {
    // TODO: implement deleteToDoEntry
    throw UnimplementedError();
  }

  @override
  //! override readToDoEntryIds
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(
      CollectionId collectionId) {
    try {
      List<EntryId> entryIds = [];
      if (toDoEntries.containsKey(collectionId)) {
        final entries = toDoEntries[collectionId];
        for (int i = 0; i < (entries!.length); i++) {
          entryIds.add(entries[i].id);
        }
      } else {
        throw Exception('invalid collection id');
      }

      return Future.delayed(
        const Duration(milliseconds: 300),
        () => Right(entryIds),
        //  ()=> Left(ServerFailure())
      );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> createToDoCollection(
      ToDoCollection todoCollection) {
    bool addCollection(ToDoCollection toDoCollection) {
      final index = toDoCollections.length;
      final collectionId = CollectionId.fromUniqueString(index.toString());

      toDoEntries.putIfAbsent(collectionId, () => []);
      toDoCollections.add(todoCollection.copyWithId(
          id: collectionId, title: toDoCollection.title));
      print(' empty ....   ${toDoEntries[collectionId]}');
      return true;
    }

    try {
      final result = addCollection(todoCollection);
      return Future.delayed(Duration(milliseconds: 200), () => Right(result)
          //  () => Left(ServerFailure())
          );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> createToDoEntry(
      {required CollectionId collectionId, required ToDoEntry toDoEntry}) {
    //   add  an ToDoEntry

    bool addEntry(ToDoEntry toDoEntry) {
     // int index =  0;
      if (toDoEntries.containsKey(collectionId)) {
        /*
        if (toDoEntries[collectionId]!.isNotEmpty) {
          index  = int.tryParse(toDoEntries[collectionId]!.last.id.value)?? 0;
          index++;
        }
         */
       // final entryId = EntryId.fromUniqueString(index.toString());
        toDoEntries[collectionId]!.add(toDoEntry.copyWith(
           description: toDoEntry.description));
        return true;
      } else {
        throw (Exception('Invalid collection Id'));
      }
    }

    try {
      final result = addEntry(toDoEntry);
      return Future.delayed(Duration(milliseconds: 200), () => Right(result)
          //  () => Left(ServerFailure())
          );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  //
  //    generate TodoCollection
  //
  static List<ToDoCollection> generateToDoCollections() {
    return List<ToDoCollection>.generate(
      collectionNumber,
      (index) => ToDoCollection(
        id: CollectionId.fromUniqueString(index.toString()),
        title: 'title $index',
        color: ToDoColor(
          colorIndex: index % ToDoColor.predefinedColors.length,
        ),
      ),
    );
  }

//
//    generate initial toDoEntries
//

  static Map<CollectionId, List<ToDoEntry>> generateToDoEntries() {
    final List<ToDoEntry> toDoEntries = List.generate(
      entriesNumber,
      (index) => ToDoEntry(
        id: EntryId.fromUniqueString(index.toString()),
        description: 'description $index',
        isDone: false,
      ),
    );
    final toDoCollections = generateToDoCollections();
    int start = 0;
    final Map<CollectionId, List<ToDoEntry>> map = {};
    for (int i = 0; i < toDoCollections.length; i++) {
      map[toDoCollections[i].id] = toDoEntries.sublist(start, start + 10);
      start = start + 10;
    }
    return map;
  }
}
