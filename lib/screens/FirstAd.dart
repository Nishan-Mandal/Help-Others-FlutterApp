import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_others/services/Constants.dart';

import '../main.dart';
import 'CreateTickets.dart';

class firstAd extends StatefulWidget {
  double latitudeData;
  double longitudeData;
  firstAd(
    this.latitudeData,
    this.longitudeData,
  );
  @override
  _firstAdState createState() => _firstAdState();
}

class _firstAdState extends State<firstAd> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
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
      if (this.mounted) {
        getCurrentLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
        backgroundColor: Constants.scaffoldBackground,
        appBar: AppBar(
          title: Text(
            "What are you looking for?",
            style: TextStyle(color: Constants.searchIcon),
          ),
          backgroundColor: Constants.appBar,
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
                        border:
                            Border(bottom: BorderSide(color: Colors.white24))),
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
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constants.searchIcon)),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10, top: 10),
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
                              "We use the information to serve you better.\nWe will create an advertisement so that\npeople around you can reach out. You can\nanytime update your interest as per your\nmood. Please feel free and go ahead.",
                              style: TextStyle(color: Constants.searchIcon),
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
