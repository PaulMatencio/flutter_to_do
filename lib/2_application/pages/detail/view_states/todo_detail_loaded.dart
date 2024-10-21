import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/2_application/widgets/todo_entry/bloc/todo_entry_cubit.dart';
import 'package:todo_app/2_application/widgets/todo_entry/todo_entry_widget.dart';

class ToDoDetailLoaded extends StatelessWidget {
  const ToDoDetailLoaded({
    super.key,
    required this.entryIds,
    required this.collectionId,
  });

  final List<EntryId> entryIds;
  final CollectionId collectionId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: entryIds.length,
          itemBuilder: (context, index) => ToDoEntryItemProvider(
            collectionId: collectionId,
            entryId: entryIds[index],
          ),
        ),
      ),
    );
  }
}
