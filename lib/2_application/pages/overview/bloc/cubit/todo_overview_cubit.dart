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

  ///
  ///
  /// readToDoCollections  use_Case/loadTodoCollections
  ///

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

  Future<bool> deleteCollection({required CollectionId collectionId}) async {
    try {
      final result = await deleteToDoCollection.call(CollectionIdParam(collectionId: collectionId));
      if (result.isRight) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      emit(ToDoOverviewCubitErrorState(message: e.toString()));
      return false;
    }
  }

  ///
  ///    Remove a given  entryId from the current entryId list
  ///
  Future<void> removeCollection(CollectionId collectionId) async {
    try {
      if (state is ToDoOverviewCubitLoadedState) {
        (state as ToDoOverviewCubitLoadedState).collections.removeWhere((elem) => elem.id == collectionId);
        emit(ToDoOverviewCubitDeletedState(collectionId: collectionId));
      }
    } on Exception catch (e) {
      emit(ToDoOverviewCubitErrorState(message: e.toString()));
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final ServerFailure e:
      return (e.stackTrace ?? serverFailureMessage);
    case final CacheFailure _:
      return cacheFailureMessage;
    case final GeneralFailure e:
      return e.stackTrace ?? generalFailureMessage;
    default:
      return generalFailureMessage;
  }
}
