library config.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  static bool _isDark = false;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool getTheme() {
    return _isDark;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

ThemeNotifier currentTheme = ThemeNotifier();

ThemeData _darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dividerColor: Colors.black12,
);

ThemeData _lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  dividerColor: Colors.white54,
);

ThemeData getDarkTheme() {
  return _darkTheme;
}

ThemeData getLightTheme() {
  return _lightTheme;
}

// class DynamicTheme with ChangeNotifier {
//   ThemeData _darkTheme = ThemeData(
//     primarySwatch: Colors.grey,
//     primaryColor: Colors.black,
//     brightness: Brightness.dark,
//     backgroundColor: const Color(0xFF212121),
//     dividerColor: Colors.black12,
//   );

//   ThemeData _lightTheme = ThemeData(
//     primarySwatch: Colors.grey,
//     primaryColor: Colors.white,
//     brightness: Brightness.light,
//     backgroundColor: const Color(0xFFE5E5E5),
//     dividerColor: Colors.white54,
//   );

//   ThemeData getDarkTheme() {
//     return _darkTheme;
//   }

//   ThemeData getLightTheme() {
//     return _lightTheme;
//   }

//   // ChangeNotifier : will provide a notifier for any changes in the value to all it's listeners
//   bool isDarkMode = false;
//   getDarkMode() => this.isDarkMode;

//   void changeDarkMode() {
//     this.isDarkMode = !this.isDarkMode;
//     notifyListeners(); // Notify all it's listeners about update. If you comment this line then you will see that new added items will not be reflected in the list.
//   }
// }
