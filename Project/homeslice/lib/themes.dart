import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;
  late bool themeBool;
  late SharedPreferences prefs;

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0x1A1A40),
    textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
  ); // light theme (change later)

  ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    backgroundColor: Colors.purple[900],
    // buttonTheme: ButtonThemeData(
    //   colorScheme: ColorScheme(brightness: light, primary: Colors.blue, onPrimary: Colors.white, secondary: Colors.blueAccent, onSecondary: Colors.white,
    //   error: Colors.red, onError: Colors.white, background: Colors.blue, onBackground: Colors.white, surface: Colors.blue, onSurface: Colors.white)
    // ),
    textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
  ); // light theme (change later)

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
