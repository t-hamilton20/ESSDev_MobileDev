//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:homeslice/login.dart';
import 'package:homeslice/signup.dart';
import 'package:homeslice/setup.dart';

// This code runs the app and navigates between pages

void main() {
  String theme = "dark";
  runApp(new MaterialApp(
      routes: {
        '/login': (context) => login(),
        '/signup': (context) => signup(),
        //'/swiping': (context) => homeSwipe(),
        //'/setup': (context) => setup()
      },
      theme: ThemeData(
          primaryColor: Colors.grey[1000],
          secondaryHeaderColor: Colors.grey[750],
          brightness: Brightness.dark),
      home: new login()));
}

class homeSwipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
