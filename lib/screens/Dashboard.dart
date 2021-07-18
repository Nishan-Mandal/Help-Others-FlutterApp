import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';

import 'package:geolocator/geolocator.dart';
import 'package:help_others/main.dart';
import 'package:help_others/screens/CreateTickets.dart';
import 'package:help_others/screens/Drawer.dart';
import 'package:help_others/screens/MessageScren.dart';
import 'package:help_others/screens/MyTickets.dart';
import 'package:help_others/screens/NotificationsInBell.dart';
import 'package:help_others/screens/SearchBar.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/DashboardList.dart';
import 'package:help_others/services/Database.dart';
import 'package:help_others/services/Modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:help_others/screens/ProfilePage.dart';
import 'PrivacyPolicy.dart';
import 'TicketViewScreen.dart' show ticketViewScreen;
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  // ScrollController controller = ScrollController();
  // bool closeTopContainer = false;
  // double topContainer = 0;
  int notificationCounter = 0;
  int messageCounter = 0;

  // @override
  // void initState() {
  //   super.initState();

  //   controller.addListener(() {
  //     double value = controller.offset / 140;

  //     setState(() {
  //       topContainer = value;
  //       closeTopContainer = controller.offset > 50;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Container(
      height: queryData.height,
      child: Scaffold(
          backgroundColor: Constants.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Constants.appBar,
            title: Container(
              child: Container(
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
                          builder: (context) => searchBar(
                              widget.latitudeData, widget.longitudeData),
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
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Constants.textFieldHintText),
                  ),
                ),
              ),
            ),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('global_ticket')
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                            if (l.contains(FirebaseAuth
                                .instance.currentUser.phoneNumber)) {
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
                                      myFavFlag,
                                      snapshot.data.docs[index]["address"],
                                      snapshot.data.docs[index]["category"],
                                    ),
                                  ));
                            },
                            child: Stack(
                              children: [
                                new Container(
                                    // height: queryData.height,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors:
                                                Constants.gradientColorOnAd),
                                        // color: Colors.grey[800],

                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: new Center(
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: snapshot.data
                                                                .docs[index]
                                                            ["uplodedPhoto"],
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    )),
                                                    height: queryData.height,
                                                    width: queryData.width,
                                                  ),
                                                  Positioned(
                                                    right: 5,
                                                    bottom: 0,
                                                    child: Text(
                                                      snapshot.data.docs[index]
                                                          ["date"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Constants.date),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                            color: Constants.divider,
                                          ),
                                          Container(
                                            height: 70,
                                            width: queryData.width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    title.length > 23
                                                        ? "  " +
                                                            title.substring(
                                                                0, 23) +
                                                            ".."
                                                        : "  " + title,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Constants.titleText,
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Text(
                                                    description.length > 20
                                                        ? description.substring(
                                                                0, 20) +
                                                            ".."
                                                        : description,
                                                    style: TextStyle(
                                                        fontSize: 12,
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
                                    right: 0,
                                    child: snapshot.data.docs[index]
                                                ["ticket_owner"] !=
                                            FirebaseAuth.instance.currentUser
                                                .phoneNumber
                                        ? Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  // gradient: LinearGradient(
                                                  //     begin: Alignment.topLeft,
                                                  //     end: Alignment.bottomRight,
                                                  //     colors: Constants
                                                  //         .gradientColorOnAd),
                                                  color: Colors.grey[800],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: IconButton(
                                                icon: myFavFlag
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: Constants
                                                            .myFavIconTrue,
                                                        size: 20,
                                                      )
                                                    : Icon(
                                                        Icons.favorite_border,
                                                        size: 20,
                                                        color: Constants
                                                            .myFavIconFalse,
                                                      ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (myFavFlag) {
                                                      databaseMethods
                                                          .undomyFavourite(
                                                        snapshot.data
                                                            .docs[index]["id"],
                                                      );
                                                      myFavFlag = false;
                                                    } else {
                                                      databaseMethods
                                                          .myFavourites(
                                                        snapshot.data
                                                            .docs[index]["id"],
                                                      );
                                                      myFavFlag = true;
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        : Text("")),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, left: 8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: Constants.locationMarker,
                                                size: 15,
                                              ),
                                              Text(
                                                snapshot.data.docs[index]
                                                    ["address"],
                                                style: TextStyle(
                                                    color:
                                                        Constants.addressText,
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
                                // Positioned(
                                //     child:
                                //         Text(address == null ? " null" : address))
                              ],
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(
                                2, index.isEven ? 3.2 : 3.8),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
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
  int kms = 0;
  @override
  void initState() {
    super.initState();
    ticketsWithinDistance = 30;
    searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length));
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
    // TODO: implement dispose
    super.dispose();
    searchController.clear();
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
              child: Flexible(
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
                            // hint: Text(
                            //   '$kms KM',
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold, color: Colors.black),
                            // ),
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
                        hintText: "Search...",
                        hintStyle: TextStyle(
                          color: Constants.textFieldHintText,
                        )),
                  ),
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
