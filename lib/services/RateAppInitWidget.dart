// import 'package:flutter/material.dart';
// import 'package:rate_my_app/rate_my_app.dart';

// class RateAppInitWidget extends StatefulWidget {
//   final Widget Function(RateMyApp) builder;
//   const RateAppInitWidget({Key key, this.builder}) : super(key: key);

//   @override
//   _RateAppInitWidgetState createState() => _RateAppInitWidgetState();
// }

// class _RateAppInitWidgetState extends State<RateAppInitWidget> {
//   RateMyApp rateMyApp;
//   @override
//   Widget build(BuildContext context) {
//     return RateMyAppBuilder(
//       rateMyApp: RateMyApp(googlePlayIdentifier: 'com.android.chrome'),
//       onInitialized: (context, rateMyApp) {
//         setState(() {
//           this.rateMyApp = rateMyApp;
//         });
//       },
//       builder: (context) => rateMyApp == null
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : widget.builder(rateMyApp),
//     );
//   }
// }
