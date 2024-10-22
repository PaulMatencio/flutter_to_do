

/*
//!      Use  the course <lib/components/to_entry_item/to_entry_item.dart> version  instead  of this one
//!       which is my homework
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry.dart';
import 'package:todo_app/2_application/widgets/todo_entry/bloc/todo_entry_cubit.dart';
import 'package:todo_app/2_application/widgets/todo_entry/view_states/todo_entry_error.dart';
import 'package:todo_app/2_application/widgets/todo_entry/view_states/todo_entry_loaded.dart';
import 'package:todo_app/2_application/widgets/todo_entry/view_states/todo_entry_loading.dart';

class ToDoEntryItemProvider extends StatelessWidget {
  const ToDoEntryItemProvider({
    super.key,
    required this.collectionId,
    required this.entryId,
  });

  final CollectionId collectionId;
  final EntryId entryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToDoEntryCubit>(
      create: (context) => ToDoEntryCubit(
        collectionId: collectionId,
        entryId: entryId,
        //!
        //!   call   useCase LoadToDoEntry in order
        //!   to fetch TodoEntry  from the
        //!     RepositoryProvider
        //!
        loadToDoEntry: LoadToDoEntry(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
        updateToDoEntry: UpdateToDoEntry(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
      )..fetch(),

      child: ToDoEntryItem(),
      );
  }
}


class ToDoEntryItem extends StatelessWidget {
  const ToDoEntryItem({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
       return BlocBuilder<ToDoEntryCubit, ToDoEntryCubitState>(
         builder: (BuildContext context, ToDoEntryCubitState state) {
           //return const Placeholder();
           if (state is ToDoEntryCubitLoadingState) {
             return ToDoEntryLoading();
           } else if (state is ToDoEntryCubitLoadedState) {
             return  ToDoEntryLoaded(
               toDoEntry: state.toDoEntry,
               onChanged: (value) => context.read<ToDoEntryCubit>().update(),
             );
           } else  if (state is ToDoEntryCubitErrorState){
             return ToDoEntryError(stackTrace: state.stackTrace,);
           }  else {
             return const  SizedBox();
           }
         },
       );

  }
}

