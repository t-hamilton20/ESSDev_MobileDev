import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/connection_error.dart';
import 'package:homeslice/login.dart';
import 'package:homeslice/signup.dart';
import 'package:homeslice/setup.dart';

// This code runs the app and navigates between pages

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return ConnectionError();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return new MaterialApp(
            routes: {
              '/login': (context) => Login(),
              '/signup': (context) => Signup(),
              '/swiping': (context) => HomeSwipe(),
              '/setup': (context) => Setup()
            },
            home: new Login(),
          );
        }

        return Loading();
      },
    );
  }
}

class HomeSwipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}