import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry_ids_for_collection.dart';
import 'package:todo_app/core/use_case.dart';
part 'todo_detail_cubit_state.dart';

class ToDoDetailCubit extends Cubit<ToDoDetailCubitState> {
  ToDoDetailCubit({
    this.collectionId,
    required this.loadToDoEntryIdsForCollection,
  }) : super(ToDoDetailCubitLoadingState());  //! initial

  final CollectionId? collectionId;
  final LoadToDoEntryIdsForCollection loadToDoEntryIdsForCollection;


  //!  fetch is called by todo_overview_loaded,dart when you
  //!  click on the entry of the collection list
  Future<void> fetch() async {
    emit(ToDoDetailCubitLoadingState());
    if (collectionId  != null ) {
      try {
        //!   call use_cases/
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
}
