// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';

// import 'package:help_others/screens/ProfilePage.dart';
// import 'package:help_others/screens/TicketViewScreen.dart';
// import 'package:help_others/services/Database.dart';
// import 'package:geolocator/geolocator.dart';

// class TicketsListPage extends StatefulWidget {
//   double latitude;
//   double longitude;
//   TicketsListPage(this.latitude, this.longitude);

//   @override
//   _TicketListPageState createState() => _TicketListPageState();
// }

// final geo = Geoflutterfire();

// class _TicketListPageState extends State<TicketsListPage> {
//   // final CategoriesScroller categoriesScroller = CategoriesScroller();
//   ScrollController controller = ScrollController();
//   bool closeTopContainer = false;
//   double topContainer = 0;

//   @override
//   void initState() {
//     super.initState();

//     controller.addListener(() {
//       double value = controller.offset / 140;

//       setState(() {
//         topContainer = value;
//         closeTopContainer = controller.offset > 50;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Create a geoFirePoint
//     GeoFirePoint center =
//         geo.point(latitude: widget.latitude, longitude: widget.longitude);

// // get the collection reference or query
//     var collectionReference = FirebaseFirestore.instance
//         .collection('global_ticket')
//         .where('mark_as_done', isEqualTo: false)
//         .orderBy("time", descending: true);

//     double radius = 1000;
//     String field = 'position';

//     var geoRef = geo.collection(collectionRef: collectionReference);

//     geoRef.within(
//         center: center, radius: radius, field: field, strictMode: true);

//     final myLocation =
//         Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     final Size size = MediaQuery.of(context).size;
//     final double categoryHeight = size.height *
//         0.20; //kind of sizeBox() between popular cards and normal cards

//     return Container(
//       color: Colors.indigo[900],
//       height: size.height,
//       child: StreamBuilder(
//         stream: geoRef.snapshot(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     // Text(
//                     //   "Loyality Cards",
//                     //   style: TextStyle(
//                     //       color: Colors.grey,
//                     //       fontWeight: FontWeight.bold,
//                     //       fontSize: 20),
//                     // ),
//                     // Text(
//                     //   "Menu",
//                     //   style: TextStyle(
//                     //       // color: Colors.black,
//                     //       fontWeight: FontWeight.bold,
//                     //       fontSize: 20),
//                     // ),
//                   ],
//                 ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 // AnimatedOpacity(
//                 //   duration: const Duration(milliseconds: 100),
//                 //   opacity: closeTopContainer ? 0 : 1,
//                 //   child: AnimatedContainer(
//                 //       duration: const Duration(milliseconds: 200),
//                 //       width: size.width,
//                 //       alignment: Alignment.topCenter,
//                 //       height: closeTopContainer ? 0 : categoryHeight,
//                 //       child: categoriesScroller),
//                 // ),
//                 Flexible(
//                     child: ListView.builder(
//                   itemExtent: 140,
//                   scrollDirection: Axis.vertical,
//                   controller: controller,
//                   physics: BouncingScrollPhysics(),
//                   itemCount: snapshot.data.docs.length,
//                   itemBuilder: (BuildContext context, index) {
//                     double scale = 1.0;
//                     if (topContainer > 1) {
//                       scale = index + 1 - topContainer;
//                       if (scale < 0) {
//                         scale = 0;
//                       } else if (scale > 1) {
//                         scale = 1;
//                       }
//                     }
//                     String photoInListTile;
//                     var x = FirebaseFirestore.instance
//                         .collection("user_account")
//                         .doc(snapshot.data.docs[index]['ticket_owner'])
//                         .get()
//                         .then(
//                             (value) => {photoInListTile = value.get("photo")});
//                     // Future.delayed(const Duration(milliseconds: 500), () {

//                     print("--------------");
//                     print(photoInListTile);

//                     // });

//                     return Opacity(
//                       opacity: scale,
//                       child: Transform(
//                         transform: Matrix4.identity()..scale(scale, scale),
//                         alignment: Alignment.bottomCenter,

