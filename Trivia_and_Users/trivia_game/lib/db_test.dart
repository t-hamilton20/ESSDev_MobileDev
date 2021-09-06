import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int id;
  String email;
  String username;
  int password;

  //Constructor
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  //Convert to Map, names of keys must correspond to database column names
  Map<String, dynamic> toMap(){
    return{
       'id' : id,
       'email': email, 
       'username': username,
       'password': password,
    };
  }

  //Implement ToString to make it easier to see info about each user
  @override
  String toString(){
      return 'User{id: $id, email: $email, username: $username, password: $password}';
  }


}

// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
final database = openDatabase(
  // Set the path to the database
  join(await getDatabasesPath(), 'user_database.db'),
);

final database = openDatabase(
  join(await getDatabasesPath(), 'user_database.db'),

  onCreate: (db, version){
    return db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, username TEXT, password TEXT)'
    );
  },
  version: 1,
)