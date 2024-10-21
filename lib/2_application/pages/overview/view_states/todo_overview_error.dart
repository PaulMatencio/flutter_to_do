/*
    todo_overview_error.dart
 */

import 'package:flutter/material.dart';
class ToDoOverviewError extends StatelessWidget {
  const ToDoOverviewError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Center(child: Text('ERROR, please try again')),
    );
  }
}