
import 'package:flutter/material.dart';

//   ThemeService service will manage the state of the theme

class ThemeService extends ChangeNotifier {
  bool isDarkModeOn = false;
  void toggleTheme() {
    isDarkModeOn = !isDarkModeOn;
    notifyListeners();
  }
  getTheme() => isDarkModeOn;
}
