import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;
  late bool themeBool;
  late SharedPreferences prefs;

  ThemeData dark = ThemeData.dark().copyWith(); // dark theme (change later)

  ThemeData light = ThemeData.light().copyWith(); // light theme (change later)

  ThemeProvider(bool darkThemeOn) {
    _currentTheme = darkThemeOn ? dark : light;
    themeBool = darkThemeOn;
  }

  Future<void> swapTheme() async {
    prefs = await SharedPreferences.getInstance(); // get instance of prefs

    if (_currentTheme == dark) {
      _currentTheme = light;
      themeBool = false;
      await prefs.setBool("darkTheme", false); // set pref
      print("set dark theme to false");
    } else {
      _currentTheme = dark;
      themeBool = true;
      await prefs.setBool("darkTheme", true); // set pref
      print("set dark theme to true");
    }

    notifyListeners();
  }

  bool getThemeBool() {
    return themeBool;
  }

  ThemeData getTheme() => _currentTheme;
}
