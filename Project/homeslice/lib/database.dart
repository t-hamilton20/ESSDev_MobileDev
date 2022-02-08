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

import 'dart:io';
import 'dart:math';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

Future<void> addUser(id, name, email, pronouns, major, year, blurb, image,
    minHousemates, maxHousemates, minPrice, maxPrice, coed, minDist, maxDist,
    {tidiness,
    sharingMeals,
    nearWest,
    nightsOut,
    pets,
    northOfPrincess,
    hosting}) async {
  String imgUrl = '';
  try {
    String filename = id + "." + image.name.split(".").last;
    Reference ref = storage.ref(filename);
    if (kIsWeb) {
      await ref.putData(await image.readAsBytes());
    } else {
      await ref.putFile(File(image.path));
    }
    imgUrl = await ref.getDownloadURL();
  } on FirebaseException catch (e) {
    print(e.message);
  }

  return firestore.collection("users").doc(id).set({
    'full_name': name,
    'email': email,
    'pronouns': pronouns,
    'major': major,
    'year': year,
    'blurb': blurb,
    'image': imgUrl,
    'minHousemates': minHousemates,
    'maxHousemates': maxHousemates,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'minDist': minDist,
    'maxDist': maxDist,
    'coed': coed,
    'preferences': {
      'tidiness': tidiness ?? 1, // 1-5
      'sharingMeals': sharingMeals ?? false, // y/n
      'nearWest': nearWest ?? false, // y/n
      'nightsOut': nightsOut ?? 0, // 0-7
      'pets': pets ?? true, // y/n
      'northOfPrincess': northOfPrincess ?? true, // y/n
      'hosting': hosting ?? true // y/n
    },
    'likedUsers': [],
    'matchedUsers': []
  });
}

Future<void> updateUser(id,
    {name,
    email,
    pronouns,
    major,
    year,
    blurb,
    image,
    minHousemates,
    maxHousemates,
    minPrice,
    maxPrice,
    coed,
    minDist,
    maxDist,
    tidiness,
    sharingMeals,
    nearWest,
    nightsOut,
    pets,
    northOfPrincess,
    hosting}) async {
  String? imgUrl;
  if (image != null) {
    try {
      String filename = id + "." + image.name.split(".").last;
      Reference ref = storage.ref(filename);
      if (kIsWeb) {
        await ref.putData(await image.readAsBytes());
      } else {
        await ref.putFile(File(image.path));
      }
      imgUrl = await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  return firestore.collection("users").doc(id).update({
        'full_name': name,
        'email': email,
        'pronouns': pronouns,
        'major': major,
        'year': year,
        'blurb': blurb,
        'image': imgUrl,
        'minHousemates': minHousemates,
        'maxHousemates': maxHousemates,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'minDist': minDist,
        'maxDist': maxDist,
        'coed': coed,
        'preferences': {
          'tidiness': tidiness ?? 1, // 1-5
          'sharingMeals': sharingMeals ?? false, // y/n
          'nearWest': nearWest ?? false, // y/n
          'nightsOut': nightsOut ?? 0, // 0-7
          'pets': pets ?? true, // y/n
          'northOfPrincess': northOfPrincess ?? true, // y/n
          'hosting': hosting ?? true // y/n
        },
      }..removeWhere((key, value) => value == null));
}

Future<DocumentSnapshot> getUser(userID) {
  return firestore.collection("users").doc(userID).get();
}

Future<Map> getUsers(currentUserID) async {
  Map<String, dynamic> currentUser =
      (await getUser(currentUserID)).data() as Map<String, dynamic>;

  QuerySnapshot users = await firestore
      .collection("users")
      .where("coed", isEqualTo: currentUser['coed'])
      // .limit(50)
      .get();

  return Map.fromIterable(users.docs,
      key: (doc) => doc.id, value: (doc) => doc.data())
    ..removeWhere((id, user) => id == currentUserID) // Remove yourself
    ..removeWhere((id, user) => currentUser['likedUsers']
        .any((user) => user.id == id)) // Remove already liked users
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

Future<List> getMatches(currentUserID) async {
  Map<String, dynamic> currentUser =
      (await getUser(currentUserID)).data() as Map<String, dynamic>;
  return currentUser['matchedUsers'];
}

Future likeUser(currentUserID, likedUserID) async {
  DocumentReference me = firestore.collection('users').doc(currentUserID);
  List myLikedUsers =
      (await firestore.collection('users').doc(currentUserID).get())
              .data()?['likedUsers'] ??
          [];
  List myMatchedUsers =
      (await firestore.collection('users').doc(currentUserID).get())
              .data()?['matchedUsers'] ??
          [];
  List theirLikedUsers =
      (await firestore.collection('users').doc(likedUserID).get())
              .data()?['likedUsers'] ??
          [];
  List theirMatchedUsers =
      (await firestore.collection('users').doc(likedUserID).get())
              .data()?['matchedUsers'] ??
          [];

  if (theirLikedUsers.contains(me)) {
    // It's a Match!
    myMatchedUsers.add(
        firestore.collection('users').doc(likedUserID)); // Add to my matched
    theirLikedUsers.remove(me); // Remove from their liked
    theirMatchedUsers.add(me); // Add to their matched

    return Future.wait([
      firestore
          .collection('users')
          .doc(currentUserID)
          .update({'matchedUsers': myMatchedUsers}), // Update my matched users
      firestore
          .collection('users')
          .doc(likedUserID)
          .update({'likedUsers': theirLikedUsers}), // Update their liked users
      firestore.collection('users').doc(likedUserID).update(
          {'matchedUsers': theirMatchedUsers}) // Update their matched users
    ]);
  } else {
    // Better luck next time :(
    myLikedUsers
        .add(firestore.collection('users').doc(likedUserID)); // Add to my liked

    return firestore
        .collection('users')
        .doc(currentUserID)
        .update({'likedUsers': myLikedUsers});
  }
}
