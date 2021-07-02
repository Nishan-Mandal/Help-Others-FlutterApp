import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/ChatRoom.dart';
import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/screens/SeeProfileOfTicketOwner.dart';
import 'package:help_others/services/Database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MessageScren.dart';
import 'NotificationsInBell.dart';

class ticketViewScreen extends StatefulWidget {
  String ticketOwnweMobileNumber;
  String title;
  String description;
  String id;
  bool markAsDone;
  String photo;
  double latitude;
  double longitude;
  String date;
  ticketViewScreen(
    this.ticketOwnweMobileNumber,
    this.title,
    this.description,
    this.id,
    this.markAsDone,
    this.photo,
    this.latitude,
    this.longitude,
    this.date,
  );

  @override
  _ticketViewScreenState createState() => _ticketViewScreenState();
}

class _ticketViewScreenState extends State<ticketViewScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final TextEditingController messageControler = TextEditingController();
  bool responded = false;

  callTicketOwner() async {
    String phoneNo =
        'tel: ${widget.ticketOwnweMobileNumber.substring(3, widget.ticketOwnweMobileNumber.length)}';
    if (await canLaunch(phoneNo)) {
      await launch(phoneNo);
    } else {
      throw 'Could not launch $phoneNo';
    }
  }

  Future<void> mapInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendMessageFromGivenKeywords(String text) {
    var userAccount;
    setState(() {
      var data = FirebaseFirestore.instance
          .collection("user_account")
          .doc(widget.ticketOwnweMobileNumber)
          .get()
          .then((value) => {userAccount = value.get("photo")});
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      databaseMethods.uploadTicketResponse(
          "comment",
          widget.id,
          false,
          false,
          widget.ticketOwnweMobileNumber,
          true,
          userAccount,
          widget.title,
          text);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => chatRoom(widget.id,
              widget.ticketOwnweMobileNumber, widget.title, widget.id),
        ));
  }

  void _tripEditModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Chat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.orange,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        RaisedButton(
                          child: Text("Hello"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () {
                            sendMessageFromGivenKeywords("Hello");
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Are you available"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () {
                            sendMessageFromGivenKeywords("Are you available");
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Let's talk"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () {
                            sendMessageFromGivenKeywords("Let's talk");
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        RaisedButton(
                          child: Text("Let's meet"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () {
                            sendMessageFromGivenKeywords("Let's meet");
                          },
                        )
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: messageControler,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
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
                              sendMessageFromGivenKeywords(
                                  messageControler.text);
                              messageControler.clear();
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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
              alignment: Alignment(-0.9, -0.8),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(navigationBar()),
              )),
          SizedBox(
            width: 240,
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user_account")
                .doc(widget.ticketOwnweMobileNumber)
                .snapshots(),
            builder: (context, snapshot) {
              var userAccount = snapshot.data;

              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("global_ticket")
                      .doc(widget.id)
                      .collection("responses")
                      .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                      .snapshots(),
                  builder: (context, snapshot2) {
                    var userTicketDocument = snapshot2.data;
                    try {
                      responded = userTicketDocument["responded"];
                    } catch (e) {
                      responded = false;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: queryData.width,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.cyan[800],
                              // spreadRadius: 10,
                              // blurRadius: 25.0,
                              offset: Offset(0, 0),
                            ),
                          ]),
                          alignment: Alignment.bottomLeft,
                          // child: IconButton(
                          //   icon: Icon(Icons.arrow_back),
                          //   onPressed: () => Navigator.of(context).pop(dashboard("")),
                          // ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.white, Colors.grey])),
                                  height: 250,
                                  width: queryData.width,
                                  child: Image(
                                    image: NetworkImage(widget.photo),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    widget.title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.date,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text("Description",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Container(
                                    width: queryData.width,
                                    height: queryData.height / 4,
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(widget.description,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                                // https://www.google.com/maps/place/Newtown,+Kolkata,+West+Bengal/@22.5861408,88.4227606,12z/data=!3m1!4b1!4m5!3m4!1s0x3a0275350398a5b9:0x75e165b244323425!8m2!3d22.5753931!4d88.4797903
                                // RaisedButton(
                                //   child: Text("map"),
                                //   onPressed: () {
                                //     mapInBrowser(
                                //         // "http://maps.google.com/maps?daddr=${widget.latitude},${widget.longitude}");
                                //         // "https://www.google.com/maps/dir//${widget.latitude},${widget.longitude}/@${widget.latitude},${widget.longitude},12z");
                                //         "https://www.google.com/maps/place/@${widget.latitude},${widget.longitude},12z/data=!3m1!4b1!4m5!3m4!1s0x3a0275350398a5b9:0x75e165b244323425!8m2!3d${widget.latitude}!4d${widget.longitude}");
                                //   },
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, left: 12.0, top: 12.0),
                                  child: Text(
                                    "Ad posted at",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => mapInBrowser(
                                      "https://www.google.com/maps/dir//${widget.latitude},${widget.longitude}/@${widget.latitude},${widget.longitude},12z"),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      height: 90,
                                      width: queryData.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: AssetImage("map.jpg"),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    width: queryData.width,
                                    height: queryData.height * 0.12,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: CircleAvatar(
                                            minRadius: 40,
                                            backgroundImage: NetworkImage(
                                                userAccount["photo"]),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(userAccount["name"],
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(userAccount["email"],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          seeProfileOfTicketOwner(
                                                              userAccount[
                                                                  "photo"],
                                                              userAccount[
                                                                  "name"],
                                                              widget
                                                                  .ticketOwnweMobileNumber),
                                                    )),
                                                child: Text("SEE PROFILE",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 17,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Visibility(
                                visible: widget.ticketOwnweMobileNumber !=
                                        FirebaseAuth
                                            .instance.currentUser.phoneNumber
                                    ? true
                                    : true,
                                child: !responded
                                    ? SizedBox(
                                        width: queryData.width * 0.3,
                                        height: 50,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.black,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.chat,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "  Chat",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _tripEditModalBottomSheet(
                                                  context);
                                              // databaseMethods
                                              //     .uploadTicketResponse(
                                              //   "comment",
                                              //   widget.id,
                                              //   false,
                                              //   false,
                                              //   widget.ticketOwnweMobileNumber,
                                              //   true,
                                              //   userAccount["photo"],
                                              //   widget.title,
                                              // );
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) => chatRoom(
                                              //           widget.id,
                                              //           widget
                                              //               .ticketOwnweMobileNumber,
                                              //           widget.title,
                                              //           widget.id),
                                              //     ));

                                              // responded = true;
                                            });
                                          },
                                        ),
                                      )
                                    : SizedBox(
                                        width: queryData.width * 0.3,
                                        height: 50,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.green,
                                          child: Text(
                                            "Chat History",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => chatRoom(
                                                        widget.id,
                                                        widget
                                                            .ticketOwnweMobileNumber,
                                                        widget.title,
                                                        widget.id),
                                                  ));
                                            });
                                          },
                                        ),
                                      )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: queryData.width * 0.3,
                                height: 50,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () => callTicketOwner(),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "   Call",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  });
            }),
      ),
    );
  }
}

