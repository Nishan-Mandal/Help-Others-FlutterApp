import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

double latitudeData;
double longitudeData;

class _navigationBarState extends State<navigationBar> {
  bool messageCheker = false;
  int navBarIndex = 0;

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    // setState(() {
    latitudeData = geoposition.latitude;
    longitudeData = geoposition.longitude;
    // });
  }

  // checkMessage() async {
  //   var data = await FirebaseFirestore.instance
  //       .collection("messages")
  //       .where("participants",
  //           arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
  //       .orderBy("timeStamp", descending: true)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) async {
  //       String thisUser = await element.get("ticket_creater_mobile");
  //       if (thisUser == FirebaseAuth.instance.currentUser.phoneNumber &&
  //           element.get("ownerMessageSeen") == false) {
  //         if (this.mounted) {
  //           setState(() {
  //             messageCheker = true;
  //           });
  //         }
  //       } else if (thisUser != FirebaseAuth.instance.currentUser.phoneNumber &&
  //           element.get("responderMessageSeen") == false) {
  //         if (this.mounted) {
  //           setState(() {
  //             messageCheker = true;
  //           });
  //         }
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentLocation();
    });
  }

  final tabs = [
    Center(
      child: dashboard(latitudeData, longitudeData),
    ),
    Center(
      child: messagePage(),
    ),
    Center(
      child: categoryPage(latitudeData, longitudeData),
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
            return CircularProgressIndicator();
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
                backgroundColor: Colors.blueGrey,
                selectedIconTheme: IconThemeData(color: Colors.white),
                selectedItemColor: Colors.white,
                // selectedItemColor: Colors.amber[800],
                selectedLabelStyle: TextStyle(color: Colors.white),
                unselectedItemColor: Colors.blueGrey[900],
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'Dashboard',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: <Widget>[
                        new Icon(
                          Icons.message,
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
                    title: Text(
                      'messages',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                      color: Colors.limeAccent,
                    ),
                    title: Text(
                      'Post Ad',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.art_track,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'My Ads',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_circle,
                      // color: Colors.white,
                    ),
                    title: Text(
                      'Account',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
