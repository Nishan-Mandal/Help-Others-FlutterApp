import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DatabaseMethods {
  // getUserByUsername(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("name", isEqualTo: username)
  //       .get();
  // }

  // uploadUserInfo(userMap) {
  //   FirebaseFirestore.instance
  //       .collection("user_account")
  //       .add(userMap)
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }
  uploadUserInfo(String name, String mobileNumber, String email, String photo,
      String uid) {
    FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .set({
      "name": name,
      "mobile_number": mobileNumber,
      "email": email,
      "photo": photo,
      "uid": uid
    });
  }

  uploadTicketInfo(titleMap) {
    FirebaseFirestore.instance
        .collection("global_ticket")
        .add(titleMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
