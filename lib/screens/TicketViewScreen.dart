import 'dart:ui';

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
  bool respondedViaCall = false;
  int callAdCounter = 0;
  String idInMessageCollection;

  @override
  void initState() {
    super.initState();
    adMobService.loadRewardedAd3();
    adMobService.loadRewardedAd4();
    databaseMethods.totalViewsInAd(widget.id, widget.ticketOwnweMobileNumber);
  }

  getMessageCollectionId() async {
    await FirebaseFirestore.instance
        .collection("messages")
        .where("participants",
            arrayContains: FirebaseAuth.instance.currentUser.phoneNumber)
        .where("ticketId", isEqualTo: widget.id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          idInMessageCollection = element.get("id");
        });
      });
    });
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
    Navigator.pop(context);
    showOverlay(context);
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
    databaseMethods.uploadTicketResponse(
        widget.id,
        widget.ticketOwnweMobileNumber,
        widget.title,
        text,
        name,
        widget.photo,
        widget.ticketOwnweMobileNumber,
        context,
        respondedViaCall);
  }

  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constants.searchIcon)),
            ));

    overlayState.insert(overlayEntry);

    await Future.delayed(Duration(seconds: 3));

    overlayEntry.remove();
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
                                  sendMessageFromGivenKeywords("Hello");
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
                                  sendMessageFromGivenKeywords("Let's talk");
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

  BannerAd banner;
  BannerAd banner2;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getMessageCollectionId();
    final adState = Provider.of<BannerAds>(context);
    final adState2 = Provider.of<BannerAds>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
            size: AdSize.mediumRectangle,
            adUnitId: adState.bannerAdUnit,
            listener: adState.adListener,
            request: AdRequest())
          ..load();
      });
    });
    adState2.initialization.then((value) {
      setState(() {
        banner2 = BannerAd(
            size: AdSize.mediumRectangle,
            adUnitId: adState2.bannerAdUnit2,
            listener: adState2.adListener,
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
                  responded = userTicketDocument["responseViaChat"];
                } catch (e) {
                  responded = false;
                }
                try {
                  respondedViaCall = userTicketDocument["responseViaCall"];
                } catch (e) {
                  respondedViaCall = false;
                }
                return Scaffold(
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
                                  : Text("             "))
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
                                            width: queryData.width * 0.40,
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
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.chat,
                                                    color: Constants
                                                        .tChatbuttonText,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    "Chat Request",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .tChatbuttonText),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                _tripEditModalBottomSheet(
                                                    context);

                                                adMobService.showRewardedAd3();
                                                adMobService.loadRewardedAd3();
                                              },
                                            ),
                                          )
                                        : SizedBox(
                                            width: queryData.width * 0.40,
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
                                                children: [
                                                  Icon(
                                                    Icons.history,
                                                    color: Constants
                                                        .tChatbuttonText,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "Chat History",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .tChatbuttonText,
                                                        fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          chatRoom(
                                                        widget.id,
                                                        widget
                                                            .ticketOwnweMobileNumber,
                                                        widget.title,
                                                        idInMessageCollection,
                                                        userAccount["name"],
                                                        widget.photo,
                                                        widget
                                                            .ticketOwnweMobileNumber,
                                                      ),
                                                    ));
                                                AdMobService
                                                    .createInterstitialAd2();
                                                AdMobService
                                                    .showInterstitialAd2();
                                              },
                                            ),
                                          )),
                                SizedBox(
                                  width: queryData.width * 0.05,
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
                                          width: queryData.width * 0.40,
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
                                                callTicketOwner();
                                                databaseMethods
                                                    .uploadTicketResponseByCall(
                                                  widget.id,
                                                  responded,
                                                );

                                                adMobService.showRewardedAd4();
                                                adMobService.loadRewardedAd4();
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
                  body: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: queryData.width,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey[900],
                                offset: Offset(0, 0),
                              ),
                            ]),
                            alignment: Alignment.bottomLeft,
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
                                              colors:
                                                  Constants.adPhotoContainer)),
                                      height: 250,
                                      width: queryData.width,
                                      child: Image.network(
                                        widget.photo,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress != null) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Constants.searchIcon),
                                              ),
                                            );
                                          }
                                          return child;
                                        },
                                      )),
                                  Divider(
                                    thickness: 1,
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
                                  Divider(
                                    thickness: 1,
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
                                                color:
                                                    Constants.tDescriptionText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
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
                                        "https://www.google.com/maps/preview/@${widget.latitude},${widget.longitude},17z"),
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
                                                color:
                                                    Constants.tlocationSticker,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Constants
                                                          .tlocationIcon,
                                                      size: 25,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                  Divider(
                                    thickness: 2,
                                  ),
                                  banner != null
                                      ? SizedBox(
                                          height: 250,
                                          width: queryData.width,
                                          child: AdWidget(
                                            ad: banner,
                                          ),
                                        )
                                      : SizedBox(),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Container(
                                      width: queryData.width,
                                      height: queryData.height * 0.07,
                                      color: Constants.tSeeProfileContainer,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 6, bottom: 6),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Constants.tSeeProfileSticker,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: CircleAvatar(
                                                  minRadius: 40,
                                                  backgroundImage: NetworkImage(
                                                    userAccount["photo"],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
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
                                                                FontWeight
                                                                    .bold)),
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
                                  ),
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
                                            .snapshots(),
                                        // ignore: missing_return
                                        builder: (context, snapshot3) {
                                          if (snapshot3.hasData) {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              itemCount:
                                                  snapshot3.data.docs.length,
                                              itemBuilder: (context, index) {
                                                String title = snapshot3
                                                    .data.docs[index]["title"];
                                                String description = snapshot3
                                                    .data
                                                    .docs[index]["description"];
                                                String address = snapshot3.data
                                                    .docs[index]["address"];
                                                return snapshot3.data
                                                                .docs[index]
                                                            ["id"] !=
                                                        widget.id
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ticketViewScreen(
                                                                      snapshot3
                                                                              .data
                                                                              .docs[index][
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
                                                                          [
                                                                          "id"],
                                                                      snapshot3
                                                                          .data
                                                                          .docs[index]["uplodedPhoto"],
                                                                      snapshot3.data.docs[index]["latitude"],
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
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
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
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          180,
                                                                      width:
                                                                          160,
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(fit: BoxFit.cover, image: AssetImage("loadingImage.png")),
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                          )),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(20),
                                                                          topRight:
                                                                              Radius.circular(20),
                                                                        ),
                                                                        child: Image
                                                                            .network(
                                                                          snapshot3
                                                                              .data
                                                                              .docs[index]["uplodedPhoto"],
                                                                          cacheHeight:
                                                                              250,
                                                                          cacheWidth:
                                                                              150,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    height: 2,
                                                                    thickness:
                                                                        1,
                                                                    color: Constants
                                                                        .divider,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      title.length >
                                                                              20
                                                                          ? title.substring(0, 20) +
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
                                                                        left:
                                                                            8),
                                                                    child: Text(
                                                                        description.length >
                                                                                20
                                                                            ? description.substring(0, 20) +
                                                                                "..."
                                                                            : description,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Constants.descriptionText,
                                                                        )),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        top: 8),
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
                                                                              color: Constants.addressText,
                                                                              size: 15,
                                                                            ),
                                                                            Text(
                                                                              address.length > 7 ? address.substring(0, 8) + ".." : address,
                                                                              style: TextStyle(color: Constants.locationMarker, fontSize: 12),
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
                                                                                snapshot3.data.docs[index]["share_mobile"] ? Icons.call : Icons.phone_disabled,
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
                                  Divider(
                                    thickness: 2,
                                  ),
                                  banner2 != null
                                      ? SizedBox(
                                          height: 250,
                                          width: queryData.width,
                                          child: AdWidget(
                                            ad: banner2,
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
