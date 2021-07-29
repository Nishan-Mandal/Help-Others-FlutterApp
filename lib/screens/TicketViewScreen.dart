import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:help_others/screens/ChatRoom.dart';

import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/screens/SeeProfileOfTicketOwner.dart';
import 'package:help_others/services/AdMob.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/Database.dart';
import 'package:provider/provider.dart';
import 'package:help_others/services/BannerAds.dart';
import 'package:url_launcher/url_launcher.dart';

class ticketViewScreen extends StatefulWidget {
  String ticketOwnweMobileNumber;
  String title;
  String description;
  String id;
  String photo;
  double latitude;
  double longitude;
  String date;
  bool shareMobileNumber;
  bool myFavFlag;
  String address;
  String category;
  ticketViewScreen(
      this.ticketOwnweMobileNumber,
      this.title,
      this.description,
      this.id,
      this.photo,
      this.latitude,
      this.longitude,
      this.date,
      this.shareMobileNumber,
      this.myFavFlag,
      this.address,
      this.category);

  @override
  _ticketViewScreenState createState() => _ticketViewScreenState();
}

class _ticketViewScreenState extends State<ticketViewScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AdMobService adMobService = new AdMobService();
  final TextEditingController messageControler = TextEditingController();
  bool responded = false;

  @override
  void initState() {
    super.initState();
    adMobService.loadRewardedAd();
  }

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

  Future<void> sendMessageFromGivenKeywords(
    String text,
  ) async {
    var name;
    databaseMethods.uploadTicketResponse("comment", widget.id, false,
        widget.ticketOwnweMobileNumber, true, widget.title, text);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => chatRoom(
            widget.id,
            widget.ticketOwnweMobileNumber,
            widget.title,
            widget.id,
            name,
            widget.photo,
            widget.ticketOwnweMobileNumber,
          ),
        ));
  }

  void _tripEditModalBottomSheet(context) {
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
                                child: Text("Hello"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  sendMessageFromGivenKeywords("Hello");
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text("Are you available"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  sendMessageFromGivenKeywords(
                                      "Are you available");
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text("Let's talk"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: () {
                                  sendMessageFromGivenKeywords("Let's talk");
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                child: Text("Let's meet"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
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
            });
      },
    );
  }

  BannerAd banner;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<BannerAds>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnit,
            listener: adState.adListener,
            request: AdRequest())
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return StreamBuilder(
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
                return Scaffold(
                  // bottomSheet: Container(
                  //   color: Colors.red,
                  //   height: 50,
                  //   width: 300,
                  //   child: AdWidget(
                  //     key: UniqueKey(),
                  //     ad: AdMobService.createBannerAd()..load(),
                  //   ),
                  // ),
                  backgroundColor: Constants.tscaffoldBackground,
                  floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 80),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .pop(navigationBar()),
                                ),
                              )),
                          SizedBox(
                            width: queryData.width * 0.6,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: widget.ticketOwnweMobileNumber !=
                                      FirebaseAuth
                                          .instance.currentUser.phoneNumber
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 80),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Constants.tmyFavIconBackground,
                                            borderRadius:
                                                BorderRadius.circular(90)),
                                        child: IconButton(
                                          icon: widget.myFavFlag
                                              ? Icon(
                                                  Icons.favorite,
                                                  color:
                                                      Constants.tmyFavIconTrue,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.favorite_border,
                                                  size: 20,
                                                  color:
                                                      Constants.tmyFavIconFalse,
                                                ),
                                          onPressed: () {
                                            setState(() {
                                              if (widget.myFavFlag) {
                                                databaseMethods.undomyFavourite(
                                                  widget.id,
                                                );
                                                widget.myFavFlag = false;
                                              } else {
                                                databaseMethods.myFavourites(
                                                  widget.id,
                                                );
                                                widget.myFavFlag = true;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  : Text("              "))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38),
                        child: Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                    visible: widget.ticketOwnweMobileNumber !=
                                            FirebaseAuth.instance.currentUser
                                                .phoneNumber
                                        ? true
                                        : false,
                                    child: !responded
                                        ? SizedBox(
                                            width: queryData.width * 0.35,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Constants.tChatbutton,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.chat,
                                                    color: Constants
                                                        .tChatbuttonText,
                                                  ),
                                                  Text(
                                                    "  Chat",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .tChatbuttonText),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                // adMobService.loadRewardedAd();
                                                // adMobService.showRewardedAd();
                                                setState(() {
                                                  _tripEditModalBottomSheet(
                                                      context);
                                                });
                                              },
                                            ),
                                          )
                                        : SizedBox(
                                            width: queryData.width * 0.35,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Constants.tChatbutton,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              ),
                                              child: Text(
                                                "Chat History",
                                                style: TextStyle(
                                                    color: Constants
                                                        .tChatbuttonText,
                                                    fontSize: 13),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            chatRoom(
                                                          widget.id,
                                                          widget
                                                              .ticketOwnweMobileNumber,
                                                          widget.title,
                                                          widget.id,
                                                          userAccount["name"],
                                                          widget.photo,
                                                          widget
                                                              .ticketOwnweMobileNumber,
                                                        ),
                                                      ));
                                                });
                                              },
                                            ),
                                          )),
                                SizedBox(
                                  width: queryData.width * 0.15,
                                ),
                                Visibility(
                                  visible: widget.ticketOwnweMobileNumber !=
                                          FirebaseAuth
                                              .instance.currentUser.phoneNumber
                                      ? true
                                      : false,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: queryData.width * 0.35,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              primary: widget.shareMobileNumber
                                                  ? Constants.tChatbutton
                                                  : Constants
                                                      .tDisableCallButton,
                                            ),
                                            onPressed: () {
                                              if (widget.shareMobileNumber) {
                                                adMobService.loadRewardedAd();
                                                adMobService.showRewardedAd();
                                                callTicketOwner();
                                                databaseMethods
                                                    .uploadTicketResponseByCall(
                                                        "",
                                                        widget.id,
                                                        false,
                                                        widget
                                                            .ticketOwnweMobileNumber,
                                                        false);
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.call,
                                                    color: widget.shareMobileNumber
                                                        ? Constants
                                                            .tChatbuttonText
                                                        : Constants
                                                            .tDisableCallButtonText),
                                                Text(
                                                  "   Call",
                                                  style: TextStyle(
                                                    color: widget.shareMobileNumber
                                                        ? Constants
                                                            .tChatbuttonText
                                                        : Constants
                                                            .tDisableCallButtonText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  body: Container(
                    child:
                        // StreamBuilder(
                        //     stream: FirebaseFirestore.instance
                        //         .collection("user_account")
                        //         .doc(widget.ticketOwnweMobileNumber)
                        //         .snapshots(),
                        //     builder: (context, snapshot) {
                        //       var userAccount = snapshot.data;

                        //       return
                        // StreamBuilder(
                        //     stream: FirebaseFirestore.instance
                        //         .collection("global_ticket")
                        //         .doc(widget.id)
                        //         .collection("responses")
                        //         .doc(FirebaseAuth.instance.currentUser.phoneNumber)
                        //         .snapshots(),
                        //     builder: (context, snapshot2) {
                        //       var userTicketDocument = snapshot2.data;
                        //       try {
                        //         responded = userTicketDocument["responded"];
                        //       } catch (e) {
                        //         responded = false;
                        //       }
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: queryData.width,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey[900],
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
                                      image: DecorationImage(
                                          image: NetworkImage(widget.photo)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: Constants.adPhotoContainer)),
                                  height: 250,
                                  width: queryData.width,
                                  // child: CachedNetworkImage(
                                  //   imageUrl: widget.photo,
                                  //   placeholder: (context, url) => Center(
                                  //       child: CircularProgressIndicator()),
                                  //   errorWidget: (context, url, error) =>
                                  //       Icon(Icons.error),
                                  // ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    widget.title,
                                    style: TextStyle(
                                        color: Constants.tTitleText,
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
                                          color:
                                              Constants.tDescriptionBoxString,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minHeight: queryData.height / 4),
                                    width: queryData.width,
                                    color: Constants.tDescriptionBox,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(widget.description,
                                          style: TextStyle(
                                              color: Constants.tDescriptionText,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                                //     // https://www.google.com/maps/place/Newtown,+Kolkata,+West+Bengal/@22.5861408,88.4227606,12z/data=!3m1!4b1!4m5!3m4!1s0x3a0275350398a5b9:0x75e165b244323425!8m2!3d22.5753931!4d88.4797903
                                //     // RaisedButton(
                                //     //   child: Text("map"),
                                //     //   onPressed: () {
                                //     //     mapInBrowser(
                                //     //         // "http://maps.google.com/maps?daddr=${widget.latitude},${widget.longitude}");
                                //     //         // "https://www.google.com/maps/dir//${widget.latitude},${widget.longitude}/@${widget.latitude},${widget.longitude},12z");
                                //     //         "https://www.google.com/maps/place/@${widget.latitude},${widget.longitude},12z/data=!3m1!4b1!4m5!3m4!1s0x3a0275350398a5b9:0x75e165b244323425!8m2!3d${widget.latitude}!4d${widget.longitude}");
                                //     //   },
                                //     // ),
                                // SizedBox(
                                //   height: 50,
                                //   width: queryData.width,
                                //   child: AdWidget(
                                //     // key: UniqueKey(),
                                //     ad: AdMobService.createBannerAd3()..load(),
                                //   ),
                                // ),
                                banner != null
                                    ? SizedBox(
                                        height: 60,
                                        width: queryData.width,
                                        child: AdWidget(
                                          // key: UniqueKey(),
                                          ad: banner,
                                        ),
                                      )
                                    : SizedBox(),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, left: 12.0, top: 12.0),
                                  child: Text(
                                    "Ad posted at",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constants.tAdpostAt),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => mapInBrowser(
                                      "https://www.google.com/maps/preview/@${widget.latitude},${widget.longitude},17z"
                                      // "https://www.google.com/maps/place/@${widget.latitude},${widget.longitude},${widget.latitude}${widget.longitude}"
                                      // "http://maps.google.com/maps?daddr=${widget.latitude},${widget.longitude}"
                                      // "https://www.google.com/maps/dir//${widget.latitude},${widget.longitude}"
                                      ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          height: 70,
                                          width: queryData.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: AssetImage("map.jpg"),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          left: 40,
                                          bottom: 25,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                            ),
                                            child: Container(
                                              width: queryData.width * 0.70,
                                              height: 40,
                                              color: Constants.tlocationSticker,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color:
                                                        Constants.tlocationIcon,
                                                    size: 25,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "  Location",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Constants
                                                                .tlocationTextString),
                                                      ),
                                                      Text(
                                                        widget.address,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Constants
                                                                .tlocationText),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),

                                //     // Visibility(
                                //     //   visible: userAccount["mobile_number"] !=
                                //     //           FirebaseAuth
                                //     //               .instance.currentUser.phoneNumber
                                //     //       ? true
                                //     //       : false,
                                //     // child:
                                //     // Padding(
                                //     //   padding: const EdgeInsets.all(12.0),
                                //     // child:
                                Container(
                                  width: queryData.width,
                                  height: queryData.height * 0.07,
                                  color: Constants.tSeeProfileContainer,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 6),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Constants.tSeeProfileSticker,
                                        // borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: CircleAvatar(
                                              minRadius: 40,
                                              backgroundImage: NetworkImage(
                                                userAccount["photo"],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(userAccount["name"],
                                                    style: TextStyle(
                                                        color: Constants
                                                            .tNameInSeeProfile,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
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
                                                        ));
                                                  },
                                                  child: Text("SEE PROFILE",
                                                      style: TextStyle(
                                                        color: Constants
                                                            .tSeeProfileText,
                                                        fontSize: 15,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // banner != null
                                //     ? SizedBox(
                                //         height: 60,
                                //         width: queryData.width,
                                //         child: AdWidget(
                                //           // key: UniqueKey(),
                                //           ad: banner,
                                //         ),
                                //       )
                                //     : SizedBox(),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Divider(
                                    thickness: 3,
                                    color: Constants.tdivider,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "   Related Advertisement:",
                                      style: TextStyle(
                                          color: Constants.tRelatedAds,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  width: queryData.width,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('global_ticket')
                                          .where("category",
                                              isEqualTo: widget.category)
                                          // .where(
                                          //   "id",
                                          //   isNotEqualTo: (widget.id),
                                          // )
                                          // .orderBy("time", descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot3) {
                                        if (snapshot3.hasData) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                snapshot3.data.docs.length,
                                            itemBuilder: (context, index) {
                                              String title = snapshot3
                                                  .data.docs[index]["title"];
                                              String description = snapshot3
                                                  .data
                                                  .docs[index]["description"];

                                              return snapshot3.data.docs[index]
                                                          ["id"] !=
                                                      widget.id
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ticketViewScreen(
                                                                    snapshot3.data.docs[index][
                                                                        "ticket_owner"],
                                                                    snapshot3
                                                                            .data
                                                                            .docs[index][
                                                                        "title"],
                                                                    snapshot3
                                                                            .data
                                                                            .docs[index][
                                                                        "description"],
                                                                    snapshot3
                                                                            .data
                                                                            .docs[index]
                                                                        ["id"],
                                                                    snapshot3
                                                                            .data
                                                                            .docs[index][
                                                                        "uplodedPhoto"],
                                                                    snapshot3
                                                                        .data
                                                                        .docs[index]["latitude"],
                                                                    snapshot3.data.docs[index]["longitude"],
                                                                    snapshot3.data.docs[index]["date"],
                                                                    snapshot3.data.docs[index]["share_mobile"],
                                                                    false,
                                                                    snapshot3.data.docs[index]["address"],
                                                                    snapshot3.data.docs[index]["category"]),
                                                              ));
                                                        },
                                                        child: Container(
                                                            height: 50,
                                                            width: 180,
                                                            decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight,
                                                                    colors: Constants
                                                                        .gradientColorOnAd),
                                                                border: Border
                                                                    .all(),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    height: 180,
                                                                    width: 160,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(20),
                                                                        topRight:
                                                                            Radius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Image(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: NetworkImage(snapshot3
                                                                            .data
                                                                            .docs[index]["uplodedPhoto"]),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    title.length >
                                                                            20
                                                                        ? title.substring(0,
                                                                                20) +
                                                                            "..."
                                                                        : title,
                                                                    style: TextStyle(
                                                                        color: Constants
                                                                            .titleText,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8),
                                                                  child: Text(
                                                                      description.length >
                                                                              20
                                                                          ? description.substring(0, 20) +
                                                                              "..."
                                                                          : description,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Constants
                                                                            .descriptionText,
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      top: 12),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.location_on_outlined,
                                                                            color:
                                                                                Constants.addressText,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            snapshot3.data.docs[index]["address"],
                                                                            style:
                                                                                TextStyle(color: Constants.locationMarker, fontSize: 12),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20),
                                                                        child:
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
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    )
                                                  : Text("");
                                            },
                                          );
                                        }
                                      }),
                                ),
                                SizedBox(
                                  height: 70,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // }),
                  ),
                );
              });
        });
  }
}
