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
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  //Implement ToString to make it easier to see info about each user
  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username, password: $password}';
  }
}
