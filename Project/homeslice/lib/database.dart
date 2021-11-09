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

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> addUser(name, email, minHousemates, maxHousemates, minPrice,
    maxPrice, coed, minDist, maxDist) {
  return firestore.collection("users").add({
    'full_name': name,
    'email': email,
    'minHousemates': minHousemates,
    'maxHousemates': maxHousemates,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'minDist': minDist,
    'maxDist': maxDist,
    'coed': coed,
    'likedUsers': [],
    'matchedUsers': []
  });
}

Future<QuerySnapshot> getUsers(currentUserID) async {
  Map<String, dynamic> currentUser =
      (await firestore.collection("users").doc(currentUserID).get()).data()
          as Map<String, dynamic>;

  return firestore
      .collection("users")
      .where("minHousemates",
          isGreaterThanOrEqualTo: currentUser['minHousemates'])
      .where("minHousemates", isLessThanOrEqualTo: currentUser['maxHousemates'])
      .where("minPrice", isGreaterThanOrEqualTo: currentUser['minPrice'])
      .where("minPrice", isLessThanOrEqualTo: currentUser['maxPrice'])
      .where("minDist", isGreaterThanOrEqualTo: currentUser['minDist'])
      .where("minDist", isLessThanOrEqualTo: currentUser['maxDist'])
      .where("coed", isEqualTo: currentUser['coed'])
      .orderBy("name")
      .limit(50)
      .get();
}

Future likeUser(currentUserID, likedUserID) async {
  List likedUsers =
      (await firestore.collection('users').doc(currentUserID).get())
          .data()['likedUsers'];

  likedUsers.add(likedUserID);

  return firestore
      .collection('users')
      .doc(currentUserID)
      .update({'likedUsers': likedUsers});
}
