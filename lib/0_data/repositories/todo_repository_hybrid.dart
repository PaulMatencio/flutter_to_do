import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/0_data/data_sources/interfaces/todo_local_data_source_interface.dart';
import 'package:todo_app/0_data/data_sources/interfaces/todo_remote_data_source_interface.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/exceptions/firebase_firestore.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/0_data/repositories/todo_repository_local.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_dashboard.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryHybrid implements ToDoRepository {
  // final localDataSource = MemoryLocalDataSource();

  ToDoRepositoryHybrid(
      {required this.remoteDataSource, required this.localDataSource});

  ///
  ///   localDataSource is
  ///   either MemoryLocalDataSource()
  ///   or HiveLocalDataSource()
  ///
  ToDoRemoteDataSourceInterface remoteDataSource;
  ToDoLocalDataSourceInterface localDataSource;
  //final  userId = '';
  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  ///
  ///
  ///  crate a todoCollection from a create_todo_collection form
  ///

  @override
  Future<Either<Failure, bool>> createToDoCollection(
      ToDoCollection todoCollection) async {
    final collectionModel = ToDoCollectionModel(
        colorIndex: todoCollection.color.colorIndex,
        title: todoCollection.title,
        id: todoCollection.id.value);
    if (isLoggedIn) {
      try {
        final result = await remoteDataSource.createToDoCollection(
            userId: userId!, collection: collectionModel);
        return Right(result);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final result = await localDataSource.createToDoCollection(
            collection: collectionModel);
        return Right(result);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    }
  }

  ///
  ///
  ///  Delete entryId  if it is checked ( isDone)
  ///  and return a list of deleted entryId
  ///  to be remove from the entryIds (state) of ToDoDetailCubitState
  ///
  ///
  @override
  Future<Either<Failure, List<EntryId>>> deleteToDoEntries(
      CollectionId collectionId) async {
    List<EntryId> listEntryId = [];
    if (isLoggedIn) {
      try {
        final collectionModelId = collectionId.value;
        await remoteDataSource
            .getToDoEntryIds(userId: userId!, collectionId: collectionModelId)
            .then((entryIds) async {
          for (int i = 0; i < entryIds.length; i++) {
            final entryId = entryIds[i];
            await remoteDataSource
                .getToDoEntry(
                    userId: userId!,
                    collectionId: collectionModelId,
                    entryId: entryId)
                .then((item) async {
              if (item.isDone) {
                await remoteDataSource.deleteToDoEntry(
                    userId: userId!,
                    collectionId: collectionId.value,
                    entryId: entryId);
              } else {
                listEntryId.add(EntryId.fromUniqueString(item.id));

                ///
              }
            });
          }
        });
        return Right(listEntryId);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CollectionNotEmptyException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    } else {
      try {
        final collectionModelId = collectionId.value;
        await localDataSource
            .getToDoEntryIds(collectionId: collectionModelId)
            .then((entryIds) async {
          for (int i = 0; i < entryIds.length; i++) {
            final entryId = entryIds[i];
            await localDataSource
                .getToDoEntry(collectionId: collectionModelId, entryId: entryId)
                .then((item) async {
              if (item.isDone) {
                await localDataSource.deleteToDoEntry(
                    collectionId: collectionId.value, entryId: entryId);
              } else {
                listEntryId.add(EntryId.fromUniqueString(item.id));
              }
            });
          }
        });
        return Right(listEntryId);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CollectionNotEmptyException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    }
  }

  ///
  ///     delete a collection if all its entries are checked
  ///     otherwise return a failure
  ///
  ///
  @override
  Future<Either<Failure, bool>> deleteToDoCollection(
      CollectionId collectionId) async {
    if (isLoggedIn) {
      try {
        await deleteToDoEntries(collectionId).then((value) async {
          if (value.isRight) {
            if (value.right.isEmpty) {
              await remoteDataSource.deleteToDoCollection(
                  userId: userId!, collectionId: collectionId.value);
            } else {
              throw Exception('Collection is not empty');
            }
          }
        });
        //  await localDataSource.deleteToDoCollection(collectionId: collectionId.value);
        return Right(true);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CollectionNotEmptyException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    } else {
      //return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        await deleteToDoEntries(collectionId).then((value) async {
          if (value.isRight) {
            if (value.right.isEmpty) {
              await localDataSource.deleteToDoCollection(
                  collectionId: collectionId.value);
            } else {
              throw Exception('Collection is not empty');
            }
          }
        });
        //  await localDataSource.deleteToDoCollection(collectionId: collectionId.value);
        return Right(true);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CollectionNotEmptyException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    }
  }



  @override
  Future<Either<Failure, bool>> deleteUserCollections() async {
    if (isLoggedIn) {
      try {
        return await remoteDataSource.deleteUserCollections(userId: userId!).then((result)=> Right(result));

      } on Exception catch (e) {
        switch (e) {
          case final FirebaseFireStoreException  e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
      }
    }  else {
      return Left(GeneralFailure(stackTrace: 'User is not logged in'));
    }
  }


  ///
  ///   createToDoEntry
  ///   create an entry  for a  create_todo_entry form
  ///
  ///
  @override
  Future<Either<Failure, bool>> createToDoEntry(
      {required CollectionId collectionId,
      required ToDoEntry toDoEntry}) async {
    final entryModel = ToDoEntryModel(
        id: toDoEntry.id.value,
        description: toDoEntry.description,
        isDone: toDoEntry.isDone);
    if (isLoggedIn) {
      try {
        final result = await remoteDataSource.createToDoEntry(
            userId: userId!,
            collectionId: collectionId.value,
            entryModel: entryModel);
        return Right(result);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    } else {
      //  return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final result = await localDataSource.createToDoEntry(
            collectionId: collectionId.value, entryModel: entryModel);
        return Right(result);
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    }
  }

  ///
  ///   readToDoCollections
  ///   read a list of all collections
  ///
  @override
  Future<Either<Failure, List<ToDoCollection>>> readToDoCollections() async {
    print('is logged in? $isLoggedIn');
    if (isLoggedIn) {
      try {
        final collectionIds =
            await remoteDataSource.getToDoCollectionIds(userId: userId!);
        final List<ToDoCollection> collections = [];
        for (String collectionId in collectionIds) {
          final collection = await remoteDataSource.getToDoCollection(
              userId: userId!, collectionId: collectionId);
          collections.add(toDoCollectionModelToEntity(collection));
        }
        return Right(collections);
      } on Exception catch (e) {
        switch (e) {
          case final FirebaseFireStoreException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(ServerFailure(stackTrace: e.toString()));
        }
        // return Future.value(Left(ServerFailure(stackTrace: e.toString())));
      }
    } else {
      //  return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final collectionIds = await localDataSource.getToDoCollectionIds();
        final List<ToDoCollection> collections = [];
        for (String collectionId in collectionIds) {
          final collection = await localDataSource.getToDoCollection(
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
  }

  ///
  ///   readToDoEntryIds
  ///   Read a list of entries for a given collection id
  ///
  @override
  Future<Either<Failure, List<EntryId>>> readToDoEntryIds(
      CollectionId collectionId) async {
    if (isLoggedIn) {
      try {
        final result = await remoteDataSource.getToDoEntryIds(
            userId: userId!, collectionId: collectionId.value);
        final toDoEntries =
            result.map((item) => EntryId.fromUniqueString(item)).toList();
        return Right(toDoEntries);
      } on Exception catch (e) {
        switch (e) {
          case final ServerException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException _:
            return Left(CacheFailure());
          default:
            return Left(GeneralFailure());
        }
      }
    } else {
      //  return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final result = await localDataSource.getToDoEntryIds(
            collectionId: collectionId.value);
        final toDoEntries =
            result.map((item) => EntryId.fromUniqueString(item)).toList();
        return Right(toDoEntries);
      } on Exception catch (e) {
        switch (e) {
          case final ServerException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
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
  ///    readToDoEntry
  ///    read an entry for a given  entry id
  ///
  @override
  Future<Either<Failure, ToDoEntry>> readToDoEntry(
      CollectionId collectionId, EntryId entryId) async {
    if (isLoggedIn) {
      try {
        final result = await remoteDataSource.getToDoEntry(
            userId: userId!,
            collectionId: collectionId.value,
            entryId: entryId.value);

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
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure());
        }
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final result = await localDataSource.getToDoEntry(
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
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure());
        }
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
    if (isLoggedIn) {
      try {
        final entry = await remoteDataSource.updateToDoEntry(
            userId: userId!,
            collectionId: collectionId.value,
            entryId: entryId.value);

        return Right(toDoEntryModelToEntity(entry));
      } on CacheException catch (e) {
        return Future.value(Left(CacheFailure(stackTrace: e.stackTrace)));
      } on Exception catch (e) {
        return Future.value(Left(ServerFailure(stackTrace: e.toString())));
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final entry = await localDataSource.updateToDoEntry(
            collectionId: collectionId.value, entryId: entryId.value);

        return Right(toDoEntryModelToEntity(entry));
      } on CacheException catch (e) {
        return Future.value(Left(CacheFailure(stackTrace: e.stackTrace)));
      } on Exception catch (e) {
        return Future.value(Left(ServerFailure(stackTrace: e.toString())));
      }
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateTodoEntry(
      {required CollectionId collectionId,
      required ToDoEntry todoEntry}) async {
    final entryModel = toDoEntryToModel(todoEntry);
    if (isLoggedIn) {
      try {
        final entry = await remoteDataSource.updateTodoEntry(
            userId: userId!,
            collectionId: collectionId.value,
            entryModel: entryModel);

        return Right(toDoEntryModelToEntity(entry));
      } on CacheException catch (e) {
        return Future.value(Left(CacheFailure(stackTrace: e.stackTrace)));
      } on Exception catch (e) {
        return Future.value(Left(ServerFailure(stackTrace: e.toString())));
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final entry = await localDataSource.updateTodoEntry(
            collectionId: collectionId.value, entryModel: entryModel);
        return Right(toDoEntryModelToEntity(entry));
      } on CacheException catch (e) {
        return Future.value(Left(CacheFailure(stackTrace: e.stackTrace)));
      } on Exception catch (e) {
        return Future.value(Left(ServerFailure(stackTrace: e.toString())));
      }
    }
  }

  ///
  ///    modifyToDoEntry
  ///    modify an entry  for  a given entry id
  ///

  @override
  Future<Either<Failure, bool>> modifyToDoEntry(
      {required CollectionId collectionId,
      required ToDoEntry toDoEntry}) async {
    final entryModel = toDoEntryToModel(toDoEntry);
    if (isLoggedIn) {
      try {
        final result = await remoteDataSource.modifyToDoEntry(
            userId: userId!,
            collectionId: collectionId.value,
            entryModel: entryModel);
        return Right(result);
      } on Exception catch (e) {
        switch (e) {
          case final ServerException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        final result = await localDataSource.modifyToDoEntry(
            collectionId: collectionId.value, entryModel: entryModel);
        return Right(result);
      } on Exception catch (e) {
        switch (e) {
          case final ServerException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    }
  }

  ///
  ///    deleteToDoEntry
  ///    delete en entry   for a given entry id
  ///
  ///
  @override
  Future<Either<Failure, bool>> deleteToDoEntry(
      {required CollectionId collectionId, required EntryId entryId}) async {
    if (isLoggedIn) {
      try {
        await remoteDataSource.deleteToDoEntry(
            userId: userId!,
            collectionId: collectionId.value,
            entryId: entryId.value);
        return (Right(true));
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        await localDataSource.deleteToDoEntry(
            collectionId: collectionId.value, entryId: entryId.value);
        return (Right(true));
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    }
  }

  @override
  Future<Either<Failure, ToDoDashboard>> createToDoDashboard() async {
    List<Collection> collections = [];
    int areDone = 0;
    int areNotDone = 0;
    if (isLoggedIn) {
      try {
        await remoteDataSource
            .getToDoCollectionIds(userId: userId!)
            .then((collectionIds) async {
          for (int i = 0; i < collectionIds.length; i++) {
            final collectionId = collectionIds[i];
            await remoteDataSource
                .getToDoCollection(userId: userId!, collectionId: collectionId)
                .then((collection) async {
              int isDone = 0;
              int isNotDone = 0;
              await remoteDataSource
                  .getToDoEntryIds(userId: userId!, collectionId: collectionId)
                  .then((entryIds) async {
                for (int j = 0; j < entryIds.length; j++) {
                  final entryId = entryIds[j];
                  await remoteDataSource
                      .getToDoEntry(
                          userId: userId!,
                          collectionId: collectionId,
                          entryId: entryId)
                      .then((entry) async {
                    if (entry.isDone) {
                      isDone++;
                      areDone++;
                    } else {
                      isNotDone++;
                      areNotDone++;
                    }
                  });
                }
                collections.add(Collection(
                    title: collection.title,
                    colorIndex: collection.colorIndex,
                    isDone: isDone,
                    isNotDone: isNotDone));
              });
            });
          }
        });
        return Right(ToDoDashboard(
            collections: collections,
            areDone: areDone,
            areNotDone: areNotDone));
      } on Exception catch (e) {
        switch (e) {
          case final FirebaseFireStoreException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
          case final CollectionNotFoundException e:
            return Left(ServerFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    } else {
      // return Left(GeneralFailure(stackTrace: 'please login first'));
      try {
        await localDataSource
            .getToDoCollectionIds()
            .then((collectionIds) async {
          for (int i = 0; i < collectionIds.length; i++) {
            final collectionId = collectionIds[i];
            await localDataSource
                .getToDoCollection(collectionId: collectionId)
                .then((collection) async {
              int isDone = 0;
              int isNotDone = 0;
              await localDataSource
                  .getToDoEntryIds(collectionId: collectionId)
                  .then((entryIds) async {
                for (int j = 0; j < entryIds.length; j++) {
                  final entryId = entryIds[j];
                  await localDataSource
                      .getToDoEntry(
                          collectionId: collectionId, entryId: entryId)
                      .then((entry) async {
                    if (entry.isDone) {
                      isDone++;
                      areDone++;
                    } else {
                      isNotDone++;
                      areNotDone++;
                    }
                  });
                }
                collections.add(Collection(
                    title: collection.title,
                    colorIndex: collection.colorIndex,
                    isDone: isDone,
                    isNotDone: isNotDone));
              });
            });
          }
        });
        return Right(ToDoDashboard(
            collections: collections,
            areDone: areDone,
            areNotDone: areNotDone));
      } on Exception catch (e) {
        switch (e) {
          case final CollectionNotFoundException e:
            return Left(GeneralFailure(stackTrace: e.stackTrace));
          case final CacheException e:
            return Left(CacheFailure(stackTrace: e.stackTrace));
          default:
            return Left(GeneralFailure(stackTrace: e.toString()));
        }
      }
    }
  }
}
