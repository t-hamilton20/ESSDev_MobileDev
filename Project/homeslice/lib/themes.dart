import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;
  late Typography defaultTypography;
  late SharedPreferences prefs;

  ThemeData dark = ThemeData.dark().copyWith();

  ThemeData light = ThemeData.light().copyWith();

  ThemeProvider(bool darkThemeOn) {
    _currentTheme = darkThemeOn ? dark : light;
  }

  Future<void> swapTheme() async {
    prefs = await SharedPreferences.getInstance();

    if (_currentTheme == dark) {
      _currentTheme = light;
      await prefs.setBool("darkTheme", false);
      print("set dark theme to false");
    } else {
      _currentTheme = dark;
      await prefs.setBool("darkTheme", true);
      print("set dark theme to true");
    }

    notifyListeners();
  }

  ThemeData getTheme() => _currentTheme;
}
