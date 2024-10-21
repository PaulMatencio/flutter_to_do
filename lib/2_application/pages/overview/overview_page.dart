
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/overview/bloc/todo_overview_cubit.dart';
import 'package:todo_app/2_application/pages/overview/view_states/todo_overview_error.dart';
import 'package:todo_app/2_application/pages/overview/view_states/todo_overview_loaded.dart';
import 'package:todo_app/2_application/pages/overview/view_states/todo_overview_loading.dart';

class OverviewPageProvider extends StatelessWidget {
  const OverviewPageProvider({super.key});
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ToDoOverviewCubit(
        loadToDoCollections: LoadToDoCollections(  //   use_cases
          /// Takes a [Create] function that is responsible for creating the repository
          /// and a `child` which will have access to the repository via
          /// `RepositoryProvider.of(context)`.
          /// It is used as a dependency injection (DI) widget so that a single instance
          /// of a repository can be provided to multiple widgets within a subtree.
          toDoRepository: RepositoryProvider.of(context), //!  main.dart
        ),
      )..readToDoCollections(),
      child: const OverviewPage(),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  static const pageConfig = PageConfig(
    icon: Icons.work_history_rounded,
    name: 'overview',
    child: OverviewPageProvider(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: BlocBuilder<ToDoOverviewCubit, ToDoOverviewCubitState>(
        builder: (context, state) { //! builder
          if (state is ToDoOverviewCubitLoadingState) {
            return const ToDoOverviewLoading();
          } else if (state is ToDoOverviewCubitLoadedState) {
            return ToDoOverviewLoaded(collections: state.collections);
          } else  if (state is ToDoOverviewCubitErrorState){
            return ToDoOverviewError();
          }  else {
            return const  SizedBox();
          }
        },
      ),
    );
  }
}


