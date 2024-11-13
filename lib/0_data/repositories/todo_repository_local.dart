import 'package:either_dart/either.dart';
import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source_interface.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryLocal implements ToDoRepository {
  // final localDataSource = MemoryLocalDataSource();

  ToDoRepositoryLocal({required this.localDataSource});

  ///
  ///   localDataSource is
  ///   either MemoryLocalDataSource()
  ///   or HiveLocalDataSource()
  ///
  ToDoLocalDataSourceInterface localDataSource;

  ///
  ///
  ///  crate a todoCollection for a create_todo_collection form
  ///

  @override
  Future<Either<Failure, bool>> createToDoCollection(ToDoCollection todoCollection) async {
    final collectionModel = ToDoCollectionModel(
        colorIndex: todoCollection.color.colorIndex, title: todoCollection.title, id: todoCollection.id.value);
    try {
      final result = await localDataSource.createToDoCollection(collection: collectionModel);
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
  Future<Either<Failure, bool>> deleteToDoCollection(CollectionId collectionId) async {
    // TODO: implement deleteToDoCollection
    try {
      final collectionModelId = collectionId.value;
      await localDataSource.getToDoEntryIds(collectionId: collectionModelId).then((entryIds) async {
        for (int i = 0; i < entryIds.length; i++) {
          final entryId = entryIds[i];
          await localDataSource.getToDoEntry(collectionId: collectionModelId, entryId: entryId).then((item) {
            ///delete entry which are done
            if (item.isDone) {
              localDataSource.deleteToDoEntry(collectionId: collectionId.value, entryId: entryId);
            }
          });
        }

        /// delete the collection
      }).then((_) => localDataSource.deleteToDoCollection(collectionId: collectionId.value));

      return Right(true);
    } on Exception catch (e) {
      switch (e) {
        case final CollectionNotFoundException e:
          return Left(GeneralFailure(stackTrace: e.toString()));
        case final CollectionNotEmptyException e:
          return Left(GeneralFailure(stackTrace: e.toString()));
        case final CacheException e:
          return Left(CacheFailure(stackTrace: e.toString()));
        default:
          return Left(ServerFailure(stackTrace: e.toString()));
      }
    }
  }

  ///
  ///   createToDoEntry
  ///   create an entry  for a  create_todo_entry form
  ///
  ///
  @override
  Future<Either<Failure, bool>> createToDoEntry(
      {required CollectionId collectionId, required ToDoEntry toDoEntry}) async {
    final entryModel =
        ToDoEntryModel(id: toDoEntry.id.value, description: toDoEntry.description, isDone: toDoEntry.isDone);
    try {
      final result = await localDataSource.createToDoEntry(collectionId: collectionId.value, entryModel: entryModel);
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

  ///
  ///   readToDoCollections
  ///   read a list of all collections
  ///
  @override
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections() async {
    try {
      print('Read todo collection has been called ');
      final collectionIds = await localDataSource.getToDoCollectionIds();
      final List<ToDoCollection> collections = [];
      for (String collectionId in collectionIds) {
        final collection = await localDataSource.getToDoCollection(collectionId: collectionId);
        collections.add(toDoCollectionModelToEntity(collection));
      }
      return Right(collections);
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  ///
  ///   readToDoEntryIds
  ///   Read a list of entries for a given collection id
  ///
  @override
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(CollectionId collectionId) async {
    try {
      final result = await localDataSource.getToDoEntryIds(collectionId: collectionId.value);
      final toDoEntries = result.map((item) => EntryId.fromUniqueString(item)).toList();
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

  ///
  ///    readToDoEntry
  ///    read an entry for a given  entry id
  ///
  @override
  Future<Either<Failure, ToDoEntry>> readToDoEntry(CollectionId collectionId, EntryId entryId) async {
    try {
      final result = await localDataSource.getToDoEntry(collectionId: collectionId.value, entryId: entryId.value);

      return Right(
          ToDoEntry(id: EntryId.fromUniqueString(result.id), description: result.description, isDone: result.isDone));
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

  ///
  ///   updateToDoEntry
  ///   update an entry status for a given entry id
  ///
  @override
  Future<Either<Failure, ToDoEntry>> updateToDoEntry(
      {required CollectionId collectionId, required EntryId entryId}) async {
    try {
      final entry = await localDataSource.updateToDoEntry(collectionId: collectionId.value, entryId: entryId.value);

      return Right(toDoEntryModelToEntity(entry));
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  ///
  ///    modifyToDoEntry
  ///    modify an entry  for  a given entry id
  ///

  @override
  Future<Either<Failure, bool>> modifyToDoEntry(
      {required CollectionId collectionId, required ToDoEntry toDoEntry}) async {
    final entryModel = toDoEntryToModel(toDoEntry);

    try {
      final result = await localDataSource.modifyToDoEntry(collectionId: collectionId.value, entryModel: entryModel);
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

  ///
  ///    deleteToDoEntry
  ///    delete en entry   for a given entry id
  ///
  ///
  @override
  Future<Either<Failure, bool>> deleteToDoEntry({required CollectionId collectionId, required EntryId entryId}) async {
    try {
      await localDataSource.deleteToDoEntry(collectionId: collectionId.value, entryId: entryId.value);
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
}

///
///     todo Entry Model -> todo Entry Entity
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
///  todo Collection Model -> todo Collection Entity
///

ToDoCollection toDoCollectionModelToEntity(ToDoCollectionModel model) {
  final entity = ToDoCollection(
    id: CollectionId.fromUniqueString(model.id),
    title: model.title,
    color: ToDoColor(colorIndex: model.colorIndex),
  );
  return entity;
}

///
///   Todo entry  Entity -> todo entry model
///
ToDoEntryModel toDoEntryToModel(ToDoEntry entry) {
  final model = ToDoEntryModel(
    id: entry.id.value,
    description: entry.description,
    isDone: entry.isDone,
  );
  return model;
}

///
///     todo collection entity  ->  todo collection model
///

ToDoCollectionModel toDoCollectionToModel(ToDoCollection collection) {
  final model = ToDoCollectionModel(
    id: collection.id.value,
    title: collection.title,
    colorIndex: collection.color.colorIndex,
  );
  return model;
}
