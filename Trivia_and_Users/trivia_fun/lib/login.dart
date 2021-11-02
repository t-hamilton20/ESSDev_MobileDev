import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(routes: {
    '/login': (context) => login(),
    //  '/game': (context) => ()
  }, home: new login()));
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trivia Game!"),
      ),
      body: new Padding(
        //used to add space around content
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(height: 20), //added for spacing
              new TextField(
                //textfield for username input
                decoration: new InputDecoration(
                    labelText: "Username", hintText: "Enter your username"),
              ),
              new SizedBox(height: 10), //added for spacing
              new TextField(
                //textfield for password input
                decoration: new InputDecoration(
                    labelText: "Password", hintText: "Enter your password"),
              ),
              new SizedBox(height: 10), //added for spacing
              new SizedBox(height: 10), //added for spacing

              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                onPressed: () {},
                child: Text("Log In"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
