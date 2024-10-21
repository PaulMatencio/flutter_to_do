
part of 'todo_overview_cubit.dart';

abstract class ToDoOverviewCubitState extends Equatable {
  const ToDoOverviewCubitState();
  @override
  List<Object> get props => [];
}

class ToDoOverviewCubitLoadingState extends ToDoOverviewCubitState {
  const ToDoOverviewCubitLoadingState();
}

class ToDoOverviewCubitErrorState extends ToDoOverviewCubitState {
  final String message;
  const ToDoOverviewCubitErrorState({required this.message});
  getMessage() => message;
  @override
  List<Object> get props => [message];

}

class ToDoOverviewCubitLoadedState extends ToDoOverviewCubitState {
  const ToDoOverviewCubitLoadedState({required this.collections});
  final List<ToDoCollection> collections;
  @override
  List<Object> get props => [collections];
}