/* log user in to existing account
*  Last updated 2021-11-02 by Tom
*
* Includes:
* Get_Login_Details
* Forgot_Password
* Send_to_Signup
*/

import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // credential variables
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("HomeSlice"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: new Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(
                height: 20,
              ),

              //textfield for email input
              new TextField(
                controller: emailController,
                style: TextStyle(fontSize: 20),
                decoration: new InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                      color: Theme.of(context).secondaryHeaderColor,
                    ))),
                onSubmitted: (String emailInput) {
                  setState(() {});
                },
              ),

              new SizedBox(
                height: 40,
              ),

              // textfield for password input
              new TextField(
                controller: passwordController,
                style: TextStyle(fontSize: 20),
                decoration: new InputDecoration(
                    labelText: "Password", hintText: "Enter your password"),
                onSubmitted: (String passwordInput) {
                  setState(() {});
                },
              ),

              new SizedBox(
                height: 40,
              ),

              ElevatedButton(
                // login button
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor,
                    fixedSize: Size(100, 50),
                    textStyle: TextStyle(fontSize: 20)),
                child: Text("Login"),
                onPressed: () async {
                  print("email: " +
                      emailController.text +
                      "\npassword: " +
                      passwordController.text);
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      _buildPopupDialog(
                          context, "No user found for that email.");
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      _buildPopupDialog(context, "Incorrect password.");
                      print('Wrong password provided for that user.');
                    }
                  }
                  setState(() {});
                },
              ),

              SizedBox(
                height: 120,
              ),

              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 20),
              ),

              new SizedBox(
                height: 40,
              ),

              ElevatedButton(
                // button to push signup page onto stack
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor,
                    fixedSize: Size(100, 50),
                    textStyle: TextStyle(fontSize: 20)),
                child: Text("Signup"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signup()),
                  );
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context, String message) {
  return new AlertDialog(
    title: const Text('Error'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("message"),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}
