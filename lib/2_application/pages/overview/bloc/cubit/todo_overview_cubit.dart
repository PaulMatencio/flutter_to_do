import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/delete_todo_collection.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/core/use_case.dart';

part 'todo_overview_cubit_state.dart';

const generalFailureMessage = 'Ups,something went wrong. Please try again';
const serverFailureMessage = 'Ups, Api error';
const cacheFailureMessage = 'Ups, cache failed . Please try again';
const dataExceptionMessage = ' Ups,bad json data';

class ToDoOverviewCubit extends Cubit<ToDoOverviewCubitState> {
  ToDoOverviewCubit({
    required this.loadToDoCollections,
    required this.deleteToDoCollection,
    ToDoOverviewCubitState? initialState,
  }) : super(initialState ?? ToDoOverviewCubitLoadingState());

  final LoadToDoCollections loadToDoCollections;
  final DeleteToDoCollection deleteToDoCollection;

  //!
  //!   readToDoCollections  use_Case/loadTodoCollections
  //!

  Future<void> readToDoCollections() async {
    emit(ToDoOverviewCubitLoadingState());
    try {
      final collectionsFuture = loadToDoCollections.call(NoParams());
      final collections = await collectionsFuture;
      collections.fold((failure) => emit(ToDoOverviewCubitErrorState(message: _mapFailureToMessage(failure))),
          (collections) => emit(ToDoOverviewCubitLoadedState(collections: collections)));
    } on Exception catch (e) {
      emit(ToDoOverviewCubitErrorState(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteCollection({required CollectionId collectionId}) async {
    try {
      final collectionsFuture = deleteToDoCollection.call(CollectionIdParam(collectionId: collectionId));
      final collections = await collectionsFuture;
      collections.fold((failure) => throw GeneralFailure(stackTrace: _mapFailureToMessage(failure)), (right) => true);
    } on Exception catch (e) {
      return Left(GeneralFailure(stackTrace: e.toString()));
    }
    return Left(GeneralFailure(stackTrace: 'delete failed. entries must be checked beforehand'));
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final ServerFailure e:
      String? message = (e.stackTrace == null) ? serverFailureMessage : e.stackTrace;
      return (message ?? serverFailureMessage);
    case final CacheFailure _:
      return cacheFailureMessage;
    default:
      return generalFailureMessage;
  }
}
