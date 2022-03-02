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

Future sendMessage(
    message, timestamp, senderID, int milli, read, conversationID) async {
  // call this function in conversation.dart to send a message

  print("sending message sent by " +
      senderID.toString() +
      " into " +
      conversationID.toString());

  print("milli: " + DateTime.now().millisecondsSinceEpoch.toString());
  return await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("Messages")
      .add({
    'Text': message,
    'Timestamp': timestamp,
    'Sender': senderID,
    'Milli': milli,
  });
}

Future<QuerySnapshot<Object?>> getMessages(conversationID) async {
  // call this function to get all the messages in a given conversation
  QuerySnapshot messages = await firestore
      .collection("conversations")
      .doc(conversationID)
      .collection("Messages")
      .orderBy("Milli")
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

    QuerySnapshot messages = await firestore
        .collection("conversations")
        .doc(convoID)
        .collection("Messages")
        .orderBy("Milli")
        .get();

    DocumentSnapshot lastMessage = messages.docs.last;
    String lastMessageText = lastMessage["Text"];
    if (lastMessageText.length > 50) {
      lastMessageText = lastMessageText.substring(0, 50) + "...";
    }

    conversationsFromDatabase.add(new ConversationTile(
        name: otherUser["full_name"],
        messageText: lastMessageText,
        imageUrl: otherUser["image"],
        time: lastMessage["Timestamp"],
        convoID: convoID));
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

Future<DocumentSnapshot> getLastMessage(String convoID) async {
  QuerySnapshot messages = await firestore
      .collection("conversations")
      .doc(convoID)
      .collection("Messages")
      .orderBy("Milli")
      .get();

  DocumentSnapshot lastMessage = messages.docs.last;
  print("\nLast message: " + lastMessage["Text"]);
  return lastMessage;
}

Future<String> getLastMessageText(String convoID) async {
  QuerySnapshot messages = await firestore
      .collection("conversations")
      .doc(convoID)
      .collection("Messages")
      .orderBy("Milli")
      .get();

  DocumentSnapshot lastMessage = messages.docs.last;
  print("\nLast message: " + lastMessage["Text"]);
  return lastMessage["Text"];
}
