/* create new account
*  Last updated 2021-11-02 by Tom
*
* Includes:
* Get_User_Details
* Confirm_Password
* Verify_Email
* Go_to_Setup
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool isObscure = true;

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
              // email field
              new TextField(
                controller: emailController,
                style: TextStyle(fontSize: 20),
                decoration: new InputDecoration(
                    labelText: "Email", hintText: "Enter your email"),
                onSubmitted: (String emailInput) {
                  setState(() {});
                },
              ),

              new SizedBox(
                height: 40,
              ),

              // password field
              new TextField(
                controller: passwordController,
                style: TextStyle(fontSize: 20),
                obscureText: isObscure,
                decoration: new InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )),
                onSubmitted: (String passwordInput) {
                  setState(() {});
                },
              ),

              new SizedBox(
                height: 40,
              ),

              // confirm field
              new TextField(
                controller: confirmController,
                style: TextStyle(fontSize: 20),
                obscureText: isObscure,
                decoration: new InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Confirm password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )),
                onSubmitted: (String confirmPasswordInput) {
                  setState(() {});
                },
              ),

              new SizedBox(
                height: 40,
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor,
                    fixedSize: Size(100, 50),
                    textStyle: TextStyle(fontSize: 20)),
                child: Text("Signup"),
                onPressed: () async {
                  if (confirmController.text != passwordController.text) {
                    print("Error, passwords do not match");
                  } else {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        _buildPopupDialog(context, "Password is too weak.");
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        _buildPopupDialog(context,
                            "An account already exists for that email.");
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {});
                  }
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
