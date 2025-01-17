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
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/0_data/data_sources/firebase/firebase_authentication.dart';
import 'package:todo_app/0_data/data_sources/local/hive_local_data_source.dart';
import 'package:todo_app/0_data/data_sources/remote/firestore_remote_data_source.dart';
import 'package:todo_app/0_data/repositories/firebase_authentication_repository.dart';
import 'package:todo_app/0_data/repositories/todo_repository_hybrid.dart';
import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';
import '1_domain/repositories/todo_repository.dart';
import '2_application/app/basic_app.dart';

Future<void> main() async {

  GoRouter.optionURLReflectsImperativeAPIs = true;
  final firebaseAuth = FirebaseAuthentication();
  WidgetsFlutterBinding.ensureInitialized();

  ///
  ///  initialize firebase
  ///   init()   will  initialize the app
  ///   Firebase.initializeApp()
  ///
  try {
    await firebaseAuth.init();
  } on Exception catch (e) {
    debugPrint(e.toString());
  }

  await EasyLocalization.ensureInitialized();

  ///
  ///  Configure crash handler
  ///  for non Web platform
  ///  since it is not working on web platform
  ///
  String translationsAssets = 'translations';
  if (!kIsWeb) {
    translationsAssets = 'assets/translations';
    //! Catch all errors that are thrown within the Flutter framework
    //! by overriding FlutterError.onError with
    //! FirebaseCrashlytics.instance.recordFlutterFatalError:
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    //! To catch asynchronous errors that aren't handled by the Flutter framework,
    //!  use PlatformDispatcher.instance.onError
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  ///  get Firebase authentication
  ///  FirebaseAuth auth = firebaseAuth.auth;

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
  ///
  final remoteDataSource = FireStoreRemoteDatasource();
  await remoteDataSource.init();

  runApp(EasyLocalization(
    useOnlyLangCode: true,
    supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
    path: translationsAssets,
    startLocale: Locale('en', 'US'),
    fallbackLocale: const Locale('fr', 'FR'),
    child: RepositoryProvider<ToDoRepository>(
        create: (BuildContext context) {
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
                )))),
  ));

}
