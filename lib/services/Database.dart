import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/MessageScren.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:intl/intl.dart';

class DatabaseMethods {
  uploadUserInfo(String name, String mobileNumber, String photo, String uid) {
    FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .set({
      "name": name,
      "mobile_number": mobileNumber,
      "photo": photo,
      "uid": uid
    }).catchError((e) {
      print(e.toString());
    });
  }

  uploadTicketInfo(
    String title,
    String description,
    bool shareMobile,
    String ticketOwnerMobile,
    double latitude,
    double longitude,
    String uplodedPhoto,
    String category,
  ) {
    var ref = FirebaseFirestore.instance.collection("global_ticket").doc();
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    var now = new DateTime.now();
    var current_mon = now.month - 1;
    String date = months[current_mon] + " " + now.day.toString();

    return ref.set({
      "title": title,
      "description": description,
      "time": DateTime.now().millisecondsSinceEpoch,
      "share_mobile": false,
      "ticket_owner": ticketOwnerMobile,
      "latitude": latitude,
      "longitude": longitude,
      "id": ref.id,
      "uplodedPhoto": uplodedPhoto,
      "category": category,
      "date": date,
    }).catchError((e) {
      print(e.toString());
    });
  }

  // updateTicketInfo(String ticketDocumentId, String title, String description,
  //     bool is_reviewed, String ticket_owner) {
  //   DateTime now = new DateTime.now();
  //   DateTime date = new DateTime(now.year, now.month, now.day);
  //   var ref = FirebaseFirestore.instance
  //       .collection("global_ticket")
  //       .doc("$ticketDocumentId");

  //   FirebaseFirestore.instance
  //       .collection("global_ticket")
  //       .doc("$ticketDocumentId")
  //       .collection("responses")
  //       .get()
  //       .then((value) => {
  //             value.docs.forEach((doc) {
  //               FirebaseFirestore.instance
  //                   .collection("global_ticket")
  //                   .doc("$ticketDocumentId")
  //                   .collection("responses")
  //                   .doc(doc.id)
  //                   .delete();
  //             })
  //           });

