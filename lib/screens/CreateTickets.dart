import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_others/main.dart';

import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/screens/NavigationBar.dart';

import 'package:help_others/services/Database.dart';
import 'package:image_picker/image_picker.dart';
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => navigationBar(),
          ),
          (route) => false);
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
            FlatButton(
              child: Text("No, Thanks"),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigationBar(),
                  ),
                  (route) => false),
            ),
            FlatButton(
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

  bool isLocationServiceEnabled = false;
  Future<void> checkLocationEnable() async {
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
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
    // TODO: implement initState
    super.initState();
    checkLocationEnable();
    _showDialog();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBackPress,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Choose Category"),
            backgroundColor: Colors.blueGrey,
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => category1(
                                widget.latitudeData, widget.longitudeData),
                          ));
                    },
                    child: Container(
                      height: queryData.height * 0.1,
                      width: queryData.height,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black12))),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => category2(
                                widget.latitudeData, widget.longitudeData),
                          ));
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
                          "sex with no string attached (NSA)",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => category3(
                                widget.latitudeData, widget.longitudeData),
                          ));
                    },
                    child: Container(
                      height: queryData.height * 0.1,
                      width: queryData.height,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.black12),
                              bottom: BorderSide(color: Colors.black12))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "erotic services (massages, strippers, etc)",
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
      appBar: AppBar(
        title: Text("Dating, Romance, Long term relationship (LTR)"),
        backgroundColor: Colors.blueGrey,
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
      appBar: AppBar(
        title: Text("Sex with no strings attached (NSA)"),
        backgroundColor: Colors.blueGrey,
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
      appBar: AppBar(
        title: Text("Erotic services (massages, strippers, etc.)"),
        backgroundColor: Colors.blueGrey,
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        title: Text("Do you want to discard your post ?"),
        // backgroundColor: Colors.amber[300],
        actions: [
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("Yes"),
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
        appBar: AppBar(
          title: Text("Create Ticket"),
          backgroundColor: Colors.blueGrey,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                                visible: countTitleChar >= 10 ? true : false,
                                child: Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                )),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "${countTitleChar}",
                                    style: TextStyle(
                                        color: countTitleChar >= 10
                                            ? Colors.black
                                            : Colors.red),
                                  ),
                                  Text("/10")
                                ],
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
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.greenAccent),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.red),
                              // ),
                            ),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                                visible:
                                    countDescriptionChar >= 20 ? true : false,
                                child: Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                )),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "${countDescriptionChar}",
                                    style: TextStyle(
                                        color: countDescriptionChar >= 20
                                            ? Colors.black
                                            : Colors.red),
                                  ),
                                  Text("/20")
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: discriptionKey,
                          child: Flexible(
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
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.greenAccent),
                                // ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.red),
                                // ),
                              ),
                              validator: (value) {
                                return value.length < 20
                                    ? "Description should be more than 20 characters"
                                    : null;
                              },
                              controller: descriptionControler,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 3)),
                          child: Text(
                              "Discribe your offer/search with as much details as possible!\n"
                              "\nProviding enough relevent information to other user gets your ad fund even faster"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.greenAccent,
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
                    child: Text("Next"),
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
    content: Text('Choose photo'),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.redAccent,
  );
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a photo"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        height: queryData.height,
        width: queryData.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 400,
                  width: 300,
                  // color: Colors.amber,
                  child: imageFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: 200,
                        )
                      : Container(
                          // color: Colors.blue,
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
                        ? RaisedButton(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => bottomSheet(),
                            ),
                            child: Text("Change Photo"),
                            color: Colors.lime,
                          )
                        : RaisedButton(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => bottomSheet(),
                            ),
                            child: Text("Upload Photo"),
                            color: Colors.lime,
                          )),
              ],
            ),
            Flexible(
              child: Container(
                height: 50,
                width: queryData.width,
                child: RaisedButton(
                  color: Colors.greenAccent,
                  child: Text("Preview"),
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
            "choose a profile photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
              ),
              SizedBox(
                width: 50,
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
              )
            ],
          )
        ],
      ),
    );
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       "NOTE: By enabling this your number will be share to public",
                    //       style: TextStyle(color: Colors.red, fontSize: 8),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                SizedBox(
                  height: 50,
                  width: queryData.width,
                  child: FlatButton(
                    onPressed: () async {
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
                    },
                    child: Text("Preview"),
                    color: Colors.greenAccent,
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
    final pickerFile = await picker.getImage(source: source, imageQuality: 25);

    setState(() {
      imageFile = pickerFile;
      Navigator.pop(context);
    });
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
        builder: (context) => Center(
              child:
                  Positioned(child: Center(child: CircularProgressIndicator())),
            ));

    overlayState.insert(overlayEntry);

    await Future.delayed(Duration(seconds: 3));

    overlayEntry.remove();
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
                child: Column(
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
                            image: FileImage(File(imageFile.path)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Text("Description",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Flexible(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 12.0, left: 12.0, top: 12.0),
                          child: Text(
                            "Ad posted at",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                    color: Colors.black12,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.red,
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
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              widget.address,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          width: queryData.width,
                          height: queryData.height * 0.07,
                          color: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
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
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(userAccount["name"],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text("SEE PROFILE",
                                            style: TextStyle(
                                              color: Colors.blue,
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
                  child: FlatButton(
                    onPressed: () {
                      uploadImage(widget.shareNumber);
                      showOverlay(context);
                      Future.delayed(const Duration(seconds: 3), () {
                        imageFile = null;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => navigationBar(),
                            ),
                            (route) => false);
                      });
                    },
                    child: Text("Post"),
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ));
          }),
    );
  }
}
