import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:help_others/screens/GetOtpScreen.dart';
import 'package:help_others/screens/GetStartedPage.dart';

import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/screens/PrivacyPolicy.dart';
import 'package:help_others/screens/TermsAndConditions.dart';
import 'package:help_others/screens/FirstAd.dart';
import 'package:help_others/services/Constants.dart';

import 'package:help_others/services/Database.dart';
import 'package:help_others/services/AdMob.dart';
import 'package:help_others/services/BannerAds.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:connectivity/connectivity.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initialize();
  await Firebase.initializeApp();
  final initFuture = MobileAds.instance.initialize();
  final adState = BannerAds(initFuture);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Constants.searchIcon)),
        ),
      );

  runApp(Provider.value(
    value: adState,
    builder: (context, child) => MyApp(),
  ));
}

final TextEditingController _phoneNumberController = TextEditingController();
final SmsAutoFill _autoFill = SmsAutoFill();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'BBold',
            theme: ThemeData(brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: ThemeMode.dark,
            home: LandingPage(),
            debugShowCheckedModeBanner: false,
          );
        }

        return Center(
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constants.searchIcon)));
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key key, String title}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

double latitudeData1;
double longitudeData1;

class _LandingPageState extends State<LandingPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final connectivity = SnackBar(
    content: Text('No internet connection'),
    duration: Duration(hours: 5),
    backgroundColor: Colors.redAccent,
  );

  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;
  bool dialogshown = false;
  ConnectivityResult previous;
  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkDefaultTicket();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogshown = true;
        ScaffoldMessenger.of(context).showSnackBar(connectivity);
      } else if (_previousResult == ConnectivityResult.none) {
        checkinternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          }
        });
      }

      _previousResult = connresult;
    });

    // checkDefaultTicket();
    // checkInternetConnectivity();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        // todo----
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    connectivitySubscription.cancel();
  }

  bool flag = false;
  bool isChecking = true;
  checkDefaultTicket() async {
    await FirebaseFirestore.instance
        .collection("global_ticket")
        .where("ticket_owner",
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        setState(() {
          flag = true;
        });
      });
    });
    setState(() {
      isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return GetStartrdPage();
          } else if (!flag) {
            if (isChecking) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Constants.searchIcon)));
            }
            return firstAd(latitudeData1, longitudeData1);
          } else {
            return navigationBar();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constants.searchIcon)),
            ),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool acceptAllTermsAndConditions = true;
  bool iam18Plus = true;
  String countryCode;

  void autoPickupNumber() async {
    _phoneNumberController.text = await _autoFill.hint;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoPickupNumber();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Constants.appBar,
        title: Center(
            child: Text("Enter your phone number",
                style: TextStyle(color: Constants.searchIcon))),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Form(
                      key: formKey,
                      child: Flexible(
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: CountryCodePicker(
                                  onChanged: (value) {
                                    countryCode = value.dialCode;
                                  },
                                  onInit: (value) {
                                    countryCode = value.dialCode;
                                  },
                                  showFlagMain: false,
                                  initialSelection: 'IN',
                                  barrierColor: Colors.black,
                                  dialogBackgroundColor: Colors.black,
                                  dialogTextStyle: TextStyle(
                                    color: Constants.searchIcon,
                                  ),
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  showDropDownButton: true,
                                  searchStyle: TextStyle(color: Colors.white)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.assignment_ind_outlined,
                                  color: Constants.searchIcon,
                                ),
                                onPressed: () async {
                                  _phoneNumberController.text =
                                      await _autoFill.hint;
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.searchIcon),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.searchIcon),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // labelText: "+91",
                              labelStyle:
                                  TextStyle(color: Constants.searchIcon)),
                          style: TextStyle(color: Constants.searchIcon),
                          validator: (value) {
                            return value.isEmpty
                                ? "Please provide valid number"
                                : null;
                          },
                          controller: _phoneNumberController,
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 5,
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "NOTE: We will not share your number without your consent.",
                        style: TextStyle(
                            fontSize: 11, color: Constants.searchIcon),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Constants.searchIcon,
                      checkColor: Colors.black,
                      value: acceptAllTermsAndConditions,
                      onChanged: (value) {
                        setState(() {
                          acceptAllTermsAndConditions = value;
                        });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "I have read and accepted the ",
                              style: TextStyle(
                                  fontSize: 12, color: Constants.searchIcon),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          termsAndConditions(),
                                    ));
                              },
                              child: Text("Terms & Conditions ",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue)),
                            ),
                            Text("and",
                                style: TextStyle(
                                    fontSize: 12, color: Constants.searchIcon)),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => privacyPolicy(),
                                ));
                          },
                          child: Text("Privacy policy",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blue)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Constants.searchIcon,
                    checkColor: Colors.black,
                    value: iam18Plus,
                    onChanged: (value) {
                      setState(() {
                        iam18Plus = value;
                      });
                    },
                  ),
                  Text(
                    "I'm over 18 ",
                    style: TextStyle(color: Constants.searchIcon),
                  )
                ],
              ),
              SizedBox(
                height: 50,
                width: queryData.width,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Constants.searchIcon),
                  child: Text(
                    "GET OTP",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    if (acceptAllTermsAndConditions &&
                        iam18Plus &&
                        _phoneNumberController.text != "") {
                      if (_phoneNumberController.text.contains("+")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetOtpPage(
                                  _phoneNumberController.text,
                                  acceptAllTermsAndConditions,
                                  iam18Plus),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetOtpPage(
                                  countryCode + _phoneNumberController.text,
                                  acceptAllTermsAndConditions,
                                  iam18Plus),
                            ));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} //end of class
