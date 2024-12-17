//
//!   lib/theme.dart
//

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//  https://fonts.google.com/
//  ==>    flutter pub add google_fonts
// about Material 3(https://m3.material.io/) and the useMaterial3 flag(https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html)

class AppTheme {
  AppTheme._();

  //static const _primaryColorLight = Colors.lightBlueAccent;
  //static const _primaryColorDark = Colors.lightGreenAccent;
  static const _primaryColorLight = Colors.indigoAccent;
  static const _primaryColorDark = Colors.blueAccent;

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    // Define the default color and brightness
    colorScheme: ColorScheme.fromSeed(seedColor: _primaryColorLight, brightness: Brightness.light),
    textTheme: textTheme(),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(textStyle: TextStyle(fontSize: 16))),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColorDark,
        brightness: Brightness.dark,
      ),
      textTheme: textTheme(),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(textStyle: TextStyle(fontSize: 16))));
}

TextTheme textTheme() {
  //Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  return TextTheme(
    // ···
    titleLarge: GoogleFonts.oswald(
      fontSize: 40,
      fontStyle: FontStyle.normal,
    ),
    titleMedium: GoogleFonts.pacifico(
      fontSize: 32,
      fontStyle: FontStyle.normal,
    ),
    titleSmall: GoogleFonts.oswald(
      fontSize: 20,
      fontStyle: FontStyle.normal,
    ),
    bodySmall: GoogleFonts.merriweather(fontSize: 12),
    bodyMedium: GoogleFonts.merriweather(fontSize: 16),
    bodyLarge: GoogleFonts.merriweather(fontSize: 20),
    displayLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.pacifico(fontSize: 18),
  );
}

TextTheme textThemeLato() {
  return TextTheme(
    displayLarge: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 40.0)),
    displayMedium: GoogleFonts.lato(fontSize: 20.0),
    displaySmall: GoogleFonts.lato(fontSize: 16.0),
  );
}
