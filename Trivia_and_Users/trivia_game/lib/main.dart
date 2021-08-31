import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trivia Game"),
      ),
      body: new Padding(
        //used to add space around content
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(height: 20), //added for spacing
              new Image.asset('assets/questionMarks.png'),
              new TextField(
                //textfield for ingredient input
                decoration: new InputDecoration(
                    labelText: "Username", hintText: "Input your username"),
                onSubmitted: (String usernameInput) {
                  setState(() {});
                },
              ),
              new SizedBox(height: 10), //added for spacing
              new TextField(
                //textfield for amount input
                decoration: new InputDecoration(
                    labelText: "Password", hintText: "Input your password"),
                onSubmitted: (String passwordInput) {
                  setState(() {});
                },
              ),
              new SizedBox(height: 10), //added for spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                child: Text("Login"),
                onPressed: () {
                  setState(() {});
                },
              ),
              new SizedBox(height: 10), //added for spacing
            ],
          ),
        ),
      ),
    );
  }
}
