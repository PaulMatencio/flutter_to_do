import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/2_application/components/todo_entry_item/bloc/cubit/todo_entry_item_cubit.dart';

class ToDoEntryItemError extends StatelessWidget {
  const ToDoEntryItemError({super.key, this.stackTrace, required this.onReload});

  final Function() onReload;
  final String? stackTrace;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoEntryItemCubit, ToDoEntryItemState>(
      builder: (context, state) {
       // final todoEntryItem = context.read<ToDoEntryItemCubit>();
        return ListTile(
          iconColor: Theme.of(context).colorScheme.error,
          onTap: onReload,
          leading: const Icon(Icons.warning_rounded),
          title: Text('$stackTrace. Tap to reload.'),
        );
      },
    );
  }
}
