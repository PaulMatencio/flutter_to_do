part of 'todo_dashboard_cubit.dart';

abstract class ToDoDashboardCubitState extends Equatable {
  const ToDoDashboardCubitState();
  @override
  List<Object> get props => [];
}

class ToDoDashboardCubitLoadingState extends ToDoDashboardCubitState {}


class ToDoDashboardCubitErrorState extends ToDoDashboardCubitState {
  const ToDoDashboardCubitErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

//
//    Cubit to manage the list<entryId>
//
class ToDoDashboardCubitLoadedState extends ToDoDashboardCubitState {
  const ToDoDashboardCubitLoadedState({required this.toDoDashboard});
  final ToDoDashboard toDoDashboard;
  @override
  List<Object> get props => [toDoDashboard];
}