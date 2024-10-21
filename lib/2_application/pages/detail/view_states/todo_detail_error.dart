

import 'package:flutter/material.dart';

class ToDoDetailError extends StatelessWidget {
  const ToDoDetailError({super.key, this.stackTrace});
  final String ? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(stackTrace?? 'ERROR on Detail Page, please try again'),
        ),
      ),
    );
  }
}