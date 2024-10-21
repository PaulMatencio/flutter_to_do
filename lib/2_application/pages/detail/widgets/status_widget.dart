import 'package:flutter/material.dart';

class IsDoneWidget extends StatelessWidget {
  final double radius;
  // final Widget child;
  const IsDoneWidget({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.lightGreenAccent)
      );
  }
}

class ToDoWidget extends StatelessWidget {
  final double radius;
  // final Widget child;
  const ToDoWidget({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.redAccent)
    );
  }
}