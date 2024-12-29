/*
    todo_overview_error.dart
 */
import 'package:flutter/material.dart';
class ToDoOverviewError extends StatelessWidget {
  const ToDoOverviewError({super.key,this.message});
  final String ? message   ;
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Center(child: Text(message ?? 'ERROR, please try again')),
    );
  }
}
