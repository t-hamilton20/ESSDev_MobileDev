// File containing methods for chat functionality

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

import 'chat.dart';
import 'database.dart';

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

Future<List> getConversationsForUser(String uid) async {
  var conversationsFromDatabase = [];
  QuerySnapshot database_conversations =
      await getAllConversations(uid); // get all conversations

  database_conversations.docs.forEach((res) async {
    String otherUserID = "";
    if (res.get("Users")[0] == uid) {
      otherUserID = await res.get("Users")[1];
    } else {
      otherUserID = await res.get("Users")[0];
    }

    DocumentSnapshot otherUser = await getUser(otherUserID);

    conversationsFromDatabase.add(await ConversationTile(
        //name: otherUser.get("full_name"),
        name: "testing",
        messageText: "test",
        imageUrl:
            "data:image/jpeg;base64,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",
        time: "4:20",
        isMessageRead: true));
  });

  return await conversationsFromDatabase;
}

Future<List> getConversationsListForUser(String uid) async {
  var conversationsFromDatabase = [];
  QuerySnapshot database_conversations =
      await getAllConversations(uid); // get all conversations

  database_conversations.docs.forEach((res) async {
    String otherUserID = "";
    if (res.get("Users")[0] == uid) {
      otherUserID = await res.get("Users")[1];
    } else {
      otherUserID = await res.get("Users")[0];
    }

    conversationsFromDatabase.add(otherUserID);
  });

  return await conversationsFromDatabase;
}
