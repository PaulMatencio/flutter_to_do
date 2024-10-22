import 'package:flutter/material.dart';

class ToDoEntryItemError extends StatelessWidget {
  const ToDoEntryItemError({super.key,  this.stackTrace});
  final String ? stackTrace;
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      onTap: null,
      leading: Icon(Icons.warning_rounded),
      title: Text(stackTrace ?? 'Could not load item'),
    );
  }
}
