import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/ChatRoom.dart';
import 'package:help_others/services/Constants.dart';

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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            bottom: TabBar(
              labelColor: Constants.searchIcon,
              tabs: [
                Tab(
                  text: "ALL",
                ),
                Tab(
                  text: "BUYING",
                ),
                Tab(
                  text: "SELLING",
                ),
              ],
            ),
            title: Text('Chats', style: TextStyle(color: Colors.amber)),
          ),
          body: TabBarView(
            children: [
              allMessages(),
              buyingMessages(),
              sellingMessages(),
            ],
          ),
        ),
      ),
    );
  }
}

class allMessages extends StatefulWidget {
  @override
  _allMessagesState createState() => _allMessagesState();
}

class _allMessagesState extends State<allMessages> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
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
                String title = snapshot.data.docs[index]['ticketTitle'];
                String mobile;
                if (snapshot.data.docs[index]['ticket_creater_mobile'] ==
                    FirebaseAuth.instance.currentUser.phoneNumber) {
                  mobile = snapshot.data.docs[index]['responderNumber'];
                } else if (snapshot.data.docs[index]['responderNumber'] ==
                    FirebaseAuth.instance.currentUser.phoneNumber) {
                  mobile = snapshot.data.docs[index]['ticket_creater_mobile'];
                }

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user_account")
                        .doc(mobile)
                        .snapshots(),
                    builder: (context, snapshot2) {
                      var userDocument = snapshot2.data;
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("global_ticket")
                              .doc(snapshot.data.docs[index]['ticketId'])
                              .snapshots(),
                          builder: (context, snapshot3) {
                            var userDocument2 = snapshot3.data;
                            return Align(
                              heightFactor: 0.92,
                              child: GestureDetector(
                                child: Stack(
                                  children: [
                                    Card(
                                      // color: Colors.grey[700],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              height: 80,
                                              child: Center(
                                                child: Container(
                                                    child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),

                                                      // borderRadius:
                                                      //     BorderRadius
                                                      //         .all(Radius
                                                      //             .circular(
                                                      //                 10)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: SizedBox(
                                                          height: 60,
                                                          width: 50,
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: userDocument2[
                                                                "uplodedPhoto"],
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                      ),

                                                      //  snapshot.data
                                                      //                 .docs[index][
                                                      //             'responderNumber'] ==
                                                      //         FirebaseAuth
                                                      //             .instance
                                                      //             .currentUser
                                                      //             .phoneNumber
                                                      //     ? (NetworkImage(snapshot
                                                      //             .data.docs[index]
                                                      //         ['ownerPic']))
                                                      //     : NetworkImage((snapshot
                                                      //             .data.docs[index]
                                                      //         ['responderPic'])),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          userDocument["name"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: snapshot.data
                                                                            .docs[index][
                                                                        'responderNumber'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .phoneNumber
                                                                ? (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'responderMessageSeen']
                                                                    ? Colors
                                                                        .white54
                                                                    : Colors
                                                                        .white)
                                                                : (snapshot.data
                                                                            .docs[index][
                                                                        'ownerMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          title.length > 34
                                                              ? title.substring(
                                                                      0, 34) +
                                                                  "..."
                                                              : title,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: snapshot.data
                                                                            .docs[index][
                                                                        'responderNumber'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .phoneNumber
                                                                ? (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'responderMessageSeen']
                                                                    ? Colors
                                                                        .white70
                                                                    : Colors
                                                                        .white)
                                                                : (snapshot.data
                                                                            .docs[index][
                                                                        'ownerMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(snapshot.data
                                                                .docs[index]
                                                            ['lastMessage']),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: snapshot.data.docs[index]
                                                  ['responderNumber'] ==
                                              FirebaseAuth.instance.currentUser
                                                  .phoneNumber
                                          ? (snapshot.data.docs[index]
                                                  ['responderMessageSeen']
                                              ? false
                                              : true)
                                          : (snapshot.data.docs[index]
                                                  ['ownerMessageSeen']
                                              ? false
                                              : true),
                                      child: Positioned(
                                          left: queryData.width * 0.89,
                                          top: 35,
                                          child: Center(
                                            child: Icon(
                                              Icons.brightness_1,
                                              size: 12.0,
                                              color: Colors.red,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // String photo = snapshot.data.docs[index]
                                  //             ['responderNumber'] ==
                                  //         FirebaseAuth
                                  //             .instance.currentUser.phoneNumber
                                  //     ? (snapshot.data.docs[index]['ownerPic'])
                                  //     : NetworkImage(snapshot.data.docs[index]
                                  //         ['responderPic']);
                                  showDialog(
                                      context: context,
                                      builder: (context) => chatRoom(
                                            snapshot.data.docs[index]
                                                ['ticketId'],
                                            mobile,
                                            snapshot.data.docs[index]
                                                ['ticketTitle'],
                                            snapshot.data.docs[index]['id'],
                                            userDocument["name"],
                                            userDocument2["uplodedPhoto"],
                                          ));
                                },
                              ),
                            );
                          });
                    });
              },
            );
          }
        },
      ),
    );
  }
}

