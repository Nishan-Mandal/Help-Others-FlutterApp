import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class DatabaseMethods {
  // getUserByUsername(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("name", isEqualTo: username)
  //       .get();
  // }

  uploadUserInfoPhoneNumberAndUid(userMap) {
    FirebaseFirestore.instance.collection("user_account").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfoNameAndEmailAndPhoto(String userName,String userEmail,String userPhoto) {
    FirebaseFirestore.instance.collection("user_account").where("uid",isEqualTo: FirebaseAuth.instance.currentUser.uid).where("name",isEqualTo: userName).where("email",isEqualTo: userEmail).where("photo",isEqualTo: userPhoto);
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
