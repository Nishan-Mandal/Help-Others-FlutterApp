import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:help_others/main.dart';
import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/services/AdMob.dart';
import 'package:help_others/services/BannerAds.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/CustomPageRoute.dart';

import 'package:help_others/services/Database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../main.dart';

class categoryPage extends StatefulWidget {
  double latitudeData;
  double longitudeData;

  categoryPage(
    this.latitudeData,
    this.longitudeData,
  );
  @override
  _categoryPageState createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  getCurrentLocation() async {
    try {
      final geoposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        latitudeData1 = geoposition.latitude;
        longitudeData1 = geoposition.longitude;
      });
    } catch (e) {
      if (this.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => navigationBar(),
            ),
            (route) => false);
      }
    }
  }

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: onBackPress,
        child: AlertDialog(
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          title: Text("This will need your location"),
          // backgroundColor: Colors.amber[300],
          actions: [
            TextButton(
              child: Text("No, Thanks"),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigationBar(),
                  ),
                  (route) => false),
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context, false);
                getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  // bool isLocationServiceEnabled = false;
  Future<void> checkLocationEnable() async {
    bool locationEnable = await Geolocator.isLocationServiceEnabled();

    if (locationEnable) {
      getCurrentLocation();
    } else {
      _showDialog();
    }
  }

  Future<bool> onBackPress() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => navigationBar(),
        ),
        (route) => false);
  }

  @override
  void initState() {
    checkLocationEnable();
    super.initState();
  }

  BannerAd banner3;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<BannerAds>(context);
    adState.initialization.then((value) {
      setState(() {
        banner3 = BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnit3,
            listener: adState.adListener,
            request: AdRequest())
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBackPress,
      child: Material(
        child: Scaffold(
          backgroundColor: Constants.scaffoldBackground,
          appBar: AppBar(
            title: Text(
              "Choose Category",
              style: TextStyle(color: Constants.searchIcon),
            ),
            backgroundColor: Constants.appBar,
          ),
          bottomSheet: banner3 != null
              ? Container(
                  color: Constants.scaffoldBackground,
                  height: 50,
                  width: queryData.width,
                  child: AdWidget(
                    ad: banner3,
                  ),
                )
              : SizedBox(),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CustomPageRouteAnimation(
                        child: category3(
                            widget.latitudeData, widget.longitudeData),
                      ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => category1(
                      //           widget.latitudeData, widget.longitudeData),
                      //     ));
                    },
                    child: Container(
                      height: queryData.height * 0.1,
                      width: queryData.height,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.white24))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Dating, Romance, Long term relationship (LTR)",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CustomPageRouteAnimation(
                        child: category3(
                            widget.latitudeData, widget.longitudeData),
                      ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => category2(
                      //           widget.latitudeData, widget.longitudeData),
                      //     ));
                    },
                    child: Container(
                      height: queryData.height * 0.1,
                      width: queryData.height,
                      // decoration: BoxDecoration(
                      //     border:
                      //         Border(bottom: BorderSide(color: Colors.black))),

                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 25),
                        child: Text(
                          "Sex with no string attached (NSA)",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CustomPageRouteAnimation(
                        child: category3(
                            widget.latitudeData, widget.longitudeData),
                      ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => category3(
                      //           widget.latitudeData, widget.longitudeData),
                      //     ));
                    },
                    child: Container(
                      height: queryData.height * 0.1,
                      width: queryData.height,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.white24),
                              bottom: BorderSide(color: Colors.white24))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Erotic services (massages, strippers, etc)",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================================================================================================================================
class category1 extends StatefulWidget {
  double latitude;
  double longitude;
  category1(this.latitude, this.longitude);

  @override
  _category1State createState() => _category1State();
}

class _category1State extends State<category1> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "Dating, Romance, Long term relationship (LTR)",
          style: TextStyle(color: Constants.searchIcon),
        ),
        backgroundColor: Constants.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "I am a men seeking a women"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a men seeking a women",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "I am a women seeking a men"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a women seeking a men",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "I am a men seeking a men"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a men seeking a men",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "I am a women seeking a women"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a women seeking a women",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================================================================================================================
class category2 extends StatefulWidget {
  double latitude;
  double longitude;
  category2(this.latitude, this.longitude);

  @override
  _category2State createState() => _category2State();
}

class _category2State extends State<category2> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        title: Text("Sex with no strings attached (NSA)",
            style: TextStyle(color: Constants.searchIcon)),
        backgroundColor: Constants.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "I am a man looking for a women"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a man looking for a women",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude,
                            widget.longitude,
                            "I am looking for fetish encounters"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am looking for fetish encounters",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "I am a men looking for a men"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a men looking for a men",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude,
                            widget.longitude,
                            "I am a transsexual looking for a men"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "I am a transsexual looking for a men",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude,
                            widget.longitude,
                            "We are a couple looking for a women"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "We are a couple looking for a women",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude,
                            widget.longitude,
                            "We are a couple looking for a men"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "We are a couple looking for a men",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude,
                            widget.longitude,
                            "We are a couple looking for a couple"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      "We are a couple looking for another couple",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================================================================================================================
class category3 extends StatefulWidget {
  double latitude;
  double longitude;
  category3(this.latitude, this.longitude);

  @override
  _category3State createState() => _category3State();
}

class _category3State extends State<category3> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        title: Text("Erotic services (massages, strippers, etc.)",
            style: TextStyle(color: Constants.searchIcon)),
        backgroundColor: Constants.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude, widget.longitude, "BDSM & Fetish"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "BDSM & Fetish",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "Massage Parlours"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "Massage Parlours",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(
                            widget.latitude, widget.longitude, "Adult Jobs"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "Adult Jobs",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "Erotic Bars & Clubs"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "Erotic Bars & Clubs",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "Erotic Phone & Cam Services"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "Erotic Phone & Cam Services",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "Erotic Photography"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "Erotic Photography",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => crreateTickets(widget.latitude,
                            widget.longitude, "Other Personals Services"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(color: Colors.black12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 10),
                    child: Text(
                      "Other Personals Services",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================================================================================================================
class crreateTickets extends StatefulWidget {
  double latitude;
  double longitude;
  String category;
  crreateTickets(this.latitude, this.longitude, this.category);
  @override
  _crreateTicketsState createState() => _crreateTicketsState();
}

class _crreateTicketsState extends State<crreateTickets> {
  final TextEditingController titleControler = TextEditingController();
  final TextEditingController descriptionControler = TextEditingController();
  int countTitleChar = 0;
  int countDescriptionChar = 0;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  final titleKey = GlobalKey<FormState>();
  final discriptionKey = GlobalKey<FormState>();
  Future<bool> onBackPress() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to discard your post ?",
            style: TextStyle(color: Constants.searchIcon)),
        actions: [
          TextButton(
            child: Text("No", style: TextStyle(color: Constants.searchIcon)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Yes", style: TextStyle(color: Constants.searchIcon)),
            onPressed: () {
              imageFile = null;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Constants.scaffoldBackground,
        appBar: AppBar(
          title: Text(
            "Create an advertisement",
            style: TextStyle(color: Constants.searchIcon),
          ),
          backgroundColor: Constants.appBar,
        ),
        body: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 390,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                                visible: countTitleChar >= 10 ? true : false,
                                child: Icon(
                                  Icons.check_box,
                                  color: Constants.searchIcon,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "$countTitleChar",
                                      style: TextStyle(
                                          color: countTitleChar >= 10
                                              ? Constants.searchIcon
                                              : Colors.red),
                                    ),
                                    Text("/10",
                                        style: TextStyle(
                                            color: Constants.searchIcon))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: titleKey,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(70)
                            ],
                            onChanged: (value) {
                              setState(() {
                                countTitleChar = titleControler.text.length;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Provide Title",
                                labelStyle:
                                    TextStyle(color: Constants.searchIcon),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.searchIcon))),
                            validator: (value) {
                              return value.length < 10
                                  ? "Title should be more than 10 characters"
                                  : null;
                            },
                            controller: titleControler,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                                visible:
                                    countDescriptionChar >= 20 ? true : false,
                                child: Icon(
                                  Icons.check_box,
                                  color: Constants.searchIcon,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "$countDescriptionChar",
                                      style: TextStyle(
                                          color: countDescriptionChar >= 20
                                              ? Constants.searchIcon
                                              : Colors.red),
                                    ),
                                    Text("/20",
                                        style: TextStyle(
                                            color: Constants.searchIcon))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: discriptionKey,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                countDescriptionChar =
                                    descriptionControler.text.length;
                              });
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4000)
                            ],
                            decoration: InputDecoration(
                                labelText: "Provide Description",
                                labelStyle:
                                    TextStyle(color: Constants.searchIcon),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.searchIcon))),
                            validator: (value) {
                              return value.length < 20
                                  ? "Description should be more than 20 characters"
                                  : null;
                            },
                            controller: descriptionControler,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Constants.searchIcon, width: 1)),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Discribe your offer/search with as much\ndetails as possible! Providing enough relevent\ninformation to other user gets your ad\nfound even faster.",
                                      style: TextStyle(
                                          color: Constants.searchIcon),
                                    )
                                  ],
                                ))),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width,
                  height: 50,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Constants.searchIcon),
                    onPressed: () {
                      setState(() {
                        if (titleKey.currentState.validate() &&
                            discriptionKey.currentState.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => secondPage(
                                    titleControler.text,
                                    descriptionControler.text,
                                    widget.category),
                              ));
                        }
                      });
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

