/* implementation of database using Firestore
*  Last updated 2021-11-02 by Josh Friedman
*
* Includes:
* addUser
* getUsers
* editUserDetails
* createGroup
* editGroup
* deleteGroup
* likeUser
*/

import 'dart:math';

import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> addConversation(PersonA, PersonB) {
  return firestore
      .collection("conversations")
      .add({'PersonA': PersonA, 'PersonB': PersonB});
}

Future<void> addMessage(message, date, time, sender, read, conversationID) {
  return firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("messages")
      .add({
    'messsage': message,
    'date': date,
    'time': time,
    'sender': sender,
    'read': read
  });
}
