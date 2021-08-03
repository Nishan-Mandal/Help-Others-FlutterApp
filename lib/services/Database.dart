import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  DateTime now = DateTime.now();
  uploadUserInfo(String name, String mobileNumber, String photo, String uid,
      bool acceptAllTermsAndConditions, bool iam18Plus) {
    FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .set({
      "name": name,
      "mobile_number": mobileNumber,
      "photo": photo,
      "uid": uid,
      "accepted_all_terms_and_conditions": acceptAllTermsAndConditions,
      "i'm_18+": iam18Plus,
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
    var address,
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

    var current_mon = now.month - 1;
    String date = months[current_mon] + " " + now.day.toString();

    return ref.set({
      "title": title,
      "description": description,
      "time": now.microsecondsSinceEpoch,
      "share_mobile": shareMobile,
      "ticket_owner": ticketOwnerMobile,
      "latitude": latitude,
      "longitude": longitude,
      "id": ref.id,
      "uplodedPhoto": uplodedPhoto,
      "category": category,
      "date": date,
      "address": address,
    }).catchError((e) {
      print(e.toString());
    });
  }

  deleteAccount(String reasonForDeletingAc) async {
    var ref = FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber);
    ref.delete();

    FirebaseFirestore.instance
        .collection("global_ticket")
        .where("ticket_owner",
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((value) => {
              value.docs.forEach((doc) async {
                await FirebaseFirestore.instance
                    .collection("global_ticket")
                    .doc(doc.id)
                    .collection("responses")
                    .doc()
                    .delete();
                await FirebaseStorage.instance
                    .refFromURL(doc.get("uplodedPhoto"))
                    .delete();
                await FirebaseFirestore.instance
                    .collection("global_ticket")
                    .doc(doc.id)
                    .delete();
              })
            });

    var folder = FirebaseAuth.instance.currentUser.phoneNumber;
    await FirebaseStorage.instance.ref('$folder/user_profile_image').delete();
    await FirebaseFirestore.instance
        .collection("messages")
        .where("participants",
            arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((value) => {
              value.docs.forEach((doc) async {
                await FirebaseFirestore.instance
                    .collection("messages")
                    .doc(doc.id)
                    .collection("chats")
                    .doc()
                    .delete();
                await FirebaseFirestore.instance
                    .collection("messages")
                    .doc(doc.id)
                    .delete();
              })
            });

    var reason =
        FirebaseFirestore.instance.collection("deactivated_accounts").doc();
    await reason.set({
      "mobileNumber": FirebaseAuth.instance.currentUser.phoneNumber,
      "reason": reasonForDeletingAc,
    });
    await FirebaseAuth.instance.signOut();
  }

  deleteTicket(String ticketDocumentId, String imageURL) {
    var deleteTickets = FirebaseFirestore.instance
        .collection("global_ticket")
        .doc(ticketDocumentId);
    var deleteMessages =
        FirebaseFirestore.instance.collection("messages").doc(ticketDocumentId);
    var deleteImages = FirebaseStorage.instance.refFromURL(imageURL);

    deleteTickets.delete();
    deleteMessages.delete();
    deleteImages.delete();
  }

  uploadTicketResponse(
    String comment,
    String ticketDocumentId,
    bool share_mobile,
    String ticket_creater_mobile,
    bool responded,
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

    messages1.set({
      "responderNumber": FirebaseAuth.instance.currentUser.phoneNumber,
      "ticket_creater_mobile": ticket_creater_mobile,
      "id": messages1.id,
      "ticketId": ticketDocumentId,
      "lastMessage": lastMessage,
      "timeStamp": now.microsecondsSinceEpoch,
      "participants": FieldValue.arrayUnion(
        [
          "$ticket_creater_mobile",
          "${FirebaseAuth.instance.currentUser.phoneNumber}"
        ],
      ),
      "ownerMessageSeen": false,
      "responderMessageSeen": false,
      "ticketTitle": ticketTitle,
    }).catchError((e) {
      print(e.toString());
    });

    String time = "${now.hour}:${now.minute}";
    messages2.set({
      "message": lastMessage,
      "sender": FirebaseAuth.instance.currentUser.phoneNumber,
      "timeStamp": now.microsecondsSinceEpoch,
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
      "timeStamp": DateTime.now().microsecondsSinceEpoch,
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

  // countUnseenMessages(String field) {
  //   int count = 0;
  //   var data = FirebaseFirestore.instance
  //       .collection("messages")
  //       .where("participants",
  //           arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
  //       .orderBy("timeStamp", descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       print(element.get(field));
  //       bool x = element.get(field);
  //       if (x == false) {
  //         count = count + 1;
  //       }
  //     });
  //   });
  //   return count;
  // }

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
      "timeStamp": now.microsecondsSinceEpoch
    }).catchError((e) {
      print(e.toString());
    });
  }

  myFavourites(String ticketId) {
    var ref =
        FirebaseFirestore.instance.collection("global_ticket").doc(ticketId);
    ref.update({
      "favourites": FieldValue.arrayUnion(
        ["${FirebaseAuth.instance.currentUser.phoneNumber}"],
      ),
    });
  }

  undomyFavourite(String ticketId) {
    var val = [];
    val.add('${FirebaseAuth.instance.currentUser.phoneNumber}');
    var ref =
        FirebaseFirestore.instance.collection("global_ticket").doc(ticketId);
    ref.update({"favourites": FieldValue.arrayRemove(val)});
  }

  updateUserProfilePhoto(String profilePic) {
    var ref = FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber);
    ref.update({"photo": profilePic});
  }

  updateUserName(String name) {
    var ref = FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber);
    ref.update({"name": name});
  }

  // checkThereIsDefaultTicket() async {
  //   bool flag = false;
  //   await FirebaseFirestore.instance
  //       .collection("global_ticket")
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) async {
  //       print(element.get("ticket_owner"));
  //       if (await element.get("ticket_owner") ==
  //           FirebaseAuth.instance.currentUser.phoneNumber) {
  //         print("yes");
  //         flag = await true;
  //       }
  //     });
  //   });
  //   return false;
  // }
}
