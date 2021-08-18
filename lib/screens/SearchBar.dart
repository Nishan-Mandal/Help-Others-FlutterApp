import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/Database.dart';
import 'package:help_others/services/Modals.dart';

import '../main.dart';

import 'TicketViewScreen.dart';

class searchBox extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  String searchText;
  int searchRadius;
  searchBox(this.latitudeData, this.longitudeData, this.searchText,
      this.searchRadius);

  @override
  _searchBoxState createState() => _searchBoxState();
}

class _searchBoxState extends State<searchBox> {
  // String sc;
  // final geo = Geoflutterfire();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController _searchController = TextEditingController();
  // final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  int notificationCounter = 0;
  int messageCounter = 0;

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    controller.addListener(() {
      double value = controller.offset / 140;

      // setState(() {
      //   topContainer = value;
      //   closeTopContainer = controller.offset > 50;
      // }
      // );
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  Future<void> searchResultsList() async {
    int ticketsWithinDistance = widget.searchRadius * 1000;
    var showResults = [];

    if (_searchController.text != "" && widget.searchRadius != 0) {
      for (var tripSnapshot in _allResults) {
        var title = Search.fromSnapshot(tripSnapshot).title.toLowerCase();
        var description =
            Search.fromSnapshot(tripSnapshot).description.toLowerCase();
        var category = Search.fromSnapshot(tripSnapshot).category.toLowerCase();
        double ticketLatitude = Search.fromSnapshot(tripSnapshot).latitude;
        double ticketLongitude = Search.fromSnapshot(tripSnapshot).longitude;
        double distanceInMeters = Geolocator.distanceBetween(
            latitudeData1, longitudeData1, ticketLatitude, ticketLongitude);
        if ((title.contains(_searchController.text.toLowerCase()) ||
                description.contains(_searchController.text.toLowerCase()) ||
                category.contains(_searchController.text.toLowerCase())) &&
            distanceInMeters <= ticketsWithinDistance) {
          showResults.add(tripSnapshot);
        }
      }
    } else if (_searchController.text == "" && widget.searchRadius != 0) {
      // showResults = List.from(_allResults);

      for (var distance in _allResults) {
        double ticketLatitude = Search.fromSnapshot(distance).latitude;
        double ticketLongitude = Search.fromSnapshot(distance).longitude;

        double distanceInMeters = Geolocator.distanceBetween(
            latitudeData1, longitudeData1, ticketLatitude, ticketLongitude);

        if (distanceInMeters <= ticketsWithinDistance) {
          showResults.add(distance);
        }
      }
    } else if (_searchController.text != "" && widget.searchRadius == 0) {
      for (var tripSnapshot in _allResults) {
        var title = Search.fromSnapshot(tripSnapshot).title.toLowerCase();
        var description =
            Search.fromSnapshot(tripSnapshot).description.toLowerCase();
        var category = Search.fromSnapshot(tripSnapshot).category.toLowerCase();

        if ((title.contains(_searchController.text.toLowerCase()) ||
            description.contains(_searchController.text.toLowerCase()) ||
            category.contains(_searchController.text.toLowerCase()))) {
          showResults.add(tripSnapshot);
        }
      }
    }
    if (this.mounted) {
      setState(() {
        _resultsList = showResults;

        // _resultsList = _allResults;
      });
    }
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('global_ticket')
        .orderBy("time", descending: true)
        .get();
    if (this.mounted) {
      setState(() {
        _allResults = data.docs;
      });
    }
    searchResultsList();
    return "complete";
  }

  bool flag1 = false;
  @override
  Widget build(BuildContext context) {
    _searchController.text = widget.searchText;

    final Size size = MediaQuery.of(context).size;

    var queryData = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      child: Scaffold(
          backgroundColor: Constants.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Constants.appBar,
            title: Container(
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.white),
              //     borderRadius: BorderRadius.circular(15)),
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.pop(context);
                },
                autofocus: false,
                style: TextStyle(color: Constants.searchIcon),
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: widget.searchText,
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('global_ticket')
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: _resultsList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String title = _resultsList[index]['title'];
                        String description = _resultsList[index]['description'];
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
                                    _resultsList[index]['ticket_owner'],
                                    _resultsList[index]['title'],
                                    _resultsList[index]['description'],
                                    _resultsList[index]['id'],
                                    _resultsList[index]['uplodedPhoto'],
                                    _resultsList[index]['latitude'],
                                    _resultsList[index]['longitude'],
                                    _resultsList[index]['date'],
                                    _resultsList[index]['share_mobile'],
                                    myFavFlag,
                                    snapshot.data.docs[index]["address"],
                                    snapshot.data.docs[index]["category"],
                                  ),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: new Center(
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                  child: Image.network(
                                                    _resultsList[index]
                                                        ["uplodedPhoto"],
                                                    fit: BoxFit.cover,
                                                    cacheHeight: 300,
                                                    cacheWidth: 200,
                                                  )

                                                  // CachedNetworkImage(
                                                  //   imageUrl:
                                                  //       _resultsList[index]
                                                  //           ["uplodedPhoto"],
                                                  //   fit: BoxFit.cover,
                                                  //   height: 300,
                                                  //   width: 200,
                                                  // )
                                                  ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                        .descriptionText,
                                                  ),
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
                                  child: _resultsList[index]["ticket_owner"] !=
                                          FirebaseAuth
                                              .instance.currentUser.phoneNumber
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Constants.myFavIconBackground,
                                              borderRadius:
                                                  BorderRadius.circular(90)),
                                          child: IconButton(
                                            icon: (myFavFlag)
                                                ? Icon(
                                                    Icons.favorite,
                                                    color:
                                                        Constants.myFavIconTrue,
                                                    size: 20,
                                                  )
                                                : Icon(
                                                    Icons.favorite_border,
                                                    color: Constants
                                                        .myFavIconFalse,
                                                    size: 20,
                                                  ),
                                            onPressed: () {
                                              setState(() {
                                                if (myFavFlag) {
                                                  databaseMethods
                                                      .undomyFavourite(
                                                    _resultsList[index]["id"],
                                                  );
                                                } else {
                                                  databaseMethods.myFavourites(
                                                    _resultsList[index]["id"],
                                                  );
                                                }
                                                myFavFlag = true;
                                              });
                                            },
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
                                                  color:
                                                      Constants.locationMarker,
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
                    );
                  }),
            ),
          )),
    );
  }
}
