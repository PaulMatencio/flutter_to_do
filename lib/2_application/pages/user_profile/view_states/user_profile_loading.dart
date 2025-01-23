import 'package:flutter/material.dart';

class UserProfileLoading extends StatelessWidget {
  const UserProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator());
  }
}

