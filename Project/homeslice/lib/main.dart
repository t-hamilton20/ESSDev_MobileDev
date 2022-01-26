import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/connection_error.dart';
import 'package:homeslice/home_swipe.dart';
import 'package:homeslice/login.dart';
import 'package:homeslice/signup.dart';
import 'package:homeslice/setup.dart';
import 'package:homeslice/chat.dart';
import 'package:provider/provider.dart';
import 'package:homeslice/wrapper.dart';

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
      future: Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyBmPxbSERmf9fmaWvfvWc3RrTCWPiPLDHc",
              authDomain: "homeslice-399ef.firebaseapp.com",
              projectId: "homeslice-399ef",
              storageBucket: "homeslice-399ef.appspot.com",
              messagingSenderId: "1061489396014",
              appId: "1:1061489396014:web:f0bf01b0cac060ccc392bf",
              measurementId: "G-ZZHCVN3EZL")),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print("SNAPSHOT ERROR: " + snapshot.error.toString());
          return MaterialApp(home: ConnectionError());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
              providers: [
                StreamProvider<User?>.value(
                  value: FirebaseAuth.instance.authStateChanges(),
                  initialData: null,
                )
              ],
              child: MaterialApp(
                theme: ThemeData(
                    primaryColor: Colors.grey[1000],
                    secondaryHeaderColor: Colors.grey[750],
                    brightness: Brightness.dark),
                routes: {
                  '/login': (context) => Login(),
                  '/signup': (context) => Signup(),
                  '/home': (context) => Wrapper(),
                  '/setup': (context) => Setup()
                },
                home: new Login(),
              ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