// class PopupTicketPage extends StatefulWidget {
//   String ticketOwnweMobileNumber;
//   String title;
//   String description;
//   String id;
//   bool markAsDone;
//   String photo;
//   PopupTicketPage(
//     this.ticketOwnweMobileNumber,
//     this.title,
//     this.description,
//     this.id,
//     this.markAsDone,
//     this.photo,
//   );

//   @override
//   _PopupTicketPageState createState() => _PopupTicketPageState();
// }

// class _PopupTicketPageState extends State<PopupTicketPage> {
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   bool responded = false;
//   @override
//   Widget build(BuildContext context) {
//     // Future checkBooleanInRespondedField() async {
//     //   FirebaseFirestore.instance
//     //       .collection("global_ticket")
//     //       .doc(widget.id)
//     //       .collection("responses")
//     //       .where("utr_mobile",
//     //           isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
//     //       .get()
//     //       .then((value) => {
//     //             value.docs.forEach((doc) {
//     //               responded = doc.get("responded");
//     //             })
//     //           });
//     // }

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       child: Container(
//         color: Colors.amber,
//         height: 400,
//         child: Padding(
//           padding: EdgeInsets.all(12.0),
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('user_account')
//                 .doc("${widget.ticketOwnweMobileNumber}")
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 var userDocument = snapshot.data;

//                 return StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection("global_ticket")
//                       .doc(widget.id)
//                       .collection("responses")
//                       .doc(FirebaseAuth.instance.currentUser.phoneNumber)
//                       .snapshots(),
//                   builder: (context, snapshot2) {
//                     var userTicketDocument = snapshot2.data;

//                     try {
//                       responded = userTicketDocument["responded"];
//                     } catch (e) {
//                       responded = false;
//                     }
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 30.0,
//                               backgroundImage: NetworkImage(widget.photo),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               userDocument['name'],
//                               style: TextStyle(fontSize: 20),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 50,
//                         ),
//                         Text(
//                           "title:",
//                           style: TextStyle(fontSize: 30),
//                         ),
//                         Text(
//                           widget.title,
//                           style: TextStyle(fontSize: 25),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Text(
//                           "Description:",
//                           style: TextStyle(fontSize: 30),
//                         ),
//                         Text(
//                           widget.description,
//                           style: TextStyle(fontSize: 25),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Visibility(
//                             visible: widget.ticketOwnweMobileNumber !=
//                                     FirebaseAuth
//                                         .instance.currentUser.phoneNumber
//                                 ? true
//                                 : true,
//                             child: !responded
//                                 ? RaisedButton(
//                                     child: Text("Response"),
//                                     onPressed: () {
//                                       setState(() {
//                                         databaseMethods.uploadTicketResponse(
//                                           "comment",
//                                           widget.id,
//                                           false,
//                                           false,
//                                           widget.ticketOwnweMobileNumber,
//                                           true,
//                                           userDocument["photo"],
//                                           widget.title,
//                                         );

//                                         responded = true;
//                                       });
//                                     },
//                                   )
//                                 : Icon(
//                                     Icons.done,
//                                     size: 50,
//                                     color: Colors.green,
//                                   ))
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
