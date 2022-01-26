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

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
var currentUser = FirebaseAuth.instance.currentUser;

void test() {
  print(FirebaseAuth.instance.currentUser.toString());
}

Future<void> addConversation(currentPerson, otherUser) {
  // call this function when two people swipe on each other
  return firestore
      .collection("conversations")
      .add({'currentPerson': currentUser, 'otherUser': otherUser});
}

Future<String> getConversation(currentPerson, otherUser) async {
  QuerySnapshot convo = await firestore
      .collection("conversations")
      .where("currentPerson", isEqualTo: currentUser)
      .where("otherUser", isEqualTo: otherUser)
      .get();

  return convo.docs[0].id;
}

Future getAllConversations(currentPerson) async {
  // call this function in chat.dart to get all the conversations the user has
  QuerySnapshot convos = await firestore
      .collection("conversations")
      .where("currentPerson", isEqualTo: currentUser)
      .get();

  return convos;
}

Future sendMessage(message, date, time, sender, read, conversationID) async {
  // call this function in conversation.dart to send a message
  return await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("messages")
      .add({
    'message': message,
    'date': date,
    'time': time,
    'sender': sender,
    'read': read
  });
}

Future<QuerySnapshot<Object?>> getMessages(conversationID) async {
  // call this function in conversation.dart to send a message
  QuerySnapshot messages = await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("messages")
      .orderBy("date")
      .get();

  return messages;
}

// Future<Map> getMessages(conversationID) async {
//   QuerySnapshot messages = await firestore
//       .collection("conversations")
//       .doc(conversationID)
//       .collection("messages")
//       .get();

//   return Map.fromIterable(messages.docs,
//       key: (doc) => doc.id, value: (doc) => doc.data());
// }
