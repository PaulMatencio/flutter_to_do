import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/delete_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry.dart';
import 'package:todo_app/core/use_case.dart';
import 'package:go_router/go_router.dart';

part 'todo_entry_item_cubit_state.dart';

class ToDoEntryItemCubit extends Cubit<ToDoEntryItemState> {
  ToDoEntryItemCubit({
    required this.loadToDoEntry, //! useCase LoadToDoEntry claas
    required this.entryId,
    required this.collectionId,
    required this.updateToDoEntry,
    required this.deleteToDoEntry,

    //!  useCase UpdateToDoEntry
  }) : super(ToDoEntryItemLoadingState()); //! initial state

  final EntryId entryId;
  final CollectionId collectionId;
  final LoadToDoEntry loadToDoEntry;
  final UpdateToDoEntry updateToDoEntry;
  final DeleteToDoEntry deleteToDoEntry;

  Future<void> fetch() async {
    try {
      final entry = await loadToDoEntry.call(
        ToDoEntryIdsParam(
          collectionId: collectionId,
          entryId: entryId,
        ),
      );
      entry.fold(
        (left) {
          String message = 'Error: {_mapFailureToMessage(left)}';
          emit(ToDoEntryItemErrorState(stackTrace: message));
        },
        (right) => emit(ToDoEntryItemLoadedState(toDoEntry: right)),
      );
    } on Exception {
      emit(ToDoEntryItemErrorState(stackTrace: 'could not load item!'));
    }
  }

  Future<void> update() async {
    try {
      if (state is ToDoEntryItemLoadedState) {
        final currentEntry = (state as ToDoEntryItemLoadedState).toDoEntry;
        final entryToUpdate =
            currentEntry.copyWith(isDone: !currentEntry.isDone);
        final updatedEntry = await updateToDoEntry.call(ToDoEntryParams(
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

  Future<void> delete() async {
    try {
      if (state is ToDoEntryItemLoadedState) {
        final currentEntry = (state as ToDoEntryItemLoadedState).toDoEntry;
        final result = await deleteToDoEntry.call(ToDoEntryIdsParam(
          collectionId: collectionId,
          entryId: currentEntry.id,
        ));

        result.fold((left) {
          String message = 'Error: ${_mapFailureToMessage(left)}';
          emit(ToDoEntryItemErrorState(stackTrace: message));
        }, (right) {
          //  remove the  item
          emit(
            ToDoEntryItemDeletedState(collectionId: collectionId,
            entryId: currentEntry.id),
          );
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
      String? message =
          (e.stackTrace == null) ? 'Server failure' : e.stackTrace;
      return message!;
    case final CacheFailure _:
      return 'Cache failure';
    case final GeneralFailure e:
      String? message = (e.stackTrace == null) ? 'Check the log' : e.stackTrace;
      return message!;
    default:
      return 'Ups unhandled error';
  }
}
