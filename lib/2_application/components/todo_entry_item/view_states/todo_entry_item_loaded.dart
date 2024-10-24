import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';

class ToDoEntryItemLoaded extends StatelessWidget {
  const ToDoEntryItemLoaded({
    super.key,
    required this.entryItem,
    required this.onChanged,
  });

  final ToDoEntry entryItem;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    /// The checkbox tile itself does not maintain any state. Instead, when the
    /// state of the checkbox changes, the widget calls the [onChanged] callback.
    /// Most widgets that use a checkbox will listen for the [onChanged] callback
    /// and rebuild the checkbox tile with a new [value] to update the visual
    /// appearance of the checkbox.
    return Card.outlined(
      child: CheckboxListTile(
        title: Text(entryItem.description),
        activeColor: Colors.blueGrey,
        value: entryItem.isDone,
        onChanged: onChanged,
      ),
    );
  }
}
