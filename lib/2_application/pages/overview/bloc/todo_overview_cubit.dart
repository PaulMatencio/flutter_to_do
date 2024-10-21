import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/core/use_case.dart';

part 'todo_overview_cubit_state.dart';

const generalFailureMessage = 'Ups,something went wrong. Please try again';
const serverFailureMessage = 'Ups, Api error';
const cacheFailureMessage = 'Ups, cache failed . Please try again';
const dataExceptionMessage =' Ups,bad json data';


class ToDoOverviewCubit extends Cubit<ToDoOverviewCubitState> {

  ToDoOverviewCubit({
    required this.loadToDoCollections,
    ToDoOverviewCubitState? initialState,
  }) : super(initialState ?? ToDoOverviewCubitLoadingState());

  final LoadToDoCollections loadToDoCollections;

  //!
  //!   readToDoCollections  use_Case/loadTodoCollections
  //!

  Future<void> readToDoCollections() async {
    emit(ToDoOverviewCubitLoadingState());
    try {
      final collectionsFuture = loadToDoCollections.call(NoParams());
      final collections = await collectionsFuture;
      collections.fold(
          (failure) =>  emit(ToDoOverviewCubitErrorState(message: _mapFailureToMessage(failure))),
        (collections) =>  emit(ToDoOverviewCubitLoadedState(collections: collections)));
    } on Exception catch(e) {
      emit(ToDoOverviewCubitErrorState(message: e.toString()));
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final ServerFailure e:
      String ? message = (e.stackTrace ==  null) ? serverFailureMessage: e.stackTrace;
      return ( message ?? serverFailureMessage);
    case final CacheFailure _:
      return cacheFailureMessage;
      /*
    case final DataFailure e :
      return e.message;
       */
    default:
      return generalFailureMessage;
  }
}
