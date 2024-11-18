import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_dashboard.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_dashbord.dart';
import 'package:todo_app/core/use_case.dart';

part 'todo_dashboard_cubit_state.dart';

class ToDoDashboardCubit extends Cubit<ToDoDashboardCubitState> {
  ToDoDashboardCubit({
    required this.createTodoDashboard,
    ToDoDashboardCubitState? initialState,
  }) : super(initialState ?? ToDoDashboardCubitLoadingState());

  final CreateTodoDashboard createTodoDashboard;

  Future<void> getToDoStats() async {
    emit(ToDoDashboardCubitLoadingState());
    try {
      final result = await createTodoDashboard.call(NoParams());
      result.fold((failure) => emit(ToDoDashboardCubitErrorState(message: _mapFailureToMessage(failure))),
          (right) => emit(ToDoDashboardCubitLoadedState(toDoDashboard: right)));
    } on Exception catch (e) {
      emit(ToDoDashboardCubitErrorState(message: e.toString()));
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure) {
    case final ServerFailure e:
      return e.stackTrace ?? 'Ups! something went wrong';
    case final CacheFailure _:
      return 'Cache failure';
    case final GeneralFailure e:
      return e.stackTrace?? 'check the log';
    default:
      return 'Ups unhandled error';
  }
}

