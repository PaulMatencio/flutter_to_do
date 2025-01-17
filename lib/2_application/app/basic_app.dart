import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/0_data/data_sources/firebase/firebase_authentication.dart';
import 'package:todo_app/0_data/repositories/firebase_authentication_repository.dart';

import 'package:todo_app/2_application/app/cubit/auth_cubit.dart';
import 'package:todo_app/2_application/core/models/confirmation_code.dart';
import 'package:todo_app/2_application/core/routes.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';
import 'package:todo_app/2_application/pages/register/bloc/cubit/register_cubit.dart';
import 'package:todo_app/theme.dart';

import '../../1_domain/use_cases/authentication.dart';

class BasicApp extends StatelessWidget {

  const BasicApp({super.key, required this.firebaseAuth});
  final FirebaseAuthentication firebaseAuth;

  /*
  const BasicApp({super.key, this.authenticationRepository});
  final   FirebaseAuthenticationRepository  ? authenticationRepository;
  */
  @override
  Widget build(BuildContext context) {

    final authenticationRepository =
        FirebaseAuthenticationRepository(authentication: firebaseAuth);

    /*
    firebaseAuth.auth.authStateChanges().listen((user) {
      if (user != null) {
        debugPrint(user.uid);
      }
      if (context.mounted) {
        context.read<AuthCubit>().authStateChanged(user: user);
      }
      // authCubit.authStateChanged(user: user);
    });
    */

    authenticationRepository.authStateChanges().listen((userEntity) {
      if (userEntity.uid != null) {
        debugPrint(userEntity.uid);
      }
      if (context.mounted) {
        context.read<AuthCubit>().authStateChanged(user: userEntity);
      }
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(
              loginWithEmailAndPassword: LoginWithEmailAndPassword(
                  authenticationRepository: authenticationRepository),
            ///  loginWithPhoneNumber: LoginWithPhoneNumber(authenticationRepository: authenticationRepository),
              signOut:
                  SignOut(authenticationRepository: authenticationRepository),
              signInWithPhoneNumber: LoginWithPhoneNumber(
                  authenticationRepository: authenticationRepository),
              verifyPhoneNumber: VerifyPhoneNumber(authenticationRepository: authenticationRepository),
              verificationCode: VerificationCode(authenticationRepository: authenticationRepository),
          ),
        ),
        BlocProvider(
            create: (context) => RegisterCubit(
                  registerWithEmailAndPassword: RegisterWithEmailAndPassword(
                      authenticationRepository: authenticationRepository),
                )),
      ],
      child: Consumer<ThemeService>(builder: ((context, themeService, child) {
        return MaterialApp.router(
          title: 'Todo App',
          /*
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
          ]
           */
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          themeMode:
              themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          //!  routes
          routerConfig: routes,
        );
      })),
    );
  }
}
