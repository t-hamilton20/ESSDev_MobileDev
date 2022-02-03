// File containing methods for chat functionality

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
var currentUser = FirebaseAuth.instance.currentUser;

Future<DocumentReference<Map<String, dynamic>>> addConversation(
    currentPersonID, otherUserID) async {
  // call this function when two people swipe on each other
  return await firestore.collection("conversations").add({
    "Users": [currentPersonID, otherUserID]
  });
}

Future<String> getConversation(currentPersonID, otherUserID) async {
  QuerySnapshot convo = await firestore
      .collection("conversations")
      .where("Users", arrayContains: currentPersonID)
      .where("Users", arrayContains: otherUserID)
      .get();

  // QuerySnapshot messages = await firestore
  //     .collection("conversations")
  //     .doc(conversationID)
  //     .collection("messages")
  //     .orderBy("date") // order first by date sent
  //     .orderBy("time") // order second by time sent
  //     .get();

  // return messages;

  return await convo.docs[0].id; // returns conversation ID
}

Future<QuerySnapshot<Object?>> getAllConversations(currentPersonID) async {
  // call this function in chat.dart to get all the conversations the user has
  QuerySnapshot convos = await firestore
      .collection("conversations")
      .where("Users", arrayContains: currentPersonID)
      .get();

  return await convos;
}

Future sendMessage(message, date, time, senderID, read, conversationID) async {
  // call this function in conversation.dart to send a message
  return await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("messages")
      .add({
    'message': message,
    'date': date,
    'time': time,
    'sender': senderID,
    'read': read
  });
}

Future<QuerySnapshot<Object?>> getMessages(conversationID) async {
  // call this function to get all the messages in a given conversation
  QuerySnapshot messages = await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("messages")
      .orderBy("date") // order first by date sent
      .orderBy("time") // order second by time sent
      .get();

  return messages;
}
