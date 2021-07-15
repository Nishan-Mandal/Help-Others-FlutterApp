// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:help_others/services/Database.dart';

// import '../main.dart';

// class notificationsInBell extends StatefulWidget {
//   String ticketUniqueId;
//   notificationsInBell(this.ticketUniqueId);

//   @override
//   _notificationsInBellState createState() => _notificationsInBellState();
// }

// class _notificationsInBellState extends State<notificationsInBell> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   DatabaseMethods databaseMethods = new DatabaseMethods();

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notifications"),
//       ),
//       body: Container(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection("messages")
//               .where(
//                 "participants",
//                 arrayContains: FirebaseAuth.instance.currentUser.phoneNumber,
//               )
//               .orderBy("timeStamp", descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data.docs.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     color: snapshot.data.docs[index]['responderNumber'] ==
//                             FirebaseAuth.instance.currentUser.phoneNumber
//                         ? (snapshot.data.docs[index]['responderMessageSeen']
//                             ? Colors.yellow
//                             : Colors.tealAccent)
//                         : (snapshot.data.docs[index]['ownerMessageSeen']
//                             ? Colors.yellow
//                             : Colors.tealAccent),
//                     child: ListTile(
//                       onTap: () {
//                         // showDialog(
//                         //     context: context,
//                         //     builder: (context) => PopupTicketPage(
//                         //           snapshot.data.docs[index]['user_account'],
//                         //           snapshot.data.docs[index]['title'],
//                         //           snapshot.data.docs[index]['description'],
//                         //           snapshot.data.docs[index]['id'],
//                         //         ));
//                       },
//                       title: Text(snapshot.data.docs[index]['responderNumber']),
//                       subtitle: Text(snapshot.data.docs[index]['lastMessage']),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
