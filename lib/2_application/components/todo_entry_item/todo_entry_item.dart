import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/delete_todo_entries.dart';
import 'package:todo_app/1_domain/use_cases/delete_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry_ids_for_collection.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry.dart';
import 'package:todo_app/2_application/components/todo_entry_item/bloc/cubit/todo_entry_item_cubit.dart';
import 'package:todo_app/2_application/components/todo_entry_item/view_states/todo_entry_item_error.dart';
import 'package:todo_app/2_application/components/todo_entry_item/view_states/todo_entry_item_loaded.dart';
import 'package:todo_app/2_application/components/todo_entry_item/view_states/todo_entry_item_loading.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/pages/detail/bloc/cubit/todo_detail_cubit.dart';
import 'package:todo_app/2_application/pages/modify_todo_entry/modify_todo_entry_page.dart';

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
    // final entryId = entryIds[index];t
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToDoEntryItemCubit>(
          create: (context) => ToDoEntryItemCubit(
            collectionId: collectionId,
            entryId: entryId,
            loadToDoEntry: LoadToDoEntry(
              toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
            ),
            updateToDoEntry: UpdateToDoEntry(
              toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
            ),
            updateTodoEntry: UpdateTodoEntry(
              toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
            ),
            deleteToDoEntry: DeleteToDoEntry(
              toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
            ),
          )..fetch(), //!
        ),
      ],
      child: ToDoEntryItem(collectionId: collectionId),
    );
  }
}

class ToDoEntryItem extends StatelessWidget {
  const ToDoEntryItem({
    super.key,
    required this.collectionId,
  });

  final CollectionId collectionId;

  @override
  Widget build(BuildContext context) {
    final todoEntryItemCubit = context.read<ToDoEntryItemCubit>();
    return BlocBuilder<ToDoEntryItemCubit, ToDoEntryItemState>(
      builder: (context, state) {
        if (state is ToDoEntryItemLoadingState) {
          return const ToDoEntryItemLoading();
        } else if (state is ToDoEntryItemLoadedState) {
          return ToDoEntryItemLoaded(
              entryItem: state.toDoEntry, //!   result from cubit fetch ....
              onChanged: (value) => todoEntryItemCubit.update(),
              onUpdated: () {
                context.pushNamed(ModifyToDoEntryPage.pageConfig.name,
                    extra: ModifyToDoEntryPageExtra(
                        toDoEntryItemModifiedCallback: context.read<ToDoEntryItemCubit>().fetch,
                        collectionId: collectionId,
                        toDoEntry: state.toDoEntry));
              },

              ///   delete an entry
              onDeleted: () {
                return showAlertDialog(
                  context: context,
                  entryId: state.toDoEntry.id, //! either or  entryIds
                  collectionId: collectionId,
                  todoEntryItemCubit: todoEntryItemCubit,
                );
              });
        } else if (state is ToDoEntryItemDeletedState) {
          /// an empty widget to clear the tile
          return SizedBox();
        }
        else if (state is ToDoEntryItemErrorState) {
          return ToDoEntryItemError(
            stackTrace: state.stackTrace,
            onReload: () {
              return todoEntryItemCubit.fetch();
            },
          );
        } else {
          return Placeholder(); //! should never happen
        }
      },
    );
  }
}

///
///   Show an Alert Dialog before deleting
///   continue -> delete it then route back
///   cancel -> just route back
///
showAlertDialog({
  required BuildContext context,
  required ToDoEntryItemCubit todoEntryItemCubit,
  required EntryId entryId,
  required CollectionId collectionId,
}) {
  /// set up the Cancel button
  Widget cancelButton = TextButton(child: Text('Cancel'), onPressed: () => context.pop());

  ///  Setup the continue button
  Widget continueButton = BlocProvider(
    create: (context) => ToDoDetailCubit(
        loadToDoEntryIdsForCollection:
            LoadToDoEntryIdsForCollection(toDoRepository: RepositoryProvider.of<ToDoRepository>(context)),
        deleteToDoEntries: DeleteToDoEntries(toDoRepository: RepositoryProvider.of<ToDoRepository>(context))),
    child: TextButton(
        child: Text('Continue'),
        onPressed: () async {
          final todoDetailCubit = context.read<ToDoDetailCubit>();
          try {
            await context
                .read<ToDoEntryItemCubit>()
                .delete(collectionId: collectionId)
                .then((_) => todoDetailCubit.removeEntryId(entryId));
          } on Exception catch (e) {
            FailureDialog(message: e.toString());
          }
          context.pop();
        }),
  );

  ///
  /// Set up the AlertDialog
  ///
  AlertDialog alert = AlertDialog(
    title: Text('AlertDialog'),
    content: Text('Are you sure you want to delete'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog

  ///
  ///    Build the AlertDialog
  ///
  showDialog(
    context: context,
    useRootNavigator: false, //  use go router instead
    builder: (BuildContext context) {
      return alert; //
    },
  );
}
