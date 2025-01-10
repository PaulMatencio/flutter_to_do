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
import 'package:todo_app/0_data/data_sources/firebase/firebase_authentication.dart';
import 'package:todo_app/0_data/data_sources/local/hive_local_data_source.dart';
import 'package:todo_app/0_data/data_sources/remote/firestore_remote_data_source.dart';
import 'package:todo_app/0_data/repositories/firebase_authentication_repository.dart';
import 'package:todo_app/0_data/repositories/todo_repository_hybrid.dart';
import 'package:todo_app/0_data/repositories/todo_repository_local.dart';
import 'package:todo_app/0_data/repositories/todo_repository_remote.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';
import '1_domain/repositories/todo_repository.dart';
import '2_application/app/basic_app.dart';

Future<void> main() async {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  final firebaseAuth = FirebaseAuthentication();
  WidgetsFlutterBinding.ensureInitialized();

  ///  initialize firebase
  try {
    await firebaseAuth.init();
  } on Exception catch (e) {
    debugPrint(e.toString());
  }

  ///  get Firebase authentication
  FirebaseAuth auth = firebaseAuth.auth;

  ///
  ///   keep it for  switching  between  firebase auth-ui login and  our firebase login
  ///
  ui_auth.FirebaseUIAuth.configureProviders(
      [ui_auth.EmailAuthProvider(), ui_auth.PhoneAuthProvider()]);

  final authenticationRepository =
      FirebaseAuthenticationRepository(authentication: firebaseAuth);
  final authCubit =
      AuthCubit(authenticationRepository: authenticationRepository);

  ///  listen to firebase authentication user stream
  ///   update user state ( login or logout)
  /*
  auth.authStateChanges().listen((user) {
    if (user != null ){
      debugPrint(user.uid);
    }
    authCubit.authStateChanged(user: user);
  });
  */

  //!  final localDataSource =  MemoryLocalDataSource() ;

  ///
  ///   init hive database
  ///
  final localDataSource = HiveLocalDataSource();
  await localDataSource.init();

  ///
  ///    init fireStore  database
  ///
  final remoteDataSource = FireStoreRemoteDatasource();
  await remoteDataSource.init();

  runApp(RepositoryProvider<ToDoRepository>(
      create: (BuildContext context) {
        /*
        return ToDoRepositoryLocal(
          localDataSource: localDataSource,
        );

        return ToDoRepositoryRemote(
          remoteDataSource: remoteDataSource,
        );
        */
        return ToDoRepositoryHybrid(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource
        );
      },
      child: ChangeNotifierProvider(
          create: (context) => ThemeService(),
          child: BlocProvider<AuthCubit>(
              create: (context) => authCubit,
              child: BasicApp(
                firebaseAuth: firebaseAuth,
              )))));
  //  child:  BasicApp(authenticationRepository: authenticationRepository,)))));
}
