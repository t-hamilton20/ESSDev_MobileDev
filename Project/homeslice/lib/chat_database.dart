// File containing methods for chat functionality

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
var currentUser = FirebaseAuth.instance.currentUser;

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

Future<QuerySnapshot<Object?>> getAllConversations(currentPerson) async {
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
