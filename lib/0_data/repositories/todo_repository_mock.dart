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

  /*
  final List<ToDoEntry> toDoEntries = List.generate(
    entriesNumber,
    (index) => ToDoEntry(
      id: EntryId.fromUniqueString(index.toString()),
      description: 'description $index',
      isDone: false,
    ),
  );

   */

  final toDoCollections = List<ToDoCollection>.generate(
    collectionNumber,
    (index) => ToDoCollection(
      id: CollectionId.fromUniqueString(index.toString()),
      title: 'title $index',
      color: ToDoColor(
        colorIndex: index % ToDoColor.predefinedColors.length,
      ),
    ),
  );

  final Map<CollectionId, List<ToDoEntry>> toDoEntries1 = generateToDoEntries();

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
      final  ToDoEntry  selectedEntryItem;
      if (toDoEntries1.containsKey(collectionId)) {
        final toDoEntries = toDoEntries1[collectionId];
        selectedEntryItem = toDoEntries!.firstWhere(
              (element) => element.id == entryId,
        );
      }  else {
        throw Exception('invalid collection id');
      }

      // ------------------------------------------------------
      //   change to 20 to test reload when item error
      //    and select collection id 2
      //  ----------------------------------------------------
      Random rand = Random();
      int r = rand.nextInt(10);
      if (['20','30'].contains(entryId.value)  &&  r.isEven) {
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

    /*
    final index =
        toDoEntries.indexWhere((element) => element.id == toDoEntry.id);
    final entryToUpdate = toDoEntries[index];
    final updatedEntry =
        toDoEntries[index].copyWith(isDone: !entryToUpdate.isDone);
    toDoEntries[index] = updatedEntry;
     */

    final index = toDoEntries1[collectionId]!
        .indexWhere((element) => element.id == toDoEntry.id);
    final entryToUpdate = toDoEntries1[collectionId]![index];
    final updatedEntry = entryToUpdate.copyWith(isDone: !entryToUpdate.isDone);
    toDoEntries1[collectionId]![index] = updatedEntry;
    return Future.delayed(
        const Duration(milliseconds: 100), () => Right(updatedEntry));

    // return Future.delayed(const Duration(milliseconds: 100), () => Left(ServerFailure()));
  }

  @override
  //! override readToDoEntryIds
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(
      CollectionId collectionId) {
    try {
      /*
      final startIndex = int.parse(collectionId.value) * collectionNumber;
      final endIndex = startIndex + entriesPerCollection;

      List<EntryId> entryIds = [];

      if (endIndex <= toDoEntries.length) {
        entryIds = toDoEntries
            .sublist(startIndex, endIndex)
            .map((entry) => entry.id)
            .toList();
      }

       */
      List<EntryId> entryIds = [];
      if (toDoEntries1.containsKey(collectionId)) {
        final toDoEntries = toDoEntries1[collectionId];
        int l = toDoEntries!.length;
        for (int i = 0; i < toDoEntries.length; i++) {
          entryIds.add(toDoEntries[i].id);
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

  /*
  @override
  Future<Either<Failure, bool>> createToDoEntry(_, ToDoEntry entry) {
    toDoEntries.add(entry);
    return Future.delayed(const Duration(milliseconds: 250), () => const Right(true));
  }
   */

  @override
  Future<Either<Failure, CollectionId>> createToDoCollection(
      ToDoCollection todoCollection) {
    /*
    CollectionId addCollection(ToDoCollection toDoCollection) {
      final index = toDoCollections.length;
      final collectionId = CollectionId.fromUniqueString(index.toString());

      toDoCollections.add(todoCollection.copyWithId(
          id: collectionId,
          title: '${toDoCollection.title} ${collectionId.value}'));

      */
    CollectionId addCollection(ToDoCollection toDoCollection) {
      final index = toDoEntries1.length;
      final collectionId = CollectionId.fromUniqueString(index.toString());
      final List<ToDoEntry> todoEntries = [];
      toDoEntries1[collectionId] = todoEntries;
      toDoCollections.add(todoCollection.copyWithId(
          id: collectionId,
          title: '${toDoCollection.title} ${collectionId.value}'));
      return collectionId;
    }

    try {
      final collectionId = addCollection(todoCollection);
      return Future.delayed(
          Duration(milliseconds: 200), () => Right(collectionId)
          //  () => Left(ServerFailure())
          );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, EntryId>> createToDoEntry(
      {required CollectionId collectionId, required ToDoEntry toDoEntry}) {
    //   add  an ToDoEntry
    EntryId addEntry(ToDoEntry toDoEntry) {
      if (toDoEntries1.containsKey(collectionId)) {
        int ? index = int.tryParse(toDoEntries1[collectionId]!.last.id.value);
        if (index is int) {
          index += 1;
        }  else {
          throw (Exception('Invalid entry id'));
        }
        final entryId = EntryId.fromUniqueString(index.toString());
        toDoEntries1[collectionId]!.add(toDoEntry.copyWithId(
            id: entryId,
            description: '${toDoEntry.description} ${entryId.value}'));
        return entryId;
      } else {
        throw (Exception('Invalid collection Id'));
      }
    }

    try {
      final entryId = addEntry(toDoEntry);
      return Future.delayed(Duration(milliseconds: 200), () => Right(entryId)
          //  () => Left(ServerFailure())
          );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  static Map<CollectionId, List<ToDoEntry>> generateToDoEntries() {
    final List<ToDoEntry> toDoEntries = List.generate(
      entriesNumber,
      (index) => ToDoEntry(
        id: EntryId.fromUniqueString(index.toString()),
        description: 'description $index',
        isDone: false,
      ),
    );

    final toDoCollections = List<ToDoCollection>.generate(
      collectionNumber,
      (index) => ToDoCollection(
        id: CollectionId.fromUniqueString(index.toString()),
        title: 'title $index',
        color: ToDoColor(
          colorIndex: index % ToDoColor.predefinedColors.length,
        ),
      ),
    );

    int start = 0;
    final Map<CollectionId, List<ToDoEntry>> map = Map();
    for (int i = 0; i < toDoCollections.length; i++) {
      map[toDoCollections[i].id] = toDoEntries.sublist(start, start + 10);
      start = start + 10;
    }
    return map;
  }
}
