import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/delete_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry.dart';
import 'package:todo_app/2_application/components/todo_entry_item/bloc/cubit/todo_entry_item_cubit.dart';
import 'package:todo_app/2_application/components/todo_entry_item/view_states/todo_entry_item_error.dart';
import 'package:todo_app/2_application/components/todo_entry_item/view_states/todo_entry_item_loaded.dart';
import 'package:todo_app/2_application/components/todo_entry_item/view_states/todo_entry_item_loading.dart';

class ToDoEntryItemProvider extends StatelessWidget {
  const ToDoEntryItemProvider({
    super.key,
    required this.collectionId,
    required this.entryIds,
    required this.index,
  });

  final CollectionId collectionId;
  final List<EntryId> entryIds;
  final int index;

  @override
  Widget build(BuildContext context) {
   // final entryId  = entryIds[index];
    return BlocProvider<ToDoEntryItemCubit>(
      create: (context) => ToDoEntryItemCubit(
          collectionId: collectionId,
          entryId: entryIds[index],
          loadToDoEntry: LoadToDoEntry(
            toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
          ),
          updateToDoEntry: UpdateToDoEntry(
            toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
          ),
        deleteToDoEntry:  DeleteToDoEntry(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),

      )
        ..fetch(), //!
      child: ToDoEntryItem(
        collectionId: collectionId,
        entryIds: entryIds,
        index:index,
      ),
    );
  }
}

class ToDoEntryItem extends StatelessWidget {
  const ToDoEntryItem(
      {super.key, required this.collectionId, required this.entryIds,
      required this.index});

  final CollectionId collectionId;
  final List<EntryId> entryIds;
  final int index;

  @override
  Widget build(BuildContext context) {

    final todoEntryItemCubit = context.read<ToDoEntryItemCubit>();

    return BlocBuilder<ToDoEntryItemCubit, ToDoEntryItemState>(
      builder: (context, state) {
        if (state is ToDoEntryItemLoadingState) {
          return const ToDoEntryItemLoading();
        } else if (state is ToDoEntryItemLoadedState) {
          return ToDoEntryItemLoaded(
            entryItem: state.toDoEntry,
            onChanged: (value) => todoEntryItemCubit.update(),
            onDeleted: ()  {
              entryIds.removeAt(index);
              todoEntryItemCubit.delete();
            }
            //onDeleted: () => showAlertDialog(context,todoEntryItemCubit)
          );
        }
        else if (state is ToDoEntryItemDeletedState){
          // entryIds.removeAt(index);
          return SizedBox();
        }
        else if (state is ToDoEntryItemErrorState) {
          return ToDoEntryItemError(
            stackTrace: state.stackTrace,
            onReload: () {
              return todoEntryItemCubit.fetch();}
            ,
          );
        } else {
          return Placeholder();
        }
      },
    );
  }
}



showAlertDialog(BuildContext context,ToDoEntryItemCubit todoEntryItemCubit) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text('Cancel'),
    onPressed:  () {
      return;
    });
  Widget continueButton = TextButton(
    child: Text('Continue'),
    onPressed:  () {
      todoEntryItemCubit.delete();
      return;
      // Navigator.of(context).pop();
      }
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('AlertDialog'),
    content: Text('Would you like to continue learning how to use delete?'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert ;
    },
  );
}