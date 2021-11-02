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

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
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
              new TextField(
                style: TextStyle(fontSize: 20),
                //textfield for confirm password input
                decoration: new InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Confirm password"),
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
                onPressed: () {
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
