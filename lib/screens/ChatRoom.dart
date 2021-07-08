import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/services/Database.dart';

class chatRoom extends StatefulWidget {
  String ticketUniqueId;
  String responderMobileNumber;
  String ticketTitle;
  String docIdInMessageCollection;
  String name;
  chatRoom(this.ticketUniqueId, this.responderMobileNumber, this.ticketTitle,
      this.docIdInMessageCollection, this.name);

  @override
  _chatRoomState createState() => _chatRoomState();
}

class _chatRoomState extends State<chatRoom> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final TextEditingController messageControler = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name),
            Text(
              widget.responderMobileNumber,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("messages")
              .doc(widget.docIdInMessageCollection)
              .collection("chats")
              .orderBy("timeStamp")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("messages")
                      .doc(widget.docIdInMessageCollection)
                      .snapshots(),
                  builder: (context, snapshot2) {
                    var messageCollection = snapshot2.data;

                    if (messageCollection['responderNumber'] ==
                        FirebaseAuth.instance.currentUser.phoneNumber) {
                      databaseMethods.updateResponderMessageSeenStatus(
                          widget.docIdInMessageCollection);
                    } else if (messageCollection['ticket_creater_mobile'] ==
                        FirebaseAuth.instance.currentUser.phoneNumber) {
                      databaseMethods.updateOwnerMessageSeenStatus(
                          widget.docIdInMessageCollection);
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            height: 650,
                            // color: Colors.white,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data.docs.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 0, bottom: 10),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 0),
                                  child: Align(
                                    alignment: (snapshot.data.docs[index]
                                                ['sender'] ==
                                            FirebaseAuth.instance.currentUser
                                                .phoneNumber
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: (snapshot.data.docs[index]
                                                      ['sender'] ==
                                                  FirebaseAuth.instance
                                                      .currentUser.phoneNumber
                                              ? Colors.blue[300]
                                              : Colors.grey),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: snapshot.data.docs[index]
                                                ['message'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          TextSpan(
                                            text: " " +
                                                snapshot.data.docs[index]
                                                    ['messageSentTime'],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ]))
                                        // Text(
                                        //   snapshot.data.docs[index]['message'],
                                        //   style: TextStyle(fontSize: 17),
                                        // ),
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          messageCollection["responderNumber"] ==
                                  FirebaseAuth.instance.currentUser.phoneNumber
                              ? (messageCollection["ownerMessageSeen"]
                                  ? "seen             "
                                  : "")
                              : (messageCollection["responderMessageSeen"]
                                  ? "seen             "
                                  : ""),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: messageControler,
                                    decoration: InputDecoration(
                                      hintText: "Type a message...",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      if (messageControler.text.isNotEmpty) {
                                        databaseMethods.chatsInChatRoom(
                                            messageControler.text,
                                            widget.docIdInMessageCollection,
                                            widget.responderMobileNumber);
                                        databaseMethods.updataLastChat(
                                            widget.docIdInMessageCollection,
                                            messageControler.text);
                                        messageControler.clear();
                                        Future.delayed(
                                            const Duration(milliseconds: 400),
                                            () {
                                          setState(() {
                                            _scrollController.jumpTo(
                                                _scrollController
                                                    .position.maxScrollExtent);
                                          });
                                        });
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  backgroundColor: Colors.blue,
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
