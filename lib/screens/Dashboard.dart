import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:help_others/main.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:help_others/screens/SearchBar.dart';
import 'package:help_others/services/AdMob.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/CustomPageRoute.dart';
import 'package:help_others/services/Database.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'TicketViewScreen.dart' show ticketViewScreen;
import 'package:help_others/services/BannerAds.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_icons/flutter_icons.dart';

String sc;

class dashboard extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  dashboard(this.latitudeData, this.longitudeData);
  @override
  _dashboardState createState() => _dashboardState();
}

int ticketsWithinDistance = 30000;
bool listView = false;

class _dashboardState extends State<dashboard> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  AdMobService adMobService = new AdMobService();

  int notificationCounter = 0;
  int messageCounter = 0;
  int callAdCounter = 0;
  List<DocumentSnapshot> products = [];
  bool loadingProducts = true;
  int perPage = 10;
  DocumentSnapshot lastDocument;

  ScrollController scrollController = ScrollController();
  bool gettingMoreProducts = false;
  bool moreProductsAvaliable = true;

  final TextEditingController messageControler = TextEditingController();
  Future<void> sendMessageFromGivenKeywords(
    String id,
    String ticketOwnweMobileNumber,
    String title,
    String photo,
    String ticketOwnweMobileNumber1,
    String text,
  ) async {
    Navigator.pop(context);

    String name;
    await FirebaseFirestore.instance
        .collection("user_account")
        .doc(FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((value) {
      setState(() {
        name = value.get("name");
      });
    });
    databaseMethods.uploadTicketResponse(id, ticketOwnweMobileNumber, title,
        text, name, photo, ticketOwnweMobileNumber1, context, false);
  }

  void _tripEditModalBottomSheet(
    context,
    String id,
    String ticketOwnweMobileNumber,
    String title,
    String photo,
    String ticketOwnweMobileNumber1,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user_account")
                .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                .snapshots(),
            builder: (context, snapshot) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.40,
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
                                      color: Constants.searchIcon,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                child: Text(
                                  "Hello",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  sendMessageFromGivenKeywords(
                                      id,
                                      ticketOwnweMobileNumber,
                                      title,
                                      photo,
                                      ticketOwnweMobileNumber1,
                                      "Hello");
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text(
                                  "Are you available?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  sendMessageFromGivenKeywords(
                                      id,
                                      ticketOwnweMobileNumber,
                                      title,
                                      photo,
                                      ticketOwnweMobileNumber1,
                                      "Are you available?");
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text(
                                  "Let's talk",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  sendMessageFromGivenKeywords(
                                      id,
                                      ticketOwnweMobileNumber,
                                      title,
                                      photo,
                                      ticketOwnweMobileNumber1,
                                      "Let's talk");
                                },
                              )
                            ],
                          ),
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
                                  hintStyle:
                                      TextStyle(color: Constants.searchIcon),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Constants.searchIcon),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Constants.searchIcon),
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
                                        id,
                                        ticketOwnweMobileNumber,
                                        title,
                                        photo,
                                        ticketOwnweMobileNumber1,
                                        messageControler.text);
                                    messageControler.clear();
                                  }
                                });
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.black,
                                size: 18,
                              ),
                              backgroundColor: Constants.searchIcon,
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  getProducts() async {
    Query q = FirebaseFirestore.instance
        .collection('global_ticket')
        .orderBy("time", descending: true)
        .limit(perPage);

    QuerySnapshot querySnapshot = await q.get();
    products = querySnapshot.docs;
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      loadingProducts = false;
    });
  }

  getMoreProducts() async {
    if (moreProductsAvaliable == false) {
      return;
    }
    if (gettingMoreProducts == true) {
      return;
    }

    gettingMoreProducts = true;

    Query q = FirebaseFirestore.instance
        .collection('global_ticket')
        .orderBy("time", descending: true)
        .startAfter([lastDocument["time"]]).limit(perPage);

    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < perPage) {
      moreProductsAvaliable = false;
    }
    try {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    } catch (e) {}

    products.addAll(querySnapshot.docs);

    setState(() {});
    gettingMoreProducts = false;
  }

  final connectivity = SnackBar(
    content: Text('No internet connection'),
    duration: Duration(hours: 5),
    backgroundColor: Colors.redAccent,
  );
  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;
  bool dialogshown = false;
  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  bool responded = false;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogshown = true;
        ScaffoldMessenger.of(context).showSnackBar(connectivity);
      } else if (_previousResult == ConnectivityResult.none) {
        checkinternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          }
        });
      }

      _previousResult = connresult;
    });
    adMobService.loadRewardedAd1();
    adMobService.loadRewardedAd2();
    getProducts();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        getMoreProducts();
      }
    });
  }

  Widget buildImage(String urlImage) {
    return Image.network(
      urlImage,
      cacheHeight: 250,
      cacheWidth: 150,
      fit: BoxFit.cover,
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 3));
    products.clear();
    getProducts();
  }

  callTicketOwner(String ticketOwnweMobileNumber) async {
    String phoneNo =
        'tel: ${ticketOwnweMobileNumber.substring(3, ticketOwnweMobileNumber.length)}';
    if (await canLaunch(phoneNo)) {
      await launch(phoneNo);
    } else {
      throw 'Could not launch $phoneNo';
    }
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Container(
      height: queryData.height,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
              icon: listView
                  ? Icon(MaterialCommunityIcons.view_dashboard_outline,
                      color: Constants.searchIcon)
                  : Icon(Icons.calendar_view_day_outlined,
                      color: Constants.searchIcon),
              onPressed: () {
                if (listView) {
                  setState(() {
                    listView = false;
                  });
                } else {
                  setState(() {
                    listView = true;
                  });
                }
              },
            ),
          ],
          title: Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Constants.textFieldBorder),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              readOnly: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          searchBar(widget.latitudeData, widget.longitudeData),
                    ));
              },
              autofocus: false,
              style: TextStyle(color: Constants.textFieldHintText),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Constants.searchIcon,
                ),
                hintText: "What are you looking for?",
                hintStyle: TextStyle(color: Constants.textFieldHintText),
              ),
            ),
          ),
        ),
        body: listView
            ? (loadingProducts)
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constants.searchIcon)),
                    ),
                  )
                : RefreshIndicator(
                    color: Constants.searchIcon,
                    onRefresh: _refreshData,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('global_ticket')
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            itemCount: products.length + 1,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              String description;
                              String title;

                              if (index < products.length) {
                                description = products[index]["description"];
                                title = products[index]["title"];
                              }

                              bool myFavFlag = false;

                              try {
                                List l =
                                    snapshot.data.docs[index]["favourites"];
                                if (l.contains(FirebaseAuth
                                    .instance.currentUser.phoneNumber)) {
                                  myFavFlag = true;
                                }
                              } catch (e) {
                                myFavFlag = false;
                              }

                              if (index == products.length) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Constants.searchIcon)));
                              }

                              // /+++++++++++++++++++++++++++++++++++++++++
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("global_ticket")
                                      .doc(products[index]["id"])
                                      .collection("responses")
                                      .doc(FirebaseAuth
                                          .instance.currentUser.phoneNumber)
                                      .snapshots(),
                                  builder: (context, snapshot2) {
                                    var userTicketDocument = snapshot2.data;
                                    try {
                                      responded =
                                          userTicketDocument["responseViaChat"];
                                    } catch (e) {
                                      responded = false;
                                    }

                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(CustomPageRouteAnimation(
                                          child: ticketViewScreen(
                                            products[index]["ticket_owner"],
                                            products[index]["title"],
                                            products[index]["description"],
                                            products[index]["id"],
                                            products[index]["uplodedPhoto"],
                                            products[index]["latitude"],
                                            products[index]["longitude"],
                                            products[index]["date"],
                                            products[index]["share_mobile"],
                                            myFavFlag,
                                            products[index]["address"],
                                            products[index]["category"],
                                          ),
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Neumorphic(
                                          style: NeumorphicStyle(
                                            intensity: .6,
                                            shape: NeumorphicShape.flat,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(12)),
                                            depth: 4,
                                            lightSource:
                                                LightSource.bottomRight,
                                            color: Colors.transparent,
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(),
                                              height: queryData.height * 0.25,
                                              width: queryData.width,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                      left: 10,
                                                      top: 10,
                                                      bottom: 10,
                                                      child: Container(
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20)),
                                                            child:
                                                                Image.network(
                                                              products[index][
                                                                  "uplodedPhoto"],
                                                              fit: BoxFit.cover,
                                                              cacheHeight: 200,
                                                              cacheWidth: 140,
                                                            )),
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: AssetImage(
                                                                    "loadingImage.png")),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20))),
                                                        height:
                                                            queryData.height *
                                                                0.2,
                                                        width: queryData.width *
                                                            0.39,
                                                      )),
                                                  Positioned(
                                                      left: 100,
                                                      bottom: 15,
                                                      child: Text(
                                                        products[index]["date"],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Positioned(
                                                      top: 10,
                                                      left: queryData.width *
                                                          0.47,
                                                      right: 10,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            title.length > 48
                                                                ? title.substring(
                                                                        0, 48) +
                                                                    "..."
                                                                : title,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .amber,
                                                                fontSize: 14),
                                                          ),
                                                          Divider(
                                                            height: 5,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                            child: Text(
                                                              description.length >
                                                                      35
                                                                  ? description
                                                                          .substring(
                                                                              0,
                                                                              35) +
                                                                      "..."
                                                                  : description,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white60),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                  Positioned(
                                                    bottom: 10,
                                                    left:
                                                        queryData.width * 0.47,
                                                    right: 10,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size: 15,
                                                            ),
                                                            Text(
                                                              products[index]
                                                                  ["address"],
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          height: 6,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        products[index][
                                                                    "ticket_owner"] !=
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    .phoneNumber
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Neumorphic(
                                                                    style:
                                                                        NeumorphicStyle(
                                                                      intensity:
                                                                          0.6,
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      boxShape:
                                                                          NeumorphicBoxShape
                                                                              .circle(),
                                                                      depth: 2,
                                                                      lightSource:
                                                                          LightSource
                                                                              .bottomRight,
                                                                      color: Colors
                                                                          .black12,
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          35,
                                                                      width: 35,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                      child: products[index]
                                                                              [
                                                                              "share_mobile"]
                                                                          ? IconButton(
                                                                              icon: Icon(
                                                                                Icons.call,
                                                                                size: 20,
                                                                                color: Colors.amber,
                                                                              ),
                                                                              onPressed: () {
                                                                                callTicketOwner(
                                                                                  products[index]["ticket_owner"],
                                                                                );
                                                                                databaseMethods.uploadTicketResponseByCall(
                                                                                  products[index]["id"],
                                                                                  responded,
                                                                                );
                                                                                adMobService.showRewardedAd1();
                                                                                adMobService.loadRewardedAd1();
                                                                              },
                                                                            )
                                                                          : Icon(
                                                                              Icons.phone_disabled,
                                                                              size: 20),
                                                                    ),
                                                                  ),
                                                                  Neumorphic(
                                                                    style:
                                                                        NeumorphicStyle(
                                                                      intensity:
                                                                          0.6,
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      boxShape:
                                                                          NeumorphicBoxShape
                                                                              .circle(),
                                                                      depth: 2,
                                                                      lightSource:
                                                                          LightSource
                                                                              .bottomRight,
                                                                      color: Colors
                                                                          .black12,
                                                                    ),
                                                                    child: Container(
                                                                        height: 35,
                                                                        width: 35,
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                                        child: !responded
                                                                            ? IconButton(
                                                                                icon: Icon(
                                                                                  FontAwesome.comments_o,
                                                                                  size: 20,
                                                                                  color: Colors.amber,
                                                                                ),
                                                                                onPressed: () {
                                                                                  _tripEditModalBottomSheet(
                                                                                    context,
                                                                                    products[index]["id"],
                                                                                    products[index]["ticket_owner"],
                                                                                    title,
                                                                                    products[index]["uplodedPhoto"],
                                                                                    products[index]["ticket_owner"],
                                                                                  );
                                                                                  adMobService.showRewardedAd2();
                                                                                  adMobService.loadRewardedAd2();
                                                                                },
                                                                              )
                                                                            : Icon(
                                                                                Icons.history,
                                                                                size: 20,
                                                                                color: Colors.amber,
                                                                              )),
                                                                  ),
                                                                  Neumorphic(
                                                                    style:
                                                                        NeumorphicStyle(
                                                                      intensity:
                                                                          0.6,
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      boxShape:
                                                                          NeumorphicBoxShape
                                                                              .circle(),
                                                                      depth: 2,
                                                                      lightSource:
                                                                          LightSource
                                                                              .bottomRight,
                                                                      color: Colors
                                                                          .black12,
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          35,
                                                                      width: 35,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          IconButton(
                                                                        icon: myFavFlag
                                                                            ? Icon(
                                                                                Icons.favorite,
                                                                                color: Constants.myFavIconTrue,
                                                                                size: 20,
                                                                              )
                                                                            : Icon(
                                                                                Icons.favorite_border,
                                                                                size: 20,
                                                                                color: Colors.amber,
                                                                              ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (myFavFlag) {
                                                                              myFavFlag = false;
                                                                              databaseMethods.undomyFavourite(
                                                                                snapshot.data.docs[index]["id"],
                                                                              );
                                                                            } else {
                                                                              myFavFlag = true;
                                                                              databaseMethods.myFavourites(
                                                                                snapshot.data.docs[index]["id"],
                                                                              );
                                                                            }
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : Text(""),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          );
                        }),
                  )
            : RefreshIndicator(
                color: Constants.searchIcon,
                onRefresh: _refreshData,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('global_ticket')
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: (loadingProducts)
                            ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Constants.searchIcon)),
                                ),
                              )
                            : Container(
                                child: StaggeredGridView.countBuilder(
                                  crossAxisCount: 4,
                                  itemCount: moreProductsAvaliable
                                      ? products.length + 2
                                      : products.length,
                                  controller: scrollController,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String title = products[index]["title"];
                                    String address = products[index]["address"];
                                    String description =
                                        products[index]["description"];

                                    bool myFavFlag = false;

                                    try {
                                      List l = snapshot.data.docs[index]
                                          ["favourites"];
                                      if (l.contains(FirebaseAuth
                                          .instance.currentUser.phoneNumber)) {
                                        myFavFlag = true;
                                      }
                                    } catch (e) {
                                      myFavFlag = false;
                                    }

                                    return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("global_ticket")
                                            .doc(products[index]["id"])
                                            .collection("responses")
                                            .doc(FirebaseAuth.instance
                                                .currentUser.phoneNumber)
                                            .snapshots(),
                                        builder: (context, snapshot2) {
                                          var userTicketDocument =
                                              snapshot2.data;
                                          try {
                                            responded = userTicketDocument[
                                                "responseViaChat"];
                                          } catch (e) {
                                            responded = false;
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ticketViewScreen(
                                                      products[index]
                                                          ["ticket_owner"],
                                                      products[index]["title"],
                                                      products[index]
                                                          ["description"],
                                                      products[index]["id"],
                                                      products[index]
                                                          ["uplodedPhoto"],
                                                      products[index]
                                                          ["latitude"],
                                                      products[index]
                                                          ["longitude"],
                                                      products[index]["date"],
                                                      products[index]
                                                          ["share_mobile"],
                                                      myFavFlag,
                                                      products[index]
                                                          ["address"],
                                                      products[index]
                                                          ["category"],
                                                    ),
                                                  ));
                                            },
                                            child: Stack(
                                              children: [
                                                Neumorphic(
                                                  style: NeumorphicStyle(
                                                    intensity: .6,
                                                    shape: NeumorphicShape.flat,
                                                    boxShape: NeumorphicBoxShape
                                                        .roundRect(BorderRadius
                                                            .circular(20)),
                                                    depth: 3,
                                                    lightSource:
                                                        LightSource.bottomRight,
                                                    color: Colors.transparent,
                                                  ),
                                                  child: new Container(
                                                      height: 400,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[800],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: new Center(
                                                        child: Column(
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(20),
                                                                          topRight:
                                                                              Radius.circular(20),
                                                                        ),
                                                                        child:
                                                                            buildImage(
                                                                          products[index]
                                                                              [
                                                                              "uplodedPhoto"],
                                                                        ),
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(fit: BoxFit.cover, image: AssetImage("loadingImage.png")),
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                          )),
                                                                      height: queryData
                                                                          .height,
                                                                      width: queryData
                                                                          .width,
                                                                    ),
                                                                    Positioned(
                                                                      right: 5,
                                                                      bottom: 4,
                                                                      child:
                                                                          Text(
                                                                        products[index]
                                                                            [
                                                                            "date"],
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Constants.date),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Divider(
                                                              height: 2,
                                                              thickness: 1,
                                                              color: Constants
                                                                  .divider,
                                                            ),
                                                            Container(
                                                              height: 70,
                                                              width: queryData
                                                                  .width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      title.length >
                                                                              23
                                                                          ? "  " +
                                                                              title.substring(0,
                                                                                  23) +
                                                                              ".."
                                                                          : "  " +
                                                                              title,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Constants
                                                                            .titleText,
                                                                      )),
                                                                  Text(
                                                                    description.length >
                                                                            20
                                                                        ? "  " +
                                                                            description.substring(0,
                                                                                20) +
                                                                            ".."
                                                                        : "  " +
                                                                            description,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Constants
                                                                            .descriptionText),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                Positioned(
                                                    right: 0,
                                                    child: snapshot.data
                                                                    .docs[index]
                                                                [
                                                                "ticket_owner"] !=
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .phoneNumber
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[800],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            child: IconButton(
                                                              icon: myFavFlag
                                                                  ? Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Constants
                                                                          .myFavIconTrue,
                                                                      size: 20,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      size: 20,
                                                                      color: Constants
                                                                          .myFavIconFalse,
                                                                    ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (myFavFlag) {
                                                                    databaseMethods
                                                                        .undomyFavourite(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]["id"],
                                                                    );
                                                                    myFavFlag =
                                                                        false;
                                                                  } else {
                                                                    databaseMethods
                                                                        .myFavourites(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]["id"],
                                                                    );
                                                                    myFavFlag =
                                                                        true;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          )
                                                        : Text("")),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5,
                                                            right: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8,
                                                                  left: 8),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color: Constants
                                                                    .locationMarker,
                                                                size: 15,
                                                              ),
                                                              Text(
                                                                address.length >
                                                                        7
                                                                    ? address.substring(
                                                                            0,
                                                                            8) +
                                                                        ".."
                                                                    : address,
                                                                style: TextStyle(
                                                                    color: Constants
                                                                        .addressText,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        products[index][
                                                                    "ticket_owner"] !=
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    .phoneNumber
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Neumorphic(
                                                                    style:
                                                                        NeumorphicStyle(
                                                                      intensity:
                                                                          0.6,
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      boxShape:
                                                                          NeumorphicBoxShape
                                                                              .circle(),
                                                                      depth: 2,
                                                                      lightSource:
                                                                          LightSource
                                                                              .bottomRight,
                                                                      color: Colors
                                                                          .black12,
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          35,
                                                                      width: 35,
                                                                      decoration: BoxDecoration(
                                                                          // color: Colors.red,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: products[index]
                                                                              [
                                                                              "share_mobile"]
                                                                          ? IconButton(
                                                                              icon: Icon(
                                                                                Icons.call,
                                                                                size: 20,
                                                                                color: Colors.amber,
                                                                              ),
                                                                              onPressed: () {
                                                                                callTicketOwner(
                                                                                  products[index]["ticket_owner"],
                                                                                );
                                                                                databaseMethods.uploadTicketResponseByCall(
                                                                                  products[index]["id"],
                                                                                  responded,
                                                                                );
                                                                                adMobService.showRewardedAd1();
                                                                                adMobService.loadRewardedAd1();
                                                                              },
                                                                            )
                                                                          : Icon(
                                                                              Icons.phone_disabled,
                                                                              size: 20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Neumorphic(
                                                                    style:
                                                                        NeumorphicStyle(
                                                                      intensity:
                                                                          0.6,
                                                                      // surfaceIntensity: 1,
                                                                      // border: NeumorphicBorder(),
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      boxShape:
                                                                          NeumorphicBoxShape
                                                                              .circle(),

                                                                      depth: 2,
                                                                      lightSource:
                                                                          LightSource
                                                                              .bottomRight,
                                                                      color: Colors
                                                                          .black12,
                                                                    ),
                                                                    child: Container(
                                                                        height: 35,
                                                                        width: 35,
                                                                        decoration: BoxDecoration(
                                                                            // color: Colors.red,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: !responded
                                                                            ? IconButton(
                                                                                icon: Icon(
                                                                                  FontAwesome.comments_o,
                                                                                  size: 20,
                                                                                  color: Colors.amber,
                                                                                ),
                                                                                onPressed: () {
                                                                                  _tripEditModalBottomSheet(
                                                                                    context,
                                                                                    products[index]["id"],
                                                                                    products[index]["ticket_owner"],
                                                                                    title,
                                                                                    products[index]["uplodedPhoto"],
                                                                                    products[index]["ticket_owner"],
                                                                                  );
                                                                                  adMobService.showRewardedAd2();
                                                                                  adMobService.loadRewardedAd2();
                                                                                },
                                                                              )
                                                                            : Icon(
                                                                                Icons.history,
                                                                                size: 20,
                                                                                color: Colors.amber,
                                                                              )),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(""),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.count(
                                          2, index.isEven ? 3.2 : 3.8),
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                ),
                              ),
                      );
                    }),
              ),
      ),
    );
  }
}

