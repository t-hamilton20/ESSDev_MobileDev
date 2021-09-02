//import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(TriviaApp());
}

class TriviaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text on Browser Tab',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Trivia App'),
      ),
      body: Center(
        child: Column(
          children: [
            //Username field
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: const OutlineInputBorder(),
                  focusColor: Colors.blue,
                ),
                //maxLength: 15,
                onChanged: (String text) {
                  _username = text;
                },
                onSubmitted: (String text) {
                  _username = text;
                },
              ),
            ),
            //Password Field
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  focusColor: Colors.blue,
                ),
                //maxLength: 15,
                enableInteractiveSelection: false,
                obscureText: true,
                obscuringCharacter: '•',
                onChanged: (String text) {
                  _password = text;
                },
                onSubmitted: (String text) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TriviaPage(username: _username)));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TriviaPage(username: _username)));
              },
              child: Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}

class TriviaPage extends StatelessWidget {
  final String username;
  TriviaPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Trivia App, ' + username),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('to Login'),
        ),
      ),
    );
  }
}
