import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/chat.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print("SNAPSHOT ERROR: " + snapshot.error.toString());
          return ConnectionError();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return new MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.grey[1000],
                secondaryHeaderColor: Colors.grey[750],
                hintColor: Colors.grey[800],
                brightness: Brightness.dark),
            routes: {
              //'/login': (context) => Login(),
              //'/signup': (context) => Signup(),
              //'/swiping': (context) => HomeSwipe(),
              //'/setup': (context) => Setup()
            },
            //home: new Login(),
            home: new Messages(),
          );
        }
        return new Container();
        //return Loading();
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
