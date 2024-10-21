import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry.dart';
import 'package:todo_app/core/use_case.dart';

part 'todo_entry_cubit_state.dart';

class ToDoEntryCubit extends Cubit<ToDoEntryCubitState> {

  ToDoEntryCubit({
    required this.entryId,
    required this.collectionId,
    required this.loadToDoEntry,
    required this.updateToDoEntry
  }) : super(ToDoEntryCubitLoadingState()); //  initial state

  final EntryId? entryId;
  final CollectionId? collectionId;
  final LoadToDoEntry loadToDoEntry;
  final UpdateToDoEntry updateToDoEntry;

  //!  fetch is called by todo_overview_loaded,dart when you
  //!   click on the entry of the collection list
  Future<void> fetch() async {
    emit(ToDoEntryCubitLoadingState());
    //!
    //!    Call   loadToDoEntry   use_cases
    //!
    try {
      final toDoEntry = await loadToDoEntry.call(
        ToDoEntryIdsParam(collectionId: collectionId!, entryId: entryId!),
      );

      return toDoEntry.fold(
          (left) =>  emit(ToDoEntryCubitErrorState(stackTrace: 'Error fetching  entry ${entryId!.value}')),
          (right) =>   emit(ToDoEntryCubitLoadedState(toDoEntry: toDoEntry.right))
      );
    } on Exception {
      emit(ToDoEntryCubitErrorState(stackTrace: 'Fail to fetch entry ${entryId!.value}'));
    }
  }

  Future<void> update() async {
    try {
      if (state is ToDoEntryCubitLoadedState) {

        final currentEntry = (state as ToDoEntryCubitLoadedState).toDoEntry;
        //!  update the current entry
        final entryToUpdate = currentEntry.copyWith(isDone: !currentEntry.isDone);
        final updatedEntry = await updateToDoEntry.call(ToDoEntryParams(
          collectionId: collectionId!,
          entry  : entryToUpdate,
        ));
        return updatedEntry.fold(
              (left) => emit(ToDoEntryCubitErrorState(stackTrace: 'Error updating entry ${entryId!.value}')),
              (right) => emit(ToDoEntryCubitLoadedState(toDoEntry: right)
          ),
        );
      }
    } on Exception {
      emit(ToDoEntryCubitErrorState(stackTrace: 'Fail to update entry ${entryId!.value} '));
    }
  }
}