class searchBar extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  searchBar(this.latitudeData, this.longitudeData);

  @override
  _searchBarState createState() => _searchBarState();
}

TextEditingController searchController = TextEditingController();

class _searchBarState extends State<searchBar> {
  String _chosenValue;
  int kms = 0;
  @override
  void initState() {
    ticketsWithinDistance = 30;
    searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length));
    super.initState();
  }

  getCurrentLocation() async {
    try {
      final geoposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        latitudeData1 = geoposition.latitude;
        longitudeData1 = geoposition.longitude;
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    searchController.clear();
    super.dispose();
  }

  int textFieldTextLength = 0;
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: queryData.width,
              color: Colors.grey[900],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: queryData.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Constants.textFieldBorder),
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      textFieldTextLength = searchController.text.length;
                    });
                  },
                  autofocus: true,
                  style: TextStyle(color: Constants.textFieldHintText),
                  controller: searchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefixIcon: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Constants.searchIcon,
                          ),
                          onPressed: () {
                            setState(() {
                              sc = searchController.text;
                            });
                            // searchController.clear();
                            Navigator.pop(context);
                          }),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: DropdownButton<int>(
                          icon: Icon(Icons.gps_fixed,
                              color: kms == 0 ? Colors.grey : Colors.blue),
                          focusColor: Colors.white,
                          // value: kms,
                          //elevation: 5,
                          underline: SizedBox(),
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: <int>[
                            5,
                            20,
                            40,
                            100,
                            500,
                          ].map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                '$value KM',
                                style: TextStyle(color: Constants.searchIcon),
                              ),
                            );
                          }).toList(),

                          onTap: () {
                            getCurrentLocation();
                          },
                          onChanged: (int value) {
                            setState(() {
                              kms = value;
                            });
                          },
                        ),
                      ),
                      hintText: "What are you looking for?",
                      hintStyle: TextStyle(
                        color: Constants.textFieldHintText,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 40,
                width: queryData.width,
                color: Colors.amber,
                child: Center(
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    value: _chosenValue,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'I am a man seeking a women',
                      'I am a women seeking a men',
                      'I am a men seeking a men',
                      'I am a women seeking a women',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.amber),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Dating, romance, long term relationship(LTR)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        searchController.text = value;
                        textFieldTextLength = searchController.text.length;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Container(
                height: 40,
                width: queryData.width,
                color: Colors.amber,
                child: Center(
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValue,
                    underline: SizedBox(),
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'I am a man looking for a women',
                      'I am looking for fetish encounters',
                      'I am a men looking for a men',
                      'I am a transsexual looking for a men',
                      'We are a couple looking for a women',
                      'We are a couple looking for a men',
                      'We are a couple looking for another couple',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.amber),
                        ),
                      );
                    }).toList(),
                    hint: Center(
                      child: Text(
                        "sex with no string attached(NSA)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        searchController.text = value;
                        textFieldTextLength = searchController.text.length;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Container(
                height: 40,
                width: queryData.width,
                color: Colors.amber,
                child: Center(
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValue,
                    underline: SizedBox(),
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'BDSM & Fetish',
                      'Massage Parlours',
                      'Adult Jobs',
                      'Erotic Bars & Clubs',
                      'Erotic Phone & Cam Services',
                      'Erotic Photography',
                      'Other Personals Services',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.amber),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Erotic services (messages, strippers, etc)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        searchController.text = value;
                        textFieldTextLength = searchController.text.length;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 3),
                borderRadius: BorderRadius.circular(40),
                color: (textFieldTextLength != 0 || kms != 0)
                    ? Colors.amber
                    : Colors.grey[800],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: (textFieldTextLength != 0 || kms != 0)
                      ? Colors.black
                      : Colors.white,
                  size: 60,
                ),
                onPressed: () {
                  if (textFieldTextLength != 0 || kms != 0) {
                    AdMobService.createInterstitialAd1();
                    setState(() {
                      ticketsWithinDistance = kms * 1000;
                      sc = searchController.text;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => searchBox(widget.latitudeData,
                              widget.longitudeData, searchController.text, kms),
                        ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
