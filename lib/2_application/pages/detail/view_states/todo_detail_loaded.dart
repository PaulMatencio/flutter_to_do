import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/components/todo_entry_item/todo_entry_item.dart';
import 'package:todo_app/2_application/pages/create_todo_entry/create_todo_entry_page.dart';
import 'package:todo_app/2_application/pages/detail/bloc/cubit/todo_detail_cubit.dart';

class ToDoDetailLoaded extends StatelessWidget {
  const ToDoDetailLoaded({
    super.key,
    required this.entryIds,
    required this.collectionId,
  });

  final List<EntryId> entryIds;
  final CollectionId collectionId;


  void removeEntryId({required EntryId entryId}) {
    entryIds.remove(entryId);
  }

  @override
  Widget build(BuildContext context) {
   // print('entryIds length ${entryIds.length}');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: entryIds.length,
              itemBuilder: (context, index) => ToDoEntryItemProvider(
                collectionId: collectionId,
                entryId: entryIds[index],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                  key: const Key('create-todo-entry'),
                  heroTag: 'create-todo-entry',
                  tooltip: 'add_entry',
                  onPressed: () {
                    context.pushNamed(
                      CreateToDoEntryPage.pageConfig.name,
                      extra:  CreateToDoEntryPageExtra(
                        collectionId: collectionId,
                        toDoEntryItemAddedCallback: context.read<ToDoDetailCubit>().fetch,
                      ),
                    );
                  },
                  child: Icon(CreateToDoEntryPage.pageConfig.icon)),
            ),
          ],
        ),
      ),
    );
  }
}
