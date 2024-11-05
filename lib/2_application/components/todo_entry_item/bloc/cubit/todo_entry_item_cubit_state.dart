part of 'todo_entry_item_cubit.dart';


//
// ----------------------------------------------------------
//!    Create a Cubit for Each Item
//
// ---------------------------------------------------------

abstract class ToDoEntryItemState extends Equatable {
  const ToDoEntryItemState();
  @override
  List<Object> get props => [];
}

class ToDoEntryItemLoadingState extends ToDoEntryItemState {}


class ToDoEntryItemErrorState extends ToDoEntryItemState {
  const ToDoEntryItemErrorState({this.stackTrace});
  final String ? stackTrace;
  @override
  List<Object> get props => [stackTrace?? ''] ;
}


class ToDoEntryItemDeletedState extends ToDoEntryItemState {
}


class ToDoEntryItemLoadedState extends ToDoEntryItemState {
  const ToDoEntryItemLoadedState({required this.toDoEntry});
  final ToDoEntry toDoEntry;
  @override
  List<Object> get props => [toDoEntry];
}
