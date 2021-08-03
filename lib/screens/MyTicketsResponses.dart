// import 'package:flutter/material.dart';

// import 'package:help_others/services/Database.dart';

// class myTicketsResponses extends StatefulWidget {
//   String ticketOwnweMobileNumber;
//   String title;
//   String description;
//   String id;
//   bool markAsDone;
//   String photo;
//   double latitude;
//   double longitude;
//   String date;
//   myTicketsResponses(
//       this.ticketOwnweMobileNumber,
//       this.title,
//       this.description,
//       this.id,
//       this.markAsDone,
//       this.photo,
//       this.latitude,
//       this.longitude,
//       this.date);

//   @override
//   _myTicketsResponsesState createState() => _myTicketsResponsesState();
// }

// class _myTicketsResponsesState extends State<myTicketsResponses> {
//   @override
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   // final TextEditingController messageControler = TextEditingController();
//   bool responded = false;

//   Future<bool> onBackPress() {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         // shape:
//         //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
//         title: Text("Do you want to delete your post ?"),
//         // backgroundColor: Colors.amber[300],
//         actions: [
//           ElevatedButton(
//             child: Text("No"),
//             onPressed: () => Navigator.pop(context, false),
//           ),
//           ElevatedButton(
//             child: Text("Yes"),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//               databaseMethods.deleteTicket(widget.id, widget.photo);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var queryData = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 onBackPress();
//               })
//         ],
//       ),
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [Colors.white, Colors.grey])),
//                       height: 250,
//                       width: queryData.width,
//                       child: Image(
//                         image: NetworkImage(widget.photo),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(9.0),
//                       child: Text(
//                         widget.title,
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(widget.date),
//                         SizedBox(
//                           width: 15,
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(9.0),
//                       child: Text("Description",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 12, right: 12),
//                       child: Container(
//                         width: queryData.width,
//                         height: queryData.height / 4,
//                         color: Colors.grey[300],
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text(widget.description,
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w400)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
