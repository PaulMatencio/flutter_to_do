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
//!  https://github.com/SKHDev195/dart-initial-learning/tree/main/todo_app/lib
//
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/0_data/data_sources/local/hive_local_data_source.dart';
import 'package:todo_app/0_data/repositories/todo_repository_local.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';
import 'package:todo_app/firebase_options.dart';
import '1_domain/repositories/todo_repository.dart';
import '2_application/app/basic_app.dart';

Future<void> main() async {

 GoRouter.optionURLReflectsImperativeAPIs=true;

  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);

  ui_auth.FirebaseUIAuth.configureProviders([
    ui_auth.EmailAuthProvider(

    ),
    ui_auth.PhoneAuthProvider()
  ]);

  ///final localDataSource =  MemoryLocalDataSource() ;
  final localDataSource = HiveLocalDataSource();
  await localDataSource.init();

  final authCubit = AuthCubit();

 ///
 ///   listen  to FirebaseAuth stream which
 ///   notifies about changes to the user's sign-in state
 ///   (such as sign-in or sign-out).
 ///
  FirebaseAuth.instance.authStateChanges().listen((user) {
    debugPrint('user: $user');
    authCubit.authStateChanged(user: user);
  });


  runApp(RepositoryProvider<ToDoRepository>(
      create: (BuildContext context) => ToDoRepositoryLocal(
            localDataSource: localDataSource,
            // localDataSource: HiveLocalDataSource(),
          ),
      child: ChangeNotifierProvider(create: (context) => ThemeService(),
          child: BlocProvider<AuthCubit>(
              create: (context) => authCubit ,
              child: const BasicApp())))
  );
}
