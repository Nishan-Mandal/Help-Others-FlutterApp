import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/screens/NavigationBar.dart';

import 'package:help_others/services/Database.dart';
import 'package:image_picker/image_picker.dart';

// import '../main.dart';

class categoryPage extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  categoryPage(this.latitudeData, this.longitudeData);
  @override
  _categoryPageState createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Dating, Romance, Long term relationship (LTR)",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "sex with no string attached (NSA)",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
        title: Text("Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Container(
                height: queryData.height / 20,
                width: queryData.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 5),
                    color: Colors.black),
                child: Text(
                  "Dating, Romance, Long term relationship (LTR)",
                  style: TextStyle(fontSize: 17, color: Colors.white),
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
                            widget.longitude, "I am a men seeking a women"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a men seeking a women",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a women seeking a men",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a men seeking a men",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a women seeking a women",
                    style: TextStyle(fontSize: 25),
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
        title: Text("Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Container(
                height: queryData.height / 20,
                width: queryData.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 5),
                    color: Colors.black),
                child: Text(
                  "Sex with no strings attached (NSA)",
                  style: TextStyle(fontSize: 17, color: Colors.white),
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
                            widget.longitude, "I am a man looking for a women"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a man looking for a women",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am looking for fetish encounters",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a men looking for a men",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "I am a transsexual looking for a men",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "We are a couple looking for a women",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "We are a couple looking for a men",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "We are a couple looking for another couple",
                    style: TextStyle(fontSize: 25),
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
        title: Text("Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Container(
                height: queryData.height / 20,
                width: queryData.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 5),
                    color: Colors.black),
                child: Text(
                  "Erotic services (massages, strippers, etc.)",
                  style: TextStyle(fontSize: 17, color: Colors.white),
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
                            widget.latitude, widget.longitude, "BDSM & Fetish"),
                      ));
                },
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "BDSM & Fetish",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Massage Parlours",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Adult Jobs",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Erotic Bars & Clubs",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Erotic Phone & Cam Services",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Erotic Photography",
                    style: TextStyle(fontSize: 25),
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
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Other Personals Services",
                    style: TextStyle(fontSize: 25),
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
  final myLocation =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
                                  ? "Please Provide Title"
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
                                    ? "Please Provide Description"
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
                                  Border.all(color: Colors.black, width: 5)),
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
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        // int ticketUploadTime =
                        //     DateTime.now().millisecondsSinceEpoch;
                        // String mobileNumber =
                        //     FirebaseAuth.instance.currentUser.phoneNumber;
                        // databaseMethods.uploadTicketInfo(
                        //   titleControler.text,
                        //   descriptionControler.text,
                        //   ticketUploadTime,
                        //   false,
                        //   mobileNumber,
                        //   widget.latitude,
                        //   widget.longitude,
                        //   false,
                        // );
                        // titleControler.clear();
                        // descriptionControler.clear();

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => dashboard(""),
                        //     ));
                        if (titleKey.currentState.validate() &&
                            discriptionKey.currentState.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => secondPage(
                                    widget.latitude,
                                    widget.longitude,
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
  double latitude;
  double longitude;
  String title;
  String description;
  String category;

  secondPage(this.latitude, this.longitude, this.title, this.description,
      this.category);

  @override
  _secondPageState createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        height: queryData.height,
        width: queryData.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  child: imageFile == null
                      ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 50,
                          ),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => bottomSheet(),
                          ),
                        )
                      : RaisedButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => bottomSheet(),
                          ),
                          child: Text("Change Photo"),
                          color: Colors.blue,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      height: 400,
                      width: queryData.width,
                      child: imageFile != null
                          ? Image(
                              image: imageFile == null
                                  ? IconButton(
                                      icon: Icon(Icons.person),
                                      onPressed: () => showModalBottomSheet(
                                        context: context,
                                        builder: (context) => bottomSheet(),
                                      ),
                                    )
                                  : FileImage(File(imageFile.path)),
                            )
                          : Text("")),
                ),
              ],
            ),
            Container(
              height: 50,
              width: queryData.width,
              child: RaisedButton(
                color: Colors.blue,
                child: Text("Preview"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => preview(
                          widget.latitude,
                          widget.longitude,
                          widget.title,
                          widget.description,
                          widget.category),
                    ),
                  );
                },
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

  void takePhoto(ImageSource source) async {
    final pickerFile = await picker.getImage(source: source);

    setState(() {
      imageFile = pickerFile;
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

  preview(this.latitude, this.longitude, this.title, this.description,
      this.category);
  @override
  _previewState createState() => _previewState();
}

class _previewState extends State<preview> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  uploadImage() async {
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
        false,
        FirebaseAuth.instance.currentUser.phoneNumber,
        widget.latitude,
        widget.longitude,
        false,
        userImageUrl,
        widget.category);
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview"),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  decoration: BoxDecoration(border: Border.all(width: 5)),
                  child: Text(
                    "Category :" + widget.category,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Text("Title", style: TextStyle(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Description", style: TextStyle(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: queryData.height / 15,
                  width: queryData.width,
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Text(
                    widget.description,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 300,
                    width: queryData.width,
                    child: imageFile != null
                        ? Image(image: FileImage(File(imageFile.path)))
                        : Icon(
                            (Icons.person),
                            size: 200,
                          )),
              ),
            ],
          ),
          Container(
            height: 50,
            width: queryData.width,
            child: FlatButton(
              onPressed: () {
                uploadImage();
                imageFile = null;

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => navigationBar(),
                    ),
                    (route) => false);
              },
              child: Text("Post"),
              color: Colors.blue,
            ),
          ),
        ],
      )),
    );
  }
}
