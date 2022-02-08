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
      .collection("Messages")
      .add({
    'message': message,
    'date': date,
    'time': time,
    'sender': senderID,
  });
}

Future<QuerySnapshot<Object?>> getMessages(conversationID) async {
  // call this function to get all the messages in a given conversation
  QuerySnapshot messages = await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("Messages")
      .orderBy("Date") // order first by date sent
      .orderBy("Time") // order second by time sent
      .get();

  return messages;
}

Future<List> getConversationsForUser(String uid) async {
  List<ConversationTile> conversationsFromDatabase = [];
  QuerySnapshot database_conversations =
      await getAllConversations(uid); // get all conversations

  for (var doc in database_conversations.docs) {
    // loop through each conversation
    String otherUserID = "";
    String convoID = doc.id.toString().trim(); // get convo ID
    print("convo ID: " + doc.id.toString());

    if (await doc.get("Users")[0] == uid) {
      // get the other user ID
      otherUserID = await doc.get("Users")[1];
    } else {
      otherUserID = await doc.get("Users")[0];
    }
    print("Received other user ID: " + otherUserID);
    otherUserID = otherUserID.trim();
    Map otherUser = (await getUser(otherUserID)).data() as Map<String, dynamic>;
    conversationsFromDatabase.add(new ConversationTile(
        name: otherUser["full_name"],
        messageText: "test",
        imageUrl: otherUser["image"],
        time: "4:20",
        convoID: convoID,
        isMessageRead: true));
  }
  ;

  print("tiles being passed: " + conversationsFromDatabase.length.toString());
  return conversationsFromDatabase;
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