  //   return ref.update({
  //     "title": title,
  //     "description": description,
  //     "time": DateTime.now().millisecondsSinceEpoch,
  //     "share_mobile_number": false,
  //     "ticket_owner": ticket_owner,
  //     "id": ref.id,
  //     "date": date,
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }

  deleteTicket(
    String ticketDocumentId,
  ) {
    var delete = FirebaseFirestore.instance
        .collection("global_ticket")
        .doc(ticketDocumentId);
    var deleteMessages =
        FirebaseFirestore.instance.collection("messages").doc(ticketDocumentId);

    delete.delete();
    deleteMessages.delete();
  }

  uploadTicketResponse(
    String comment,
    String ticketDocumentId,
    bool share_mobile,
    String ticket_creater_mobile,
    bool responded,
    String ownerPic,
    String ticketTitle,
    String lastMessage,
  ) async {
    var ref = FirebaseFirestore.instance
        .collection("global_ticket")
        .doc("$ticketDocumentId")
        .collection("responses")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber);

    var messages1 =
        FirebaseFirestore.instance.collection("messages").doc(ticketDocumentId);
    var messages2 = messages1.collection('chats').doc();

    String photo;
    var responder = await FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((value) {
      photo = value.get("photo");
    });

    ref.set({
      "comment": comment,
      "ticket_unique_id": ticketDocumentId,
      "share_mobile": share_mobile,
      "ticket_owner_mobile": ticket_creater_mobile,
      "utr_mobile": FirebaseAuth.instance.currentUser.phoneNumber,
      "id": ref.id,
      "responded": responded,
    }).catchError((e) {
      print(e.toString());
    });
    // Future.delayed(const Duration(milliseconds: 300), () {
    messages1.set({
      "responderNumber": FirebaseAuth.instance.currentUser.phoneNumber,
      "ticket_creater_mobile": ticket_creater_mobile,
      "id": messages1.id,
      "ticketId": ticketDocumentId,
      "lastMessage": lastMessage,
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
      "participants": FieldValue.arrayUnion(
        [
          "$ticket_creater_mobile",
          "${FirebaseAuth.instance.currentUser.phoneNumber}"
        ],
      ),
      "ownerMessageSeen": false,
      "responderMessageSeen": false,
      "ownerPic": ownerPic,
      "responderPic": photo,
      "ticketTitle": ticketTitle,
    }).catchError((e) {
      print(e.toString());
    });
    // });
    DateTime now = DateTime.now();
    String time = "${now.hour}:${now.minute}";
    messages2.set({
      "message": lastMessage,
      "sender": FirebaseAuth.instance.currentUser.phoneNumber,
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
      "messageSentTime": time,
    }).catchError((e) {
      print(e.toString());
    });
  }

  uploadTicketResponseByCall(
    String comment,
    String ticketDocumentId,
    bool share_mobile,
    String ticket_creater_mobile,
    bool responded,
  ) {
    var ref = FirebaseFirestore.instance
        .collection("global_ticket")
        .doc("$ticketDocumentId")
        .collection("responses")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber);

    ref.set({
      "comment": comment,
      "ticket_unique_id": ticketDocumentId,
      "share_mobile": share_mobile,
      "ticket_owner_mobile": ticket_creater_mobile,
      "utr_mobile": FirebaseAuth.instance.currentUser.phoneNumber,
      "id": ref.id,
      "responded": responded,
    }).catchError((e) {
      print(e.toString());
    });
  }

  chatsInChatRoom(
    String message,
    String docIdInMessageCollection,
    String respnderMobileNumber,
  ) {
    DateTime now = DateTime.now();
    String time = "${now.hour}:${now.minute}";
    var chat = FirebaseFirestore.instance
        .collection("messages")
        .doc(docIdInMessageCollection)
        .collection("chats")
        .doc();
    var data = FirebaseFirestore.instance
        .collection("messages")
        .doc(docIdInMessageCollection);

    chat.set({
      "message": message,
      "sender": FirebaseAuth.instance.currentUser.phoneNumber,
      "timeStamp": now.millisecondsSinceEpoch,
      "messageSentTime": time,
    }).catchError((e) {
      print(e.toString());
    });

    data.update(
      respnderMobileNumber == FirebaseAuth.instance.currentUser.phoneNumber
          ? ({
              "ownerMessageSeen": false,
            })
          : ({"responderMessageSeen": false}),
    );
  }

  // updateMessageSeenStatus(
  //   String docIdInMessageCollection,
  // ) {
  //   var seenStatus = FirebaseFirestore.instance
  //       .collection("messages")
  //       .doc(docIdInMessageCollection)
  //       .collection("chats")
  //       .where("sender",
  //           isNotEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
  //       .orderBy("timeStamp", descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       FirebaseFirestore.instance
  //           .collection("messages")
  //           .doc(docIdInMessageCollection)
  //           .collection("chats")
  //           .doc(element.id)
  //           .update({"seenStatus": true});
  //     });
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }
  countUnseenMessages(String field) {
    int count = 0;
    var data = FirebaseFirestore.instance
        .collection("messages")
        .where("participants",
            arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
        .orderBy("timeStamp", descending: true)
        .limit(1)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.get(field));
        bool x = element.get(field);
        if (x == false) {
          count = count + 1;
        }
      });
    });
    return count;
  }

  updateOwnerMessageSeenStatus(
    String docIdInMessageCollection,
  ) {
    var message = FirebaseFirestore.instance
        .collection("messages")
        .doc(docIdInMessageCollection);
    message.update({"ownerMessageSeen": true}).catchError((e) {
      print(e.toString());
    });
  }

  updateResponderMessageSeenStatus(
    String docIdInMessageCollection,
  ) {
    var message = FirebaseFirestore.instance
        .collection("messages")
        .doc(docIdInMessageCollection);
    message.update({"responderMessageSeen": true}).catchError((e) {
      print(e.toString());
    });
  }

  updataLastChat(String docIdInMessageCollection, String message) {
    var ticket = FirebaseFirestore.instance
        .collection("messages")
        .doc(docIdInMessageCollection);
    ticket.update({
      "lastMessage": message,
      "timeStamp": DateTime.now().microsecondsSinceEpoch
    }).catchError((e) {
      print(e.toString());
    });
  }

  // updateTicketStatus(
  //   String ticketDocumentId,
  //   bool markAsDone,
  // ) {
  //   var ref = FirebaseFirestore.instance
  //       .collection("global_ticket")
  //       .doc("$ticketDocumentId");
  //   return ref.update({"mark_as_done": markAsDone}).catchError((e) {
  //     print(e.toString());
  //   });
  // }

  myFavourites(String ticketId) {
    var ref =
        FirebaseFirestore.instance.collection("global_ticket").doc(ticketId);
    ref.update({
      "favourites": FieldValue.arrayUnion(
        ["${FirebaseAuth.instance.currentUser.phoneNumber}"],
      ),
    });
    // var ref = FirebaseFirestore.instance.collection("myFavourites").doc();
    // return ref.set({
    //   "ticketId": ticketId,
    //   "mobileNumber": mobileNumber,
    //   "isFavourite": true
    // }).catchError((e) {
    //   print(e.toString());
    // });
  }
}
