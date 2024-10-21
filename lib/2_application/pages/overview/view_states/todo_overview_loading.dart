import 'package:flutter/material.dart';

class ToDoOverviewLoading extends StatelessWidget {
  const ToDoOverviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator.adaptive());
  }
}