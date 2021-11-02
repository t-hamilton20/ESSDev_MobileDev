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

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
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
              new TextField(
                style: TextStyle(fontSize: 20),
                //textfield for email input
                decoration: new InputDecoration(
                    labelText: "Email", hintText: "Enter your email"),
                onSubmitted: (String emailInput) {
                  setState(() {});
                },
              ),
              new SizedBox(
                height: 40,
              ),
              new TextField(
                style: TextStyle(fontSize: 20),
                //textfield for password input
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
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).secondaryHeaderColor,
                    fixedSize: Size(100, 50),
                    textStyle: TextStyle(fontSize: 20)),
                child: Text("Login"),
                onPressed: () {
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
