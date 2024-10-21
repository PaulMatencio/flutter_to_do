//!
//! 1 - install  firebase Cli
//! 2 - Activate  flutter fire
//!            dart pub global activate flutterfire_cli
//! 3-  Run flutter_fire configure
//!    export PATH="$PATH":"$HOME/.pub-cache/bin"

//!   Responsive Layout grid
//!   https://m2.material.io/design/layout/responsive-layout-grid.html#columns-gutters-and-margins
//!   https://m3.material.io/foundations/layout/understanding-layout/overview
//!

//
//!   https://github.com/fabioychinen/todo_app
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '0_data/repositories/todo_repository_mock.dart';
import '1_domain/repositories/todo_repository.dart';
import '2_application/app/basic_app.dart';

void main() {
 //  runApp(const BasicApp());
    runApp(RepositoryProvider<ToDoRepository>(
      create: (BuildContext context) => ToDoRepositoryMock(),
      child: const BasicApp(),
    ));
}





