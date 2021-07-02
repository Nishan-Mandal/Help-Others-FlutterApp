import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/MessageScren.dart';
import 'package:help_others/screens/MyTicketsResponses.dart';
import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/screens/NotificationsInBell.dart';
import 'package:help_others/services/Database.dart';

class myTickets extends StatefulWidget {
  myTickets({Key key}) : super(key: key);

  @override
  _myTicketsState createState() => _myTicketsState();
}

class _myTicketsState extends State<myTickets> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
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
          title: Text("My Ads"),
        ),
        body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('global_ticket')
                .where('ticket_owner',
                    isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemExtent: 140,
                  scrollDirection: Axis.vertical,
                  // controller: controller,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    String title = snapshot.data.docs[index]["title"];
                    String description =
                        snapshot.data.docs[index]["description"];
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => myTicketsResponses(
                                    snapshot.data.docs[index]['ticket_owner'],
                                    snapshot.data.docs[index]['title'],
                                    snapshot.data.docs[index]['description'],
                                    snapshot.data.docs[index]['id'],
                                    snapshot.data.docs[index]['mark_as_done'],
                                    snapshot.data.docs[index]['uplodedPhoto'],
                                    snapshot.data.docs[index]['latitude'],
                                    snapshot.data.docs[index]['longitude'],
                                    snapshot.data.docs[index]['date'],
                                  ),
                                ));
                          },
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Positioned(
                                left: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        // spreadRadius: 5,
                                        blurRadius: 5.0,
                                        offset: Offset(5, 8),
                                      ),
                                    ],
                                    color: Colors.grey[500],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth: 300, maxHeight: 110),
                                ),
                              ),
                              Positioned(
                                  left: 0,
                                  top: 15,
                                  child: CircleAvatar(
                                    minRadius: 40,
                                    backgroundColor: Colors.tealAccent,
                                    child: CircleAvatar(
                                        minRadius: 39,
                                        backgroundImage: NetworkImage(
                                          snapshot.data.docs[index]
                                              ["uplodedPhoto"],
                                        )),
                                  )),
                              Positioned(
                                  top: 25,
                                  left: 100,
                                  child: Text(
                                    title.length > 20
                                        ? title.substring(0, 20) + "..."
                                        : title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Positioned(
                                  top: 55,
                                  left: 100,
                                  child: Text(
                                    description.length > 30
                                        ? description.substring(0, 30) + "..."
                                        : description,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                //   return ListView.builder(
                //     itemCount: snapshot.data.docs.length,
                //     itemBuilder: (context, index) {
                //       return Card(
                //         color: Colors.yellow,
                //         child: ListTile(
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => myTicketsResponses(
                //                     snapshot.data.docs[index]['ticket_owner'],
                //                     snapshot.data.docs[index]['title'],
                //                     snapshot.data.docs[index]['description'],
                //                     snapshot.data.docs[index]['id'],
                //                     snapshot.data.docs[index]['mark_as_done'],
                //                     snapshot.data.docs[index]['uplodedPhoto'],
                //                     snapshot.data.docs[index]['latitude'],
                //                     snapshot.data.docs[index]['longitude'],
                //                     snapshot.data.docs[index]['date'],
                //                   ),
                //                 ));
                //           },
                //           title: Text(snapshot.data.docs[index]['title']),
                //           subtitle:
                //               Text(snapshot.data.docs[index]['description']),
                //         ),
                //       );
                //     },
                //   );
              }
            },
          ),
        ),
      ),
    );
  }
}
