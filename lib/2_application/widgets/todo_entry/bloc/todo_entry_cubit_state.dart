
part of 'todo_entry_cubit.dart';

abstract class ToDoEntryCubitState extends Equatable {
  const ToDoEntryCubitState();
  @override
  List<Object> get props => [];
}

class ToDoEntryCubitLoadingState extends ToDoEntryCubitState {}

class ToDoEntryCubitErrorState extends ToDoEntryCubitState {
  const ToDoEntryCubitErrorState({required this.stackTrace});
  final String  stackTrace;
  @override
  List<Object> get props => [stackTrace];
}


class ToDoEntryCubitLoadedState extends ToDoEntryCubitState {
  const ToDoEntryCubitLoadedState({required this.toDoEntry,});
  final ToDoEntry toDoEntry;
  @override
  List<Object> get props => [toDoEntry];
}
