import 'dart:io';

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
import 'package:help_others/services/Constants.dart';

import 'package:help_others/services/Database.dart';
import 'package:help_others/services/AdMob.dart';
import 'package:help_others/services/BannerAds.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initialize();
  final initFuture = MobileAds.instance.initialize();
  final adState = BannerAds(initFuture);
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
            theme: ThemeData(
                // bottomSheetTheme:
                //     BottomSheetThemeData(backgroundColor: Colors.red),
                // primarySwatch: Colors.blue,
                brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: ThemeMode.dark,
            // routes: {'/navigationBar': (context) => navigationBar()},
            home: LandingPage(),
            debugShowCheckedModeBanner: false,
          );
        }

        return Center(child: CircularProgressIndicator());
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
  final connectivity = SnackBar(
    content: Text('No internet connection'),
    duration: Duration(seconds: 5),
    backgroundColor: Colors.redAccent,
  );
  checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(connectivity);
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
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
          } else {
            return navigationBar();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
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
  // Future<void> termsAndConditionsInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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
        title:
            Text("Signup page", style: TextStyle(color: Constants.searchIcon)),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Form(
                  key: formKey,
                  child: Flexible(
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                            borderSide: BorderSide(color: Constants.searchIcon),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.searchIcon),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // labelText: "+91",
                          labelStyle: TextStyle(color: Constants.searchIcon)),
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
