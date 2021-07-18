// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:help_others/main.dart';

// class checkInternetConnection extends StatefulWidget {
//   @override
//   _checkInternetConnectionState createState() =>
//       _checkInternetConnectionState();
// }

// class _checkInternetConnectionState extends State<checkInternetConnection> {
//   bool connectivity = false;

//   Future<bool> checkInternetConnectivity() async {
//     try {
//       final result = await InternetAddress.lookup('example.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       }
//     } on SocketException catch (_) {
//       return false;
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     putVal();
//   }

//   putVal() async {
//     connectivity = await checkInternetConnectivity();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//     print(connectivity);
//     if (connectivity) {
//       return LandingPage();
//     } else {
//       return Scaffold(
//         // backgroundColor: Colors.white,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Divider(
//                 color: Colors.grey,
//               ),
//               Text(
//                 "Mobile data is off",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//               Text(
//                   "No data connection. \nConsider turning on \nmobile data or \nturning on Wi-Fi"),
//               Divider(
//                 color: Colors.grey,
//               ),
//               FlatButton(
//                   onPressed: () {
//                     setState(() {
//                       putVal();
//                     });
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.replay_rounded),
//                       Text("      Try again")
//                     ],
//                   )),
//               Divider(
//                 color: Colors.grey,
//               )
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }
