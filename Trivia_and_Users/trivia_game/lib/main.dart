import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Title of App',
    initialRoute: '/login',
    routes: {
      '/trivia': (context) => TriviaPage(),
      '/login': (context) => LoginPage(),
    },
  ));
}

//class TriviaApp extends MaterialApp{}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  _password = text;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/trivia');
              },
              child: Text('to Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class TriviaPage extends StatelessWidget {
  const TriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('to Page 1'),
        ),
      ),
    );
  }
}