// ===================================================================================================================================================================
PickedFile imageFile;

final ImagePicker picker = ImagePicker();

class secondPage extends StatefulWidget {
  String title;
  String description;
  String category;

  secondPage(this.title, this.description, this.category);

  @override
  _secondPageState createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final snackBar = SnackBar(
    content: Text('Please choose a photo'),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.redAccent,
  );
  final imageSizeisTooLarge = SnackBar(
    content: Text('Image size is too large'),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.redAccent,
  );

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "Choose a photo",
          style: TextStyle(color: Constants.searchIcon),
        ),
        backgroundColor: Constants.appBar,
      ),
      body: Container(
        height: queryData.height,
        width: queryData.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Constants.searchIcon)),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: Colors.yellow,
                              size: 30,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Upload an attractive photo so that people \nfind it more interesting!",
                              style: TextStyle(color: Constants.searchIcon),
                            )
                          ],
                        )
                        // RichText(
                        //     text: TextSpan(children: [
                        //   WidgetSpan(
                        //     child: Icon(
                        //       Icons.lightbulb_outline_rounded,
                        //       color: Colors.yellow,
                        //       size: 20,
                        //     ),
                        //   ),
                        //   TextSpan(
                        //     text:
                        //         "Upload an attractive photo so that people find it\nmore interesting!",
                        //     style: TextStyle(color: Constants.searchIcon),
                        //   ),
                        // ])),
                        ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 400,
                  width: 300,
                  child: imageFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: 200,
                          color: Constants.searchIcon,
                        )
                      : Container(
                          height: 400,
                          width: 300,
                          child: imageFile != null
                              ? Image(
                                  image: imageFile == null
                                      ? Icon(
                                          Icons.person,
                                        )
                                      : FileImage(File(imageFile.path)),
                                  // fit: BoxFit.cover,
                                )
                              : Text("")),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: imageFile != null
                        ? ElevatedButton(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => bottomSheet(),
                            ),
                            child: Text("Change Photo",
                                style: TextStyle(color: Colors.black)),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.lime),
                          )
                        : ElevatedButton(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => bottomSheet(),
                            ),
                            child: Text("Upload Photo",
                                style: TextStyle(color: Colors.black)),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.lime),
                          )),
              ],
            ),
            Flexible(
              child: Container(
                height: 50,
                width: queryData.width,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Constants.searchIcon),
                  child: Text("NEXT", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    if (imageFile != null) {
                      _tripEditModalBottomSheet(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
      height: 100,
      width: queryData.size.width,
      margin: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Text(
            "choose a photo",
            style: TextStyle(fontSize: 20, color: Constants.searchIcon),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.camera,
                      color: Constants.searchIcon,
                    ),
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                  ),
                  Text(
                    "Camera",
                    style: TextStyle(color: Constants.searchIcon),
                  )
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Constants.searchIcon,
                    ),
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                  ),
                  Text("Gallery", style: TextStyle(color: Constants.searchIcon))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitudeData1 = geoposition.latitude;
      longitudeData1 = geoposition.longitude;
    });
  }

  void _tripEditModalBottomSheet(context) {
    bool _switchValue = true;
    var queryData = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage("shareNumber.jpg"),
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enable direct calling from my ad (recommended)\n[NOTE: By enabling this your number will be share \nto public]",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return CupertinoSwitch(
                              activeColor: Colors.green,
                              value: _switchValue,
                              onChanged: (value) {
                                print(value);

                                setState(() {
                                  _switchValue = value;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  width: queryData.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (latitudeData1 == null || longitudeData1 == null) {
                        getCurrentLocation();
                      } else {
                        final coordinates =
                            new Coordinates(latitudeData1, longitudeData1);
                        var addresses = await Geocoder.local
                            .findAddressesFromCoordinates(coordinates);
                        var first = addresses.first;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => preview(
                                latitudeData1,
                                longitudeData1,
                                widget.title,
                                widget.description,
                                widget.category,
                                _switchValue,
                                first.locality),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Preview Advertisement",
                      style: TextStyle(color: Colors.black),
                    ),
                    style:
                        ElevatedButton.styleFrom(primary: Constants.searchIcon),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void takePhoto(ImageSource source) async {
    final pickerFile = await picker.getImage(
      source: source,
      imageQuality: 25,
      maxHeight: 440,
      maxWidth: 370,
    );
    var bytes = new File(pickerFile.path);
    var enc = await bytes.readAsBytes();

    if (enc.length >= 500000) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(imageSizeisTooLarge);
    } else {
      setState(() {
        imageFile = pickerFile;

        Navigator.pop(context);
      });
    }
  }
}

// ===================================================================================================================================================================
class preview extends StatefulWidget {
  double latitude;
  double longitude;
  String title;
  String description;
  String category;
  bool shareNumber;
  var address;

  preview(this.latitude, this.longitude, this.title, this.description,
      this.category, this.shareNumber, this.address);
  @override
  _previewState createState() => _previewState();
}

class _previewState extends State<preview> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AdMobService adMobService = new AdMobService();
  uploadImage(bool shareMobileNumber) async {
    String userImageUrl;

    File file = File(imageFile.path);

    try {
      var time = DateTime.now().millisecondsSinceEpoch;
      var folder = FirebaseAuth.instance.currentUser.phoneNumber;

      await FirebaseStorage.instance.ref("$folder/$time").putFile(file);

      userImageUrl =
          await FirebaseStorage.instance.ref("$folder/$time").getDownloadURL();
    } on FirebaseException catch (e) {
      print("error in uploding user image");
    }
    databaseMethods.uploadTicketInfo(
      widget.title,
      widget.description,
      shareMobileNumber,
      FirebaseAuth.instance.currentUser.phoneNumber,
      widget.latitude,
      widget.longitude,
      userImageUrl,
      widget.category,
      widget.address,
    );
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

  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  "Posting your ad ...",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ));

    overlayState.insert(overlayEntry);

    await Future.delayed(Duration(seconds: 3));

    overlayEntry.remove();
  }

  @override
  void initState() {
    super.initState();
    adMobService.loadRewardedAd();
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user_account")
              .doc(FirebaseAuth.instance.currentUser.phoneNumber)
              .snapshots(),
          builder: (context, snapshot) {
            var userAccount = snapshot.data;
            return Container(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: queryData.width,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Constants.tscaffoldBackground,
                            // spreadRadius: 10,
                            // blurRadius: 25.0,
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
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: Constants.adPhotoContainer)),
                                height: 250,
                                width: queryData.width,
                                child: Image(
                                  image: FileImage(File(imageFile.path)),
                                ),
                              ),
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
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Constants.tDescriptionBoxString)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
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
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      height: 70,
                                      width: queryData.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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
                                                color: Constants.tlocationIcon,
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
                              Divider(
                                thickness: 2,
                              ),
                              Container(
                                width: queryData.width,
                                height: queryData.height * 0.07,
                                color: Constants.tSeeProfileContainer,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, bottom: 6),
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
                                              Text("SEE PROFILE",
                                                  style: TextStyle(
                                                    color: Constants
                                                        .tSeeProfileText,
                                                    fontSize: 15,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 50,
                                  width: queryData.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: widget.shareNumber
                                            ? AssetImage("callTrue.jpg")
                                            : AssetImage("callFalse.jpg"),
                                        fit: BoxFit.cover),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: queryData.width,
                        child: ElevatedButton(
                          onPressed: () {
                            uploadImage(widget.shareNumber);
                            showOverlay(context);

                            Future.delayed(const Duration(seconds: 3), () {
                              imageFile = null;
                              try {
                                adMobService.showRewardedAd();
                              } catch (e) {
                                print(e.toString());
                              }

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => navigationBar(),
                                  ),
                                  (route) => false);
                            });
                          },
                          child: Text(
                            "Post",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Constants.searchIcon),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(320 / 360),
                      child: Text(
                        "DRAFT",
                        style: TextStyle(fontSize: 100, color: Colors.white12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