class buyingMessages extends StatefulWidget {
  @override
  _buyingMessagesState createState() => _buyingMessagesState();
}

class _buyingMessagesState extends State<buyingMessages> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .where(
              "participants",
              arrayContains: FirebaseAuth.instance.currentUser.phoneNumber,
            )
            .where(
              "ticket_creater_mobile",
              isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber,
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
                String title = snapshot.data.docs[index]['ticketTitle'];
                String mobile;
                if (snapshot.data.docs[index]['ticket_creater_mobile'] ==
                    FirebaseAuth.instance.currentUser.phoneNumber) {
                  mobile = snapshot.data.docs[index]['responderNumber'];
                } else if (snapshot.data.docs[index]['responderNumber'] ==
                    FirebaseAuth.instance.currentUser.phoneNumber) {
                  mobile = snapshot.data.docs[index]['ticket_creater_mobile'];
                }

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user_account")
                        .doc(mobile)
                        .snapshots(),
                    builder: (context, snapshot2) {
                      var userDocument = snapshot2.data;
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("global_ticket")
                              .doc(snapshot.data.docs[index]['ticketId'])
                              .snapshots(),
                          builder: (context, snapshot3) {
                            var userDocument2 = snapshot3.data;
                            return Align(
                              heightFactor: 0.92,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => chatRoom(
                                          snapshot.data.docs[index]['ticketId'],
                                          snapshot.data.docs[index]
                                              ['responderNumber'],
                                          snapshot.data.docs[index]
                                              ['ticketTitle'],
                                          snapshot.data.docs[index]['id'],
                                          userDocument["name"],
                                          userDocument2["uplodedPhoto"]));
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              height: 80,
                                              child: Center(
                                                child: Container(
                                                    child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: 50,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: userDocument2[
                                                                "uplodedPhoto"],
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          userDocument["name"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: snapshot.data
                                                                            .docs[index][
                                                                        'responderNumber'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .phoneNumber
                                                                ? (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'responderMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black)
                                                                : (snapshot.data
                                                                            .docs[index][
                                                                        'ownerMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          title.length > 34
                                                              ? title.substring(
                                                                      0, 34) +
                                                                  "..."
                                                              : title,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: snapshot.data
                                                                            .docs[index][
                                                                        'responderNumber'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .phoneNumber
                                                                ? (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'responderMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black)
                                                                : (snapshot.data
                                                                            .docs[index][
                                                                        'ownerMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(snapshot.data
                                                                .docs[index]
                                                            ['lastMessage']),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: snapshot.data.docs[index]
                                                  ['responderNumber'] ==
                                              FirebaseAuth.instance.currentUser
                                                  .phoneNumber
                                          ? (snapshot.data.docs[index]
                                                  ['responderMessageSeen']
                                              ? false
                                              : true)
                                          : (snapshot.data.docs[index]
                                                  ['ownerMessageSeen']
                                              ? false
                                              : true),
                                      child: Positioned(
                                          left: queryData.width * 0.89,
                                          top: 35,
                                          child: Center(
                                            child: Icon(
                                              Icons.brightness_1,
                                              size: 12.0,
                                              color: Colors.red,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
              },
            );
          }
        },
      ),
    );
  }
}

class sellingMessages extends StatefulWidget {
  @override
  _sellingMessagesState createState() => _sellingMessagesState();
}

class _sellingMessagesState extends State<sellingMessages> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .where(
              "participants",
              arrayContains: FirebaseAuth.instance.currentUser.phoneNumber,
            )
            .where(
              "responderNumber",
              isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber,
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
                String title = snapshot.data.docs[index]['ticketTitle'];
                String mobile;
                if (snapshot.data.docs[index]['ticket_creater_mobile'] ==
                    FirebaseAuth.instance.currentUser.phoneNumber) {
                  mobile = snapshot.data.docs[index]['responderNumber'];
                } else if (snapshot.data.docs[index]['responderNumber'] ==
                    FirebaseAuth.instance.currentUser.phoneNumber) {
                  mobile = snapshot.data.docs[index]['ticket_creater_mobile'];
                }
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user_account")
                        .doc(mobile)
                        .snapshots(),
                    builder: (context, snapshot2) {
                      var userDocument = snapshot2.data;
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("global_ticket")
                              .doc(snapshot.data.docs[index]['ticketId'])
                              .snapshots(),
                          builder: (context, snapshot3) {
                            var userDocument2 = snapshot3.data;
                            return Align(
                              heightFactor: 0.92,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => chatRoom(
                                          snapshot.data.docs[index]['ticketId'],
                                          snapshot.data.docs[index]
                                              ['responderNumber'],
                                          snapshot.data.docs[index]
                                              ['ticketTitle'],
                                          snapshot.data.docs[index]['id'],
                                          userDocument["name"],
                                          userDocument2["uplodedPhoto"]));
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              height: 80,
                                              child: Center(
                                                child: Container(
                                                    child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: 50,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: userDocument2[
                                                                "uplodedPhoto"],
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          userDocument["name"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: snapshot.data
                                                                            .docs[index][
                                                                        'responderNumber'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .phoneNumber
                                                                ? (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'responderMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black)
                                                                : (snapshot.data
                                                                            .docs[index][
                                                                        'ownerMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        Text(
                                                          title.length > 34
                                                              ? title.substring(
                                                                      0, 34) +
                                                                  "..."
                                                              : title,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: snapshot.data
                                                                            .docs[index][
                                                                        'responderNumber'] ==
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .phoneNumber
                                                                ? (snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'responderMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black)
                                                                : (snapshot.data
                                                                            .docs[index][
                                                                        'ownerMessageSeen']
                                                                    ? Colors
                                                                        .black45
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(snapshot.data
                                                                .docs[index]
                                                            ['lastMessage']),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: snapshot.data.docs[index]
                                                  ['responderNumber'] ==
                                              FirebaseAuth.instance.currentUser
                                                  .phoneNumber
                                          ? (snapshot.data.docs[index]
                                                  ['responderMessageSeen']
                                              ? false
                                              : true)
                                          : (snapshot.data.docs[index]
                                                  ['ownerMessageSeen']
                                              ? false
                                              : true),
                                      child: Positioned(
                                          left: queryData.width * 0.89,
                                          top: 35,
                                          child: Center(
                                            child: Icon(
                                              Icons.brightness_1,
                                              size: 12.0,
                                              color: Colors.red,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
              },
            );
          }
        },
      ),
    );
  }
}