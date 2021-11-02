/* implementation of databse using Firestore
*  Last updated YYYY-MM-DD by NAME
*
* Includes:
* Get_Users
* Add_User
* Edit_User_Details
* Create_Group
* Edit_Group
* Delete_Group
* Like_User
*/

import "package:firebase_auth/firebase_auth.dart";
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
