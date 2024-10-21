
import 'package:flutter/material.dart';

class ToDoEntryError extends StatelessWidget {
  const ToDoEntryError({super.key, this.stackTrace});
  final String ? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(stackTrace?? 'Ups something went wrong with entry operation'),
        ),
      ),
    );
  }
}