import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_others/main.dart';
import 'package:help_others/screens/CreateTickets.dart';
import 'package:help_others/screens/Drawer.dart';
import 'package:help_others/screens/MessageScren.dart';
import 'package:help_others/screens/MyTickets.dart';
import 'package:help_others/screens/NotificationsInBell.dart';
import 'package:help_others/screens/SearchBar.dart';
import 'package:help_others/services/DashboardList.dart';
import 'package:help_others/services/Database.dart';
import 'package:help_others/services/Modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:help_others/screens/ProfilePage.dart';
import 'TicketViewScreen.dart' show ticketViewScreen;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

String sc;

class dashboard extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  dashboard(this.latitudeData, this.longitudeData);
  @override
  _dashboardState createState() => _dashboardState();
}

int ticketsWithinDistance = 30000;

class _dashboardState extends State<dashboard> {
  // final geo = Geoflutterfire();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  // final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  int notificationCounter = 0;
  int messageCounter = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      double value = controller.offset / 140;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var collectionReference = FirebaseFirestore.instance
        .collection('global_ticket')
        .where('mark_as_done', isEqualTo: false)
        .orderBy("time", descending: true);

    double radius = 1000;
    String field = 'position';

    final myLocation =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.20;

    var queryData = MediaQuery.of(context).size;
    return Container(
      color: Colors.amber[900],
      height: size.height,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => searchBar(
                            widget.latitudeData, widget.longitudeData),
                      ));
                },
                autofocus: false,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  new Stack(
                    children: <Widget>[
                      new IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => notificationsInBell(""),
                                ));
                            setState(() {
                              notificationCounter = 0;
                            });
                          }),
                      notificationCounter != 0
                          ? new Positioned(
                              right: 11,
                              top: 11,
                              child: new Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                // child: Text(
                                //   '$counter',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 8,
                                //   ),
                                //   textAlign: TextAlign.center,
                                // ),
                              ),
                            )
                          : new Container()
                    ],
                  ),
                ],
              ),
            ],
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('global_ticket')
                  .where('mark_as_done', isEqualTo: false)
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Flexible(
                              child: ListView.builder(
                            itemExtent: 140,
                            scrollDirection: Axis.vertical,
                            controller: controller,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, index) {
                              double scale = 1.0;
                              if (topContainer > 1) {
                                scale = index + 1 - topContainer;
                                if (scale < 0) {
                                  scale = 0;
                                } else if (scale > 1) {
                                  scale = 1;
                                }
                              }
                              String title = snapshot.data.docs[index]["title"];
                              String description =
                                  snapshot.data.docs[index]["description"];
                              return Opacity(
                                opacity: scale,
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..scale(scale, scale),
                                  alignment: Alignment.bottomCenter,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ticketViewScreen(
                                                  snapshot.data.docs[index]
                                                      ["ticket_owner"],
                                                  snapshot.data.docs[index]
                                                      ["title"],
                                                  snapshot.data.docs[index]
                                                      ["description"],
                                                  snapshot.data.docs[index]
                                                      ["id"],
                                                  snapshot.data.docs[index]
                                                      ["mark_as_done"],
                                                  snapshot.data.docs[index]
                                                      ["uplodedPhoto"],
                                                  snapshot.data.docs[index]
                                                      ["latitude"],
                                                  snapshot.data.docs[index]
                                                      ["longitude"],
                                                  snapshot.data.docs[index]
                                                      ["date"],
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
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                constraints: BoxConstraints(
                                                    maxWidth: 300,
                                                    maxHeight: 110),
                                              ),
                                            ),
                                            Positioned(
                                                left: 0,
                                                top: 15,
                                                child: CircleAvatar(
                                                  minRadius: 40,
                                                  backgroundColor:
                                                      Colors.tealAccent,
                                                  child: CircleAvatar(
                                                      minRadius: 39,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        snapshot.data
                                                                .docs[index]
                                                            ["uplodedPhoto"],
                                                      )),
                                                )),
                                            Positioned(
                                                top: 25,
                                                left: 100,
                                                child: Text(
                                                  title.length > 20
                                                      ? title.substring(0, 20) +
                                                          "..."
                                                      : title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Positioned(
                                                top: 55,
                                                left: 100,
                                                child: Text(
                                                  description.length > 30
                                                      ? description.substring(
                                                              0, 30) +
                                                          "..."
                                                      : description,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                        ],
                      ),
                    ],
                  ),
                );
              })),
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
  int kms = 40;
  @override
  void initState() {
    super.initState();
    ticketsWithinDistance = 30;

    searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: queryData.width,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: queryData.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  autofocus: true,
                  style: TextStyle(color: Colors.black),
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
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            sc = searchController.text;
                          });
                          // searchController.clear();
                          Navigator.pop(context);
                        }),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          ticketsWithinDistance = kms * 1000;
                          sc = searchController.text;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => searchBox(
                                  widget.latitudeData,
                                  widget.longitudeData,
                                  searchController.text),
                            ));
                      },
                    ),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: DropdownButton<int>(
                focusColor: Colors.white,
                value: kms,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: <int>[
                  0,
                  1,
                  5,
                  10,
                  20,
                  40,
                  100,
                  500,
                ].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      '$value KM',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  '$kms KM',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                onChanged: (int value) {
                  setState(() {
                    kms = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: queryData.width,
                color: Colors.amber,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  focusColor: Colors.white,
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
                        style: TextStyle(color: Colors.black),
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
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: queryData.width,
                color: Colors.amber,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
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
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "sex with no string attached(NSA)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      searchController.text = value;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: queryData.width,
                color: Colors.amber,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: _chosenValue,
                  //elevation: 5,
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
                        style: TextStyle(color: Colors.black),
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
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
