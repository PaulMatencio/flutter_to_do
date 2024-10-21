import 'package:flutter/material.dart';

class ToDoDetailLoading extends StatelessWidget {
  const ToDoDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator());
  }
}