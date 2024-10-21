import 'package:flutter/material.dart';

class ToDoEntryLoading extends StatelessWidget {
  const ToDoEntryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator());
  }
}