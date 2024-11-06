import 'package:either_dart/either.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/data_sources/local/memory_local_data_source.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryLocal implements ToDoRepository {
  final toDoRepositoryLocal = MemoryLocalDataSource();
  @override
  Future<Either<Failure, bool>> createToDoCollection(
      ToDoCollection todoCollection) async {
    final collectionModel = ToDoCollectionModel(
        colorIndex: todoCollection.color.colorIndex,
        title: todoCollection.title,
        id: todoCollection.id.value);
    try {
      final result = await toDoRepositoryLocal.createToDoCollection(
          collection: collectionModel);
      return Right(result);
    } on Exception catch (e) {
      switch (e) {
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.toString()));
        case final CacheException e:
          return Left(CacheFailure(stackTrace: e.toString()));
        default:
          return Left(ServerFailure(stackTrace: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createToDoEntry(
      {required CollectionId collectionId,
      required ToDoEntry toDoEntry}) async {
    final entryModel = ToDoEntryModel(
        id: toDoEntry.id.value,
        description: toDoEntry.description,
        isDone: toDoEntry.isDone);
    try {
      final result = await toDoRepositoryLocal.createToDoEntry(
          collectionId: collectionId.value, entryModel: entryModel);
      return Right(result);
    } on Exception catch (e) {
      switch (e) {
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.toString()));
        case final CacheException e:
          return Left(CacheFailure(stackTrace: e.toString()));
        default:
          return Left(GeneralFailure(stackTrace: e.toString()));
      }
    }

    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteToDoEntry(
      {required CollectionId collectionId, required EntryId entryId}) async {
    try {
      await toDoRepositoryLocal.deleteToDoEntry(
          collectionId: collectionId.value, entryModelId: entryId.value);
      return (Right(true));
    } on Exception catch (e) {
      switch (e) {
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.toString()));
        case final CacheException e:
          return Left(CacheFailure(stackTrace: e.toString()));
        default:
          return Left(GeneralFailure(stackTrace: e.toString()));
      }
    }
  }


  /*
  @override
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections() async {
    try {
     //final List<ToDoCollection> todoCollections = [];
      final result = await toDoRepositoryLocal.getToDoCollections();
      final todoCollections = result
          .map((item) => ToDoCollection(
          id: CollectionId.fromUniqueString(item.id),
          title: item.title,
          color: ToDoColor(colorIndex: item.colorIndex)))
          .toList();

      return Right(todoCollections);
    } on Exception catch (_) {
      return Left(ServerFailure());
   }
  }

   */



 @override
 Future<Either<Failure, List<ToDoCollection>>> readToDoCollections() async {try {
    final collectionIds = await toDoRepositoryLocal.getToDoCollectionIds();
    print(collectionIds.length);
      final List<ToDoCollection> collections = [];
      for (String collectionId in collectionIds) {
        final collection = await toDoRepositoryLocal.getToDoCollection(
            collectionId: collectionId);
        collections.add(toDoCollectionModelToEntity(collection));
      }
      return Right(collections);
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }



  @override
  Future<Either<Failure, ToDoEntry>> readToDoEntry(
      CollectionId collectionId, EntryId entryId) async {
    try {
      final result = await toDoRepositoryLocal.getToDoEntry(
          collectionId: collectionId.value, entryId: entryId.value);

      return Right(ToDoEntry(
          id: EntryId.fromUniqueString(result.id),
          description: result.description,
          isDone: result.isDone));
    } on Exception catch (e) {
      switch (e) {
        case final ServerException _:
          return Left(ServerFailure());
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.stackTrace));
        case final EntryNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.stackTrace));
        case final CacheException _:
          return Left(CacheFailure());
        default:
          return Left(GeneralFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateToDoEntry(
      {required CollectionId collectionId, required EntryId entryId}) async {
    try {
      final entry = await toDoRepositoryLocal.updateToDoEntry(collectionId: collectionId.value, entryId: entryId.value);

      return Right(toDoEntryModelToEntity(entry));
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> modifyToDoEntry(
      {required CollectionId collectionId,
      required ToDoEntry toDoEntry}) async {
    /// final entryModel = ToDoEntryModel(

    ///   final entryModel = ToDoEntryModel(
    ///     id: toDoEntry.id.value,
    ///     description: toDoEntry.description,
    ///     isDone: toDoEntry.isDone
    ///    );
    ///
    final entryModel = toDoEntryToModel(toDoEntry);
    try {
      final result = await toDoRepositoryLocal.modifyToDoEntry(
          collectionId: collectionId.value, entryModel: entryModel);
      return Right(result);
    } on Exception catch (e) {
      switch (e) {
        case final ServerException e:
          return Left(ServerFailure(stackTrace: e.toString()));
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.toString()));
        case final CacheException e:
          return Left(CacheFailure(stackTrace: e.toString()));
        default:
          return Left(GeneralFailure(stackTrace: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(
      CollectionId collectionId) async {
    try {
      final result = await toDoRepositoryLocal.getToDoEntryIds(
          collectionId: collectionId.value);
      final toDoEntries =
          result.map((item) => EntryId.fromUniqueString(item)).toList();
      return Right(toDoEntries);
    } on Exception catch (e) {
      switch (e) {
        case final ServerException e:
          return Left(ServerFailure(stackTrace: e.toString()));
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.stackTrace));
        case final CacheException _:
          return Left(CacheFailure());
        default:
          return Left(GeneralFailure());
      }
    }
  }
}

///
///     EntryModel -> EntryEntity
///
ToDoEntry toDoEntryModelToEntity(ToDoEntryModel model) {
  final entity = ToDoEntry(
    id: EntryId.fromUniqueString(model.id),
    description: model.description,
    isDone: model.isDone,
  );

  return entity;
}

///
///  Collection Model -> Collection Entity

ToDoCollection toDoCollectionModelToEntity(ToDoCollectionModel model) {
  final entity = ToDoCollection(
    id: CollectionId.fromUniqueString(model.id),
    title: model.title,
    color: ToDoColor(colorIndex: model.colorIndex),
  );

  return entity;
}

ToDoEntryModel toDoEntryToModel(ToDoEntry entry) {
  final model = ToDoEntryModel(
    id: entry.id.value,
    description: entry.description,
    isDone: entry.isDone,
  );

  return model;
}

ToDoCollectionModel toDoCollectionToModel(ToDoCollection collection) {
  final model = ToDoCollectionModel(
    id: collection.id.value,
    title: collection.title,
    colorIndex: collection.color.colorIndex,
  );

  return model;
}
