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

Future<void> addMessage(message, date, time, sender, receiver) {
  return firestore.collection("messages").add({
    'messsage': message,
    'date': date,
    'time': time,
    'sender': sender,
    'receiver': receiver,
  });
}

Future<Map> getUsers(currentUserID) async {
  Map<String, dynamic> currentUser =
      (await firestore.collection("users").doc(currentUserID).get()).data()
          as Map<String, dynamic>;

  QuerySnapshot users = await firestore
      .collection("users")
      .where("coed", isEqualTo: currentUser['coed'])
      // .limit(50)
      .get();

  return Map.fromIterable(users.docs,
      key: (doc) => doc.id, value: (doc) => doc.data())
    ..removeWhere((id, user) => id == currentUserID)
    ..removeWhere((id, user) =>
        max<num>(currentUser['minHousemates'], user['minHousemates']) >
        min(currentUser['maxHousemates'], user['maxHousemates']))
    ..removeWhere((id, user) =>
        max<num>(currentUser['minPrice'], user['minPrice']) >
        min(currentUser['maxPrice'], user['maxPrice']))
    ..removeWhere((id, user) =>
        max<num>(currentUser['minDist'], user['minDist']) >
        min(currentUser['maxDist'], user['maxDist']));
}

Future likeUser(currentUserID, likedUserID) async {
  List likedUsers =
      (await firestore.collection('users').doc(currentUserID).get())
          .data()?['likedUsers'];

  likedUsers.add(firestore.collection('users').doc(likedUserID));

  return firestore
      .collection('users')
      .doc(currentUserID)
      .update({'likedUsers': likedUsers});
}
