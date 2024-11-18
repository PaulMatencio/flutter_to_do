import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/2_application/core/routes.dart';
import 'package:todo_app/2_application/core/services/theme_service.dart';
import 'package:todo_app/theme.dart';

class BasicApp extends StatelessWidget {
  const BasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: ((context, themeService, child) {
      return MaterialApp.router(
        title: 'Todo App',
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
        ],
        themeMode: themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        //!  routes
        routerConfig: routes,
      );
    }));
  }
}
