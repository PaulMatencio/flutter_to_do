


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_dashbord.dart';
import 'package:todo_app/2_application/pages/dashboard/bloc/cubit/todo_dashboard_cubit.dart';
import 'package:todo_app/2_application/pages/dashboard/view_states/todo_dashboard_error.dart';
import 'package:todo_app/2_application/pages/dashboard/view_states/todo_dashboard_loaded.dart';
import 'package:todo_app/2_application/pages/dashboard/view_states/todo_dashboard_loading.dart';

import '../../core/page_config.dart';

class DashboardPageProvider extends StatelessWidget {
  const DashboardPageProvider({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoDashboardCubit(
       createTodoDashboard: CreateTodoDashboard(
           toDoRepository: RepositoryProvider.of<ToDoRepository>(context))
      )..getToDoStats(),
      child: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const pageConfig = PageConfig(
    icon: Icons.dashboard_rounded,
    name: 'dashboard',
    child: DashboardPageProvider(),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: BlocBuilder<ToDoDashboardCubit, ToDoDashboardCubitState>(
        builder: (context, state) {
          //! builder
          if (state is ToDoDashboardCubitLoadingState) {
            return const ToDoDashboardLoading();
          } else if (state is ToDoDashboardCubitLoadedState) {
            return TodoDashboardLoaded(toDoDashboard: state.toDoDashboard);
          } else if (state is ToDoDashboardCubitErrorState) {
            return ToDoDashboardError(stackTrace: state.message,);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

