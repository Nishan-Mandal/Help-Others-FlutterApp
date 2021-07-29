import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../main.dart';
import 'Dashboard.dart';
import 'Drawer.dart';
import 'MessageScren.dart';
import 'MyTickets.dart';
import 'CreateTickets.dart';

class navigationBar extends StatefulWidget {
  navigationBar({Key key}) : super(key: key);

  @override
  _navigationBarState createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar> {
  bool messageCheker = false;
  int navBarIndex = 0;

  final tabs = [
    Center(
      child: dashboard(latitudeData1, longitudeData1),
    ),
    Center(
      child: messagePage(),
    ),
    Center(
      child: categoryPage(latitudeData1, latitudeData1),
    ),
    Center(
      child: myTickets(),
    ),
    Center(
      child: drawer(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .where("participants",
                arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
            .orderBy("timeStamp", descending: true)
            .snapshots(),
        builder: (context, snapshot2) {
          // var userTicketDocument = snapshot2.data;
          // print("------------------------");
          // // print(userTicketDocument["responderMessageSeen"]);
          // print(snapshot2.data.docs[0]["ownerMessageSeen"]);
          if (!snapshot2.hasData || snapshot2.hasError) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot2.data.docs.length != 0) {
              String thisUser = snapshot2.data.docs[0]["ticket_creater_mobile"];
              if (thisUser == FirebaseAuth.instance.currentUser.phoneNumber &&
                  snapshot2.data.docs[0]["ownerMessageSeen"] == false) {
                // if (this.mounted) {
                // setState(() {
                messageCheker = true;
                // });
                // }
              } else if (thisUser !=
                      FirebaseAuth.instance.currentUser.phoneNumber &&
                  snapshot2.data.docs[0]["responderMessageSeen"] == false) {
                // if (this.mounted) {
                // setState(() {
                messageCheker = true;
                // });
                // }
              } else {
                messageCheker = false;
              }
            }
            return Scaffold(
              body: tabs[navBarIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navBarIndex,
                onTap: (value) {
                  setState(() {
                    navBarIndex = value;
                  });
                },
                backgroundColor: Colors.grey[900],
                // selectedIconTheme: IconThemeData(color: Colors.yellow[100]),
                selectedItemColor: Colors.amber,
                // selectedLabelStyle: TextStyle(color: Colors.blue),

                unselectedItemColor: Colors.amber,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      navBarIndex == 0
                          ? MaterialCommunityIcons.view_dashboard
                          : MaterialCommunityIcons.view_dashboard_outline,
                      // color: Colors.white,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: <Widget>[
                        new Icon(
                          navBarIndex == 1
                              ? Icons.message
                              : Icons.message_outlined,

                          size: 25.5,
                          // color: Colors.white,
                        ),
                        Visibility(
                          visible: messageCheker,
                          child: Positioned(
                            right: -1.0,
                            top: -1.0,
                            child: Stack(
                              children: <Widget>[
                                Icon(
                                  Icons.brightness_1,
                                  size: 12.0,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      navBarIndex == 2
                          ? Icons.add_circle
                          : Icons.add_circle_outline,

                      color: Colors.redAccent[400],
                      // size: 30,
                    ),
                    label: 'Post Ad',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(navBarIndex == 3
                            ? Icons.favorite
                            : Icons.favorite_outline
                        // color: Colors.white,
                        ),
                    label: 'My Ads',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      navBarIndex == 4
                          ? Icons.account_circle
                          : Icons.account_circle_outlined,
                    ),
                    label: 'Account',
                  ),
                ],
              ),
            );
          }
        });
  }
}
