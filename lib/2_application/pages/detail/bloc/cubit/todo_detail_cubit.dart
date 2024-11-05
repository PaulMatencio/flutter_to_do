import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry_ids_for_collection.dart';
import 'package:todo_app/core/use_case.dart';

part 'todo_detail_cubit_state.dart';

class ToDoDetailCubit extends Cubit<ToDoDetailCubitState> {
  ToDoDetailCubit({this.collectionId,
    required this.loadToDoEntryIdsForCollection,
    //! required this.removeToDoEntry
  })
      : super(ToDoDetailCubitLoadingState()); //! initial

  final CollectionId? collectionId;
  final LoadToDoEntryIdsForCollection loadToDoEntryIdsForCollection;
  //! final RemoveToDoEntry removeToDoEntry;

  // -----------------------------------------------------
  // fetch is called by todo_overview_loaded.dart when you
  //  click on the entry of the collection list
  //--------------------------------------------------------

  Future<void> fetch() async {
    print('todo_detail_cubit: fetch todo_entries for collection $collectionId');
    emit(ToDoDetailCubitLoadingState());
    if (collectionId != null) {
      try {
        final entryIds = await loadToDoEntryIdsForCollection.call(
          CollectionIdParam(collectionId: collectionId!),
        );
        if (entryIds.isLeft) {
          emit(ToDoDetailCubitErrorState());
        } else {
          emit(ToDoDetailCubitLoadedState(entryIds: entryIds.right));
        }
      } on Exception {
        emit(ToDoDetailCubitErrorState());
      }
    } else {
      emit(ToDoDetailCubitErrorState());
    }
  }

  //
  //    Remove the EntryId from the current entryId list
  //
  Future<void>  removeEntryId(EntryId entryId) async {
    // print('remove entryId $entryId from the state  ');
    try {
      if (state is ToDoDetailCubitLoadedState) {
        (state  as ToDoDetailCubitLoadedState).entryIds.remove(entryId);
      }
    } on Exception {
      emit(ToDoDetailCubitErrorState());
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
