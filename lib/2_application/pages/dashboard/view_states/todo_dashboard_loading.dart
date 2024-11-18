import 'package:flutter/material.dart';

class ToDoDashboardLoading extends StatelessWidget {
  const  ToDoDashboardLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator());
  }
}
