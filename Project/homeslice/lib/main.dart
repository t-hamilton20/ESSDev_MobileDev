import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeslice/auth_wrapper.dart';
import 'package:homeslice/connection_error.dart';
import 'package:homeslice/home_swipe.dart';
import 'package:homeslice/login.dart';
import 'package:homeslice/signup.dart';
import 'package:homeslice/setup.dart';
import 'package:homeslice/chat.dart';
import 'package:provider/provider.dart';
import 'package:homeslice/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

// This code runs the app and navigates between pages

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =
      await SharedPreferences.getInstance(); // get instance of prefs
  SharedPreferences.getInstance().then((prefs) {
    var isDark = prefs.getBool("darkTheme") ?? false; // get dark/light pref
    print("is dark: " + isDark.toString());

    return runApp(ChangeNotifierProvider(
      child: App(),
      create: (BuildContext context) =>
          ThemeProvider(isDark), // pass in pref to provider
    ));
  });
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
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
                ),
              ],
              child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                return MaterialApp(
                  theme: themeProvider.getTheme(), // get theme from provider
                  routes: {
                    '/login': (context) => Login(),
                    '/signup': (context) => Signup(),
                    '/home': (context) => Wrapper(),
                    '/setup': (context) => Setup()
                  },
                  home: new AuthWrapper(),
                );
              }));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
