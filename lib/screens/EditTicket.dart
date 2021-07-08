// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:help_others/screens/MyTicketsResponses.dart';
// import 'package:help_others/services/Database.dart';

// class editTicket extends StatefulWidget {
//   String ticketUniqueId;
//   String ticketTitle;
//   String ticketDescription;
//   editTicket(this.ticketUniqueId, this.ticketTitle, this.ticketDescription);

//   @override
//   _editTicketState createState() => _editTicketState();
// }

// class _editTicketState extends State<editTicket> {
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   final titleKey = GlobalKey<FormState>();
//   final discriptionKey = GlobalKey<FormState>();
//   final TextEditingController titleControler = TextEditingController();
//   final TextEditingController descriptionControler = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Page"),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.check),
//               onPressed: () {
//                 setState(() {
//                   String mobileNumber =
//                       FirebaseAuth.instance.currentUser.phoneNumber;
//                   databaseMethods.updateTicketInfo(
//                       widget.ticketUniqueId,
//                       titleControler.text,
//                       descriptionControler.text,
//                       false,
//                       mobileNumber);
//                 });
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) => myTicketsResponses(
//                 //           widget.ticketUniqueId,
//                 //           titleControler.text,
//                 //           descriptionControler.text),
//                 //     ));
//               }),
//         ],
//       ),
//       body: Container(
//           height: screenSize.height,
//           width: screenSize.width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Title:"),
//               Form(
//                 key: titleKey,
//                 child: Flexible(
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: widget.ticketTitle,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.greenAccent),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.red),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     validator: (value) {
//                       return value.isEmpty ? "Provide Title" : null;
//                     },
//                     controller: titleControler,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Text("Description :"),
//               Form(
//                 key: discriptionKey,
//                 child: Flexible(
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: widget.ticketDescription,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.greenAccent),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.red),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     validator: (value) {
//                       return value.isEmpty ? "Provide Description" : null;
//                     },
//                     controller: descriptionControler,
//                   ),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
