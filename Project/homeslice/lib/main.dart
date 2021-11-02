import 'dart:html';

import 'package:flutter/material.dart';
import 'package:homeslice/login.dart';
import 'package:homeslice/signup.dart';
import 'package:homeslice/setup.dart';

// This code runs the app and navigates between pages

void main() {
  runApp(new MaterialApp(routes: {
    '/login': (context) => login(),
    '/signup': (context) => signup(),
    '/swiping': (context) => homeSwipe(),
    '/setup': (context) => setup()
  }, home: new login()));
}

class homeSwipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
