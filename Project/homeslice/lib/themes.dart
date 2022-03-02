library config.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  static bool _isDark = false;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool getTheme() {
    // dynamic currentTheme = await StorageManager.readData("isDark");
    // if (currentTheme.toString() == "null") {
    //   StorageManager.storeData("isDark", true);
    // }
    // print(currentTheme.toString());
    return _isDark;
  }

  Future<dynamic> getSavedTheme() async {
    dynamic currentTheme = await StorageManager.readData("isDark");
    if (currentTheme.toString() == "null") {
      print("testing theme");
      StorageManager.storeData("isDark", true);
      currentTheme = true;
    }

    return currentTheme;
  }

  void switchTheme() {
    _isDark = !_isDark;
    //StorageManager.storeData("isDark", _isDark);
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

class StorageManager {
  static Future<void> storeData(String key, dynamic value) async {
    final preferences = await SharedPreferences.getInstance();
    if (value is int) {
      preferences.setInt(key, value);
    } else if (value is String) {
      preferences.setString(key, value);
    } else if (value is bool) {
      preferences.setBool(key, value);
    } else {
      print("Error. Invalid Type.");
    }
  }

  static Future<dynamic> readData(String key) async {
    final preferences = await SharedPreferences.getInstance();
    dynamic returnObj = preferences.get(key);
    return returnObj;
  }
}
