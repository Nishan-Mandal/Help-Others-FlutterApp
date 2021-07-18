import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/screens/MessageScren.dart';

import 'package:help_others/screens/MyTicketsResponses.dart';
import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/screens/NotificationsInBell.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/Database.dart';

import 'TicketViewScreen.dart';

class myTickets extends StatefulWidget {
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.appBar,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "ADS",
                ),
                Tab(
                  text: "FAVOURITES",
                ),
              ],
            ),
            title: Text('My Ads'),
          ),
          body: TabBarView(
            children: [
              ads(),
              favourites(),
            ],
          ),
        ),
      ),
    );
  }
}

class ads extends StatefulWidget {
  @override
  _adsState createState() => _adsState();
}

class _adsState extends State<ads> {
  get databaseMethods => null;

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: snapshot.data.docs.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      String title = snapshot.data.docs[index]["title"];
                      String description =
                          snapshot.data.docs[index]["description"];
                      bool myFavFlag = false;

                      try {
                        List l = snapshot.data.docs[index]["favourites"];
                        if (l.contains(
                            FirebaseAuth.instance.currentUser.phoneNumber)) {
                          myFavFlag = true;
                        }
                      } catch (e) {
                        myFavFlag = false;
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ticketViewScreen(
                                    snapshot.data.docs[index]["ticket_owner"],
                                    snapshot.data.docs[index]["title"],
                                    snapshot.data.docs[index]["description"],
                                    snapshot.data.docs[index]["id"],
                                    snapshot.data.docs[index]["uplodedPhoto"],
                                    snapshot.data.docs[index]["latitude"],
                                    snapshot.data.docs[index]["longitude"],
                                    snapshot.data.docs[index]["date"],
                                    snapshot.data.docs[index]["share_mobile"],
                                    false,
                                    snapshot.data.docs[index]["address"],
                                    snapshot.data.docs[index]["category"]),
                              ));
                        },
                        child: Stack(
                          children: [
                            new Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: Constants.gradientColorOnAd),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: new Center(
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    snapshot.data.docs[index]
                                                        ["uplodedPhoto"],
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            )),
                                            height: queryData.height,
                                            width: queryData.width,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 70,
                                        width: queryData.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.length > 20
                                                  ? "  " +
                                                      title.substring(0, 20) +
                                                      "..."
                                                  : "  " + title,
                                              style: TextStyle(
                                                color: Constants.titleText,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                description.length > 22
                                                    ? description.substring(
                                                            0, 22) +
                                                        "..."
                                                    : description,
                                                style: TextStyle(
                                                    color: Constants
                                                        .descriptionText),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Constants.addressText,
                                            size: 15,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ["address"],
                                            style: TextStyle(
                                                color: Constants.locationMarker,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_ic_call,
                                          size: 22,
                                          color: Constants.callIcon,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          FontAwesome.comments_o,
                                          color: Constants.chatIcon,
                                          size: 22,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 3.2 : 3.8),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class favourites extends StatefulWidget {
  @override
  _favouritesState createState() => _favouritesState();
}

class _favouritesState extends State<favourites> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  // Future<bool> onBackPress() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Navigator.pop(context);
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => navigationBar(),
  //         ),
  //         (route) => false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("global_ticket")
              .where("favourites",
                  arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: snapshot.data.docs.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      String title = snapshot.data.docs[index]["title"];
                      String description =
                          snapshot.data.docs[index]["description"];
                      bool myFavFlag = false;

                      try {
                        List l = snapshot.data.docs[index]["favourites"];
                        if (l.contains(
                            FirebaseAuth.instance.currentUser.phoneNumber)) {
                          myFavFlag = true;
                        }
                      } catch (e) {
                        myFavFlag = false;
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ticketViewScreen(
                                    snapshot.data.docs[index]["ticket_owner"],
                                    snapshot.data.docs[index]["title"],
                                    snapshot.data.docs[index]["description"],
                                    snapshot.data.docs[index]["id"],
                                    snapshot.data.docs[index]["uplodedPhoto"],
                                    snapshot.data.docs[index]["latitude"],
                                    snapshot.data.docs[index]["longitude"],
                                    snapshot.data.docs[index]["date"],
                                    snapshot.data.docs[index]["share_mobile"],
                                    true,
                                    snapshot.data.docs[index]["address"],
                                    snapshot.data.docs[index]["category"]),
                              ));
                        },
                        child: Stack(
                          children: [
                            new Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: Constants.gradientColorOnAd),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: new Center(
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    snapshot.data.docs[index]
                                                        ["uplodedPhoto"],
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            )),
                                            height: queryData.height,
                                            width: queryData.width,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 70,
                                        width: queryData.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.length > 20
                                                  ? "  " +
                                                      title.substring(0, 20) +
                                                      "..."
                                                  : "  " + title,
                                              style: TextStyle(
                                                color: Constants.titleText,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                description.length > 22
                                                    ? description.substring(
                                                            0, 22) +
                                                        "..."
                                                    : description,
                                                style: TextStyle(
                                                    color: Constants
                                                        .descriptionText),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 120,
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: Constants.gradientColorOnAd),
                                      borderRadius: BorderRadius.circular(90)),
                                  child: IconButton(
                                    icon: myFavFlag
                                        ? Icon(
                                            Icons.favorite,
                                            color: Constants.myFavIconTrue,
                                            size: 20,
                                          )
                                        : Icon(Icons.favorite_border,
                                            size: 20,
                                            color: Constants.myFavIconFalse),
                                    onPressed: () {
                                      setState(() {
                                        if (myFavFlag) {
                                          databaseMethods.undomyFavourite(
                                            snapshot.data.docs[index]["id"],
                                          );
                                        } else {
                                          databaseMethods.myFavourites(
                                            snapshot.data.docs[index]["id"],
                                          );
                                        }
                                        myFavFlag = true;
                                      });
                                    },
                                  ),
                                )),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Constants.addressText,
                                            size: 15,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ["address"],
                                            style: TextStyle(
                                                color: Constants.locationMarker,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_ic_call,
                                          size: 22,
                                          color: Constants.callIcon,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          FontAwesome.comments_o,
                                          color: Constants.chatIcon,
                                          size: 22,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 3.2 : 3.8),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
