import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/ChatRoom.dart';

import 'NavigationBar.dart';

class messagePage extends StatefulWidget {
  @override
  _messagePageState createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  Future<bool> onBackPress() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => navigationBar(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Messanger"),
        ),
        body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("messages")
                .where(
                  "participants",
                  arrayContains: FirebaseAuth.instance.currentUser.phoneNumber,
                )
                .orderBy("timeStamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: snapshot.data.docs[index]['responderNumber'] ==
                              FirebaseAuth.instance.currentUser.phoneNumber
                          ? (snapshot.data.docs[index]['responderMessageSeen']
                              ? Colors.white
                              : Colors.tealAccent)
                          : (snapshot.data.docs[index]['ownerMessageSeen']
                              ? Colors.white
                              : Colors.tealAccent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 100,
                              child: Center(
                                child: ListTile(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => chatRoom(
                                            snapshot.data.docs[index]
                                                ['ticketId'],
                                            snapshot.data.docs[index]
                                                ['responderNumber'],
                                            "",
                                            snapshot.data.docs[index]['id']));
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: snapshot.data.docs[index]
                                                ['responderNumber'] ==
                                            FirebaseAuth.instance.currentUser
                                                .phoneNumber
                                        ? (NetworkImage(snapshot
                                            .data.docs[index]['ownerPic']))
                                        : NetworkImage((snapshot
                                            .data.docs[index]['responderPic'])),
                                  ),
                                  title: Text(snapshot.data.docs[index]
                                      ['ticket_creater_mobile']),
                                  subtitle: Text(
                                      snapshot.data.docs[index]['lastMessage']),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
