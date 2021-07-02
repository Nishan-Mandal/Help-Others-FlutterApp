import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_others/services/Database.dart';
import 'package:help_others/services/Modals.dart';

import '../main.dart';
import 'TicketViewScreen.dart';

class searchBox extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  String searchText;
  searchBox(this.latitudeData, this.longitudeData, this.searchText);

  @override
  _searchBoxState createState() => _searchBoxState();
}

class _searchBoxState extends State<searchBox> {
  int ticketsWithinDistance = 30000;
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

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
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
    print(_searchController.text);
  }

  Future<void> searchResultsList() async {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = Search.fromSnapshot(tripSnapshot).title.toLowerCase();
        var description =
            Search.fromSnapshot(tripSnapshot).description.toLowerCase();
        var category = Search.fromSnapshot(tripSnapshot).category.toLowerCase();
        double ticketLatitude = Search.fromSnapshot(tripSnapshot).latitude;
        double ticketLongitude = Search.fromSnapshot(tripSnapshot).longitude;
        double distanceInMeters = Geolocator.distanceBetween(
            widget.latitudeData,
            widget.longitudeData,
            ticketLatitude,
            ticketLongitude);
        if ((title.contains(_searchController.text.toLowerCase()) ||
                description.contains(_searchController.text.toLowerCase()) ||
                category.contains(_searchController.text.toLowerCase())) &&
            distanceInMeters <= ticketsWithinDistance) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      // showResults = List.from(_allResults);

      for (var distance in _allResults) {
        double ticketLatitude = Search.fromSnapshot(distance).latitude;
        double ticketLongitude = Search.fromSnapshot(distance).longitude;
        print("object==========================");

        // print('${widget.latitudeData} 1');
        // print('${widget.longitudeData} 2');
        // print('${latitudeData1} 3');
        // print('${latitudeData1} 4');

        double distanceInMeters = await Geolocator.distanceBetween(
            widget.latitudeData,
            widget.longitudeData,
            latitudeData1,
            longitudeData1);

        if (distanceInMeters <= ticketsWithinDistance) {
          showResults.add(distance);
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
        .where('mark_as_done', isEqualTo: false)
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

  @override
  Widget build(BuildContext context) {
    _searchController.text = widget.searchText;

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
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.white),
              //     borderRadius: BorderRadius.circular(15)),
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.pop(context);
                },
                autofocus: false,
                style: TextStyle(color: Colors.white),
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          body: Container(
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
                      itemCount: _resultsList.length,
                      itemBuilder: (BuildContext context, index) {
                        double distanceInMeters = Geolocator.distanceBetween(
                            widget.latitudeData,
                            widget.longitudeData,
                            _resultsList[index]['latitude'],
                            _resultsList[index]['longitude']);
                        String distanceBetweenTicketCreaterAndResponder =
                            distanceInMeters.toStringAsFixed(2);
                        double scale = 1.0;
                        if (topContainer > 1) {
                          scale = index + 1 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        String photoInListTile;
                        var x = FirebaseFirestore.instance
                            .collection("user_account")
                            .doc(_resultsList[index]['ticket_owner'])
                            .get()
                            .then((value) =>
                                {photoInListTile = value.get("photo")});
                        // Future.delayed(const Duration(milliseconds: 500), () {

                        // });

                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform: Matrix4.identity()..scale(scale, scale),
                            alignment: Alignment.bottomCenter,

                            // color: Colors.yellowAccent,
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
                                            _resultsList[index]['ticket_owner'],
                                            _resultsList[index]['title'],
                                            _resultsList[index]['description'],
                                            _resultsList[index]['id'],
                                            _resultsList[index]['mark_as_done'],
                                            _resultsList[index]['uplodedPhoto'],
                                            _resultsList[index]['latitude'],
                                            _resultsList[index]['longitude'],
                                            _resultsList[index]['date'],
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
                                                BorderRadius.circular(10.0),
                                          ),
                                          constraints: BoxConstraints(
                                              maxWidth: 300, maxHeight: 110),
                                        ),
                                      ),
                                      Positioned(
                                          left: 0,
                                          top: 15,
                                          child: CircleAvatar(
                                              minRadius: 40,
                                              backgroundImage: NetworkImage(
                                                  _resultsList[index]
                                                      ['uplodedPhoto']))),
                                      Positioned(
                                          top: 25,
                                          left: 100,
                                          child: Text(
                                              _resultsList[index]['title'])),
                                      Positioned(
                                          top: 55,
                                          left: 100,
                                          child: Text(_resultsList[index]
                                              ['description']))
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
          )),
    );
  }
}
