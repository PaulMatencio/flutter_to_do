import 'package:either_dart/either.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
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
      final selectedEntryItem = toDoEntries.firstWhere(
        (element) => element.id == entryId,
      );

      return Future.delayed(
        const Duration(milliseconds: 200),
        () => Right(selectedEntryItem),
        //  ()  => Left(ServerFailure()),
      );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateToDoEntry({
    required CollectionId collectionId,
    required ToDoEntry toDoEntry,
  }) {
    final index =
        toDoEntries.indexWhere((element) => element.id == toDoEntry.id);
    final entryToUpdate = toDoEntries[index];
    final updatedEntry =
        toDoEntries[index].copyWith(isDone: !entryToUpdate.isDone);
    toDoEntries[index] = updatedEntry;

    return Future.delayed(
        const Duration(milliseconds: 100), () => Right(updatedEntry));
    // return Future.delayed(const Duration(milliseconds: 100), () => Left(ServerFailure()));
  }

  @override
  //! override readToDoEntryIds
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(
      CollectionId collectionId) {
    try {
      final startIndex = int.parse(collectionId.value) * collectionNumber;
      final endIndex = startIndex + entriesPerCollection;
      final entryIds = toDoEntries
          .sublist(startIndex, endIndex)
          .map((entry) => entry.id)
          .toList();
      return Future.delayed(
          const Duration(milliseconds: 300),
          () => Right(entryIds),
          //  ()=> Left(ServerFailure())
      );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }
}
