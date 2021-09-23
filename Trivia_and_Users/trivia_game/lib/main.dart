import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Database.dart';

class triviaApp extends StatefulWidget {
  const triviaApp({Key? key}) : super(key: key);

  @override
  _triviaAppState createState() => _triviaAppState();
}

final databaseReference = FirebaseDatabase.instance.reference();

class _triviaAppState extends State<triviaApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trivia Game!"),
        ),
        body: new Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
        ));
  }
}

void createData(String username, int highscore) {
  databaseReference
      .child("$username")
      .set({'name': '$username', 'highscore': '$highscore'});
}
