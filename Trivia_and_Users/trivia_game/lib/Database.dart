import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void createData(String username, int highscore) {
  databaseReference
      .child("$username")
      .set({'name': '$username', 'highscore': '$highscore'});
}
