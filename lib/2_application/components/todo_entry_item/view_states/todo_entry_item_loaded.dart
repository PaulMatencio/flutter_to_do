import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';

class ToDoEntryItemLoaded extends StatelessWidget {
  const ToDoEntryItemLoaded({
    super.key,
    required this.entryItem,
    required this.onChanged,
    required this.onDeleted,
    required this.onUpdated,
  });

  final ToDoEntry entryItem;
  final Function(bool?) onChanged;
  final Function() onDeleted;
  final Function() onUpdated;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Row(children: [
        Tooltip(message: 'delete', child: TextButton(onPressed: onDeleted, child: Icon(Icons.delete))),
        Tooltip(message: 'modify', child: TextButton(onPressed: onUpdated, child: Icon(Icons.update_rounded))),
        Expanded(
          child: CheckboxListTile(
            title: Text(entryItem.description),
            activeColor: Colors.blueGrey,
            value: entryItem.isDone,
            onChanged: onChanged,
          ),
        ),
      ]),
    );
  }
}
