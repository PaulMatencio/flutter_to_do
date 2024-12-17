import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/0_data/data_sources/firebase/firebase_authentication.dart';
import 'package:todo_app/0_data/repositories/todo_repository_mock.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/2_application/app/basic_app.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';

void main() {
  //  runApp(const BasicApp());
  final  firebaseAuth = FirebaseAuthentication();
  runApp(RepositoryProvider<ToDoRepository>(
      create: (BuildContext context) => ToDoRepositoryMock(),
      child: ChangeNotifierProvider(create: (context) => ThemeService(), child: BasicApp(firebaseAuth: firebaseAuth,))));
}