//                         // color: Colors.yellowAccent,
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ticketViewScreen(
//                                         snapshot.data.docs[index]
//                                             ['ticket_owner'],
//                                         snapshot.data.docs[index]['title'],
//                                         snapshot.data.docs[index]
//                                             ['description'],
//                                         snapshot.data.docs[index]['id'],
//                                         snapshot.data.docs[index]
//                                             ['mark_as_done'],
//                                         snapshot.data.docs[index]
//                                             ['uplodedPhoto'],
//                                         snapshot.data.docs[index]['latitude'],
//                                         snapshot.data.docs[index]['longitude'],
//                                       ),
//                                     ));
//                               },
//                               child: Stack(
//                                 overflow: Overflow.visible,
//                                 children: [
//                                   Positioned(
//                                     left: 35,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black,
//                                             // spreadRadius: 5,
//                                             blurRadius: 5.0,
//                                             offset: Offset(5, 8),
//                                           ),
//                                         ],
//                                         color: Colors.amberAccent,
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                       constraints: BoxConstraints(
//                                           maxWidth: 300, maxHeight: 110),
//                                     ),
//                                   ),
//                                   Positioned(
//                                       left: 0,
//                                       top: 15,
//                                       child: CircleAvatar(
//                                           minRadius: 40,
//                                           backgroundImage: NetworkImage(snapshot
//                                               .data
//                                               .docs[index]['uplodedPhoto']))),
//                                   Positioned(
//                                       top: 25,
//                                       left: 100,
//                                       child: Text(
//                                           snapshot.data.docs[index]['title'])),
//                                   Positioned(
//                                       top: 55,
//                                       left: 100,
//                                       child: Text(snapshot.data.docs[index]
//                                           ['description']))
//                                 ],
//                               ),
//                             ),
//                             // child: Container(
//                             //   decoration: BoxDecoration(
//                             //     color: Colors.purple[900],
//                             //     borderRadius: BorderRadius.circular(30),
//                             //     boxShadow: [
//                             //       BoxShadow(
//                             //         color: Colors.black,
//                             //         // spreadRadius: 5,
//                             //         blurRadius: 5.0,
//                             //         offset: Offset(5, 8),
//                             //       ),
//                             //     ],
//                             //   ),
//                             //   child: Row(
//                             //     children: [
//                             //       Container(
//                             //         height: 160,
//                             //         width: 140,
//                             //         // color: Colors.black,

//                             //         child: FutureBuilder(
//                             //             future: Future.delayed(
//                             //                 Duration(seconds: 1)),
//                             //             builder: (c, s) => s
//                             //                         .connectionState ==
//                             //                     ConnectionState.done
//                             //                 ? Padding(
//                             //                     padding:
//                             //                         const EdgeInsets.all(9.0),
//                             //                     child: CircleAvatar(
//                             //                       backgroundImage:
//                             //                           NetworkImage(
//                             //                               "$photoInListTile"),
//                             //                     ),
//                             //                   )
//                             //                 : Center(
//                             //                     child:
//                             //                         CircularProgressIndicator())),
//                             //       ),
//                             //       Column(
//                             //         crossAxisAlignment:
//                             //             CrossAxisAlignment.start,
//                             //         children: [
//                             //           SizedBox(
//                             //             height: 20,
//                             //           ),
//                             //           Text(
//                             //             "Priya Singh",
//                             //             style: TextStyle(
//                             //                 color: Colors.white,
//                             //                 fontSize: 22),
//                             //           ),
//                             //           SizedBox(
//                             //             height: 15,
//                             //           ),
//                             //           Text("Title",
//                             //               style: TextStyle(
//                             //                   color: Colors.blue,
//                             //                   fontSize: 20)),
//                             //           Text("Description....",
//                             //               style: TextStyle(
//                             //                   color: Colors.blue,
//                             //                   fontSize: 17))
//                             //         ],
//                             //       )
//                             //     ],
//                             //   ),
//                             // ),
//                           ),
//                         ),
//                       ),
//                     );

//                     // Opacity(
//                     //   opacity: scale,
//                     //   child: Card(
//                     //       color: Colors.yellowAccent,
//                     //       child: Row(
//                     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //         children: [
//                     //           Transform(
//                     //             transform: Matrix4.identity()
//                     //               ..scale(scale, scale),
//                     //             child: ListTile(
//                     //               onTap: () {
//                     //                 showDialog(
//                     //                     context: context,
//                     //                     builder: (context) => PopupTicketPage(
//                     //                         snapshot.data.docs[index]
//                     //                             ['ticket_owner'],
//                     //                         snapshot.data.docs[index]
//                     //                             ['title'],
//                     //                         snapshot.data.docs[index]
//                     //                             ['description'],
//                     //                         snapshot.data.docs[index]['id'],
//                     //                         snapshot.data.docs[index]
//                     //                             ['mark_as_done']));
//                     //               },
//                     //               title: Text(
//                     //                   snapshot.data.docs[index]['title']),
//                     //               subtitle: Text(snapshot.data.docs[index]
//                     //                   ['description']),
//                     //             ),
//                     //           ),
//                     //           Flexible(
//                     //               child: Text(
//                     //                   distanceBetweenTicketCreaterAndResponder +
//                     //                       "  meters"))
//                     //         ],
//                     //       )),
//                     // );
//                   },
//                 )
//                     // Opacity(
//                     //   opacity: scale,
//                     //   child: Transform(
//                     //     transform: Matrix4.identity()
//                     //       ..scale(scale, scale),
//                     //     alignment: Alignment.bottomCenter,
//                     //     child: Align(
//                     //         heightFactor: 0.7,
//                     //         alignment: Alignment.topCenter,
//                     //         child: Text(
//                     //             snapshot.data.docs[index]['title'])),
//                     //   ),
//                     // );

//                     ),
//               ],
//             );
//             // GridView.builder(
//             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //     crossAxisCount: 2,
//             //   ),
//             //   scrollDirection: Axis.vertical,
//             //   physics: BouncingScrollPhysics(),
//             //   itemCount: snapshot.data.docs.length,
//             //   itemBuilder: (BuildContext context, index) {
//             //     double distanceInMeters = Geolocator.distanceBetween(
//             //         widget.latitude,
//             //         widget.longitude,
//             //         snapshot.data.docs[index]['latitude'],
//             //         snapshot.data.docs[index]['longitude']);
//             //     String distanceBetweenTicketCreaterAndResponder =
//             //         distanceInMeters.toStringAsFixed(2);
//             //     return Card(
//             //         color: Colors.yellowAccent,
//             //         child: Row(
//             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //           children: [
//             //             Flexible(
//             //               child: ListTile(
//             //                 onTap: () {
//             //                   showDialog(
//             //                       context: context,
//             //                       builder: (context) => PopupTicketPage(
//             //                           snapshot.data.docs[index]
//             //                               ['ticket_owner'],
//             //                           snapshot.data.docs[index]['title'],
//             //                           snapshot.data.docs[index]
//             //                               ['description'],
//             //                           snapshot.data.docs[index]['id'],
//             //                           snapshot.data.docs[index]
//             //                               ['mark_as_done']));
//             //                 },
//             //                 title: Text(snapshot.data.docs[index]['title']),
//             //                 subtitle: Text(
//             //                     snapshot.data.docs[index]['description']),
//             //               ),
//             //             ),
//             //             Flexible(
//             //                 child: Text(
//             //                     distanceBetweenTicketCreaterAndResponder +
//             //                         "  meters"))
//             //           ],
//             //         ));
//             //   },
//             // );
//           }
//         },
//       ),
//     );
//   }
// }

// // class CategoriesScroller extends StatelessWidget {
// //   const CategoriesScroller();

// //   @override
// //   Widget build(BuildContext context) {
// //     final double categoryHeight =
// //         MediaQuery.of(context).size.height * 0.20 - 30;
// //     return SingleChildScrollView(
// //       physics: BouncingScrollPhysics(),
// //       scrollDirection: Axis.horizontal,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// //         child: FittedBox(
// //           fit: BoxFit.fill,
// //           alignment: Alignment.topCenter,
// //           child: Row(
// //             children: <Widget>[
// //               Container(
// //                 width: 150,
// //                 margin: EdgeInsets.only(right: 20),
// //                 height: categoryHeight,
// //                 decoration: BoxDecoration(
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black,
// //                         // spreadRadius: 10,
// //                         blurRadius: 5.0,
// //                         offset: Offset(10, 10),
// //                       ),
// //                     ],
// //                     color: Colors.orange.shade400,
// //                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: <Widget>[
// //                       Text(
// //                         "Most\nFavorites",
// //                         style: TextStyle(
// //                             fontSize: 25,
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(
// //                         height: 10,
// //                       ),
// //                       Text(
// //                         "20 Items",
// //                         style: TextStyle(fontSize: 16, color: Colors.white),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               Container(
// //                 width: 150,
// //                 margin: EdgeInsets.only(right: 20),
// //                 height: categoryHeight,
// //                 decoration: BoxDecoration(
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black,
// //                         // spreadRadius: 10,
// //                         blurRadius: 5.0,
// //                         offset: Offset(10, 10),
// //                       ),
// //                     ],
// //                     color: Colors.blue.shade400,
// //                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
// //                 child: Container(
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(12.0),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: <Widget>[
// //                         Text(
// //                           "Newest",
// //                           style: TextStyle(
// //                               fontSize: 25,
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold),
// //                         ),
// //                         SizedBox(
// //                           height: 10,
// //                         ),
// //                         Text(
// //                           "20 Items",
// //                           style: TextStyle(fontSize: 16, color: Colors.white),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Container(
// //                 width: 150,
// //                 margin: EdgeInsets.only(right: 20),
// //                 height: categoryHeight,
// //                 decoration: BoxDecoration(
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black,
// //                         // spreadRadius: 10,
// //                         blurRadius: 5.0,
// //                         offset: Offset(10, 10),
// //                       ),
// //                     ],
// //                     color: Colors.lightBlueAccent.shade400,
// //                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: <Widget>[
// //                       Text(
// //                         "Super\nSaving",
// //                         style: TextStyle(
// //                             fontSize: 25,
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(
// //                         height: 10,
// //                       ),
// //                       Text(
// //                         "20 Items",
// //                         style: TextStyle(fontSize: 16, color: Colors.white),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
