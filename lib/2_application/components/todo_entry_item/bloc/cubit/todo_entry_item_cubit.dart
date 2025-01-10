import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/delete_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry.dart';
import 'package:todo_app/core/use_case.dart';

part 'todo_entry_item_cubit_state.dart';

class ToDoEntryItemCubit extends Cubit<ToDoEntryItemState> {
  ToDoEntryItemCubit({
    required this.loadToDoEntry, //! useCase LoadToDoEntry claas
    required this.entryId,
    required this.collectionId,
    required this.updateToDoEntry,
    required this.updateTodoEntry,
    required this.deleteToDoEntry,
    //!  useCase UpdateToDoEntry
  }) : super(ToDoEntryItemLoadingState()); //! initial state

  final EntryId entryId;
  final CollectionId collectionId;
  final LoadToDoEntry loadToDoEntry;
  final UpdateToDoEntry updateToDoEntry; //  update status
  final UpdateTodoEntry updateTodoEntry; //
  final DeleteToDoEntry deleteToDoEntry;

  // update field

  Future<void> fetch() async {
    // print('todo_entry_item_cubit: fetch entryId  $entryId');
    try {
      final entry = await loadToDoEntry.call(
        ToDoEntryIdsParam(collectionId: collectionId, entryId: entryId),
      );
      entry.fold(
        (left) {
          String message = 'Error: {_mapFailureToMessage(left)}';
          emit(ToDoEntryItemErrorState(stackTrace: message));
        },
        //
        (right) => emit(ToDoEntryItemLoadedState(toDoEntry: right)),
      );
    } on Exception {
      emit(ToDoEntryItemErrorState(stackTrace: 'could not load item!'));
    }
  }


  ///
  ///
  ///   update the status of a current entryId
  //!    This function is replaced by  the update function below
  ///   todo     ----->   This function is not used any longer and will
  ///   todo     -----> be  phased out
  ///
  Future<void> updateEntryId() async {
    // print('todo_entry_item_cubit: update entryId  $entryId');
    try {
      if (state is ToDoEntryItemLoadedState) {
        final currentToDoEntry = (state as ToDoEntryItemLoadedState).toDoEntry;
        final entryToUpdate = currentToDoEntry.copyWith(isDone: !currentToDoEntry.isDone);
        final updatedEntry = await updateToDoEntry.call(ToDoEntryIdsParam(
          collectionId: collectionId,
          entryId: entryToUpdate.id,
        ));
        updatedEntry.fold(
          (left) {
            String message = 'Error: ${_mapFailureToMessage(left)}';
            emit(ToDoEntryItemErrorState(stackTrace: message));
          },
          (right) => emit(
            ToDoEntryItemLoadedState(toDoEntry: right),
          ),
        );
      }
    } on Exception {
      emit(ToDoEntryItemErrorState(
        stackTrace: 'Could not update item!',
      ));
    }
  }


  ///
  ///   update the status of a current TodoEntry
  ///

  Future<void> update() async {
    // print('todo_entry_item_cubit: update entryId  $entryId');
    try {
      if (state is ToDoEntryItemLoadedState) {
        final currentToDoEntry = (state as ToDoEntryItemLoadedState).toDoEntry;
        final entryToUpdate = currentToDoEntry.copyWith(isDone: !currentToDoEntry.isDone);
        final updatedEntry = await updateTodoEntry.call(ToDoEntryParams(
          collectionId: collectionId,
          entry: entryToUpdate,
        ));
        updatedEntry.fold(
              (left) {
            String message = 'Error: ${_mapFailureToMessage(left)}';
            emit(ToDoEntryItemErrorState(stackTrace: message));
          },
              (right) => emit(
            ToDoEntryItemLoadedState(toDoEntry: right),
          ),
        );
      }
    } on Exception {
      emit(ToDoEntryItemErrorState(
        stackTrace: 'Could not update item!',
      ));
    }
  }


  ///
  /// Delete an EntryId of a given collection id
  ///
  ///
  Future<void> delete({required CollectionId collectionId}) async {
    try {
      if (state is ToDoEntryItemLoadedState) {
        final currentToDoEntry = (state as ToDoEntryItemLoadedState).toDoEntry;
        final entryId = currentToDoEntry.id;
        // final currentToDoEntry = (state as ToDoEntryItemLoadedState).toDoEntry;
        final result = await deleteToDoEntry.call(ToDoEntryIdsParam(
          collectionId: collectionId,
          entryId: entryId,
        ));
        result.fold((left) {
          String message = 'Error: ${_mapFailureToMessage(left)}';
          emit(ToDoEntryItemErrorState(stackTrace: message));
        }, (right) {
          emit(ToDoEntryItemDeletedState());
        });
      }
    } on Exception {
      emit(ToDoEntryItemErrorState(
        stackTrace: 'Could not delete item!',
      ));
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final ServerFailure e:
      return e.stackTrace ?? 'Server failure';
    case final CacheFailure _:
      return 'Cache failure';
    case final GeneralFailure e:
      return e.stackTrace ?? 'check the log';
    default:
      return 'Ups unhandled error';
  }
}
