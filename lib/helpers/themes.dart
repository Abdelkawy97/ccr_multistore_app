import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme => ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
        fontFamily: 'Cairo',
      );

  static ThemeData get darkTheme => ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        fontFamily: 'Cairo',
      );
}
