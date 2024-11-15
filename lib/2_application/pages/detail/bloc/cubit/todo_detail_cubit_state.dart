part of 'todo_detail_cubit.dart';

// --------------------------------------------------------
//!   create a Cubit for the entire list list<EntryId>
//--------------------------------------------------------
abstract class ToDoDetailCubitState extends Equatable {
  const ToDoDetailCubitState();

  @override
  List<Object> get props => [];
}

class ToDoDetailCubitLoadingState extends ToDoDetailCubitState {}

class ToDoDetailCubitDeletedState extends ToDoDetailCubitState {}

class ToDoDetailCubitErrorState extends ToDoDetailCubitState {}

//
//    Cubit to manage the list<entryId>
//
class ToDoDetailCubitLoadedState extends ToDoDetailCubitState {
  const ToDoDetailCubitLoadedState({required this.entryIds});

  final List<EntryId> entryIds;

  @override
  List<Object> get props => [entryIds];
}
