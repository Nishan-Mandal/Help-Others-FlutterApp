import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_others/screens/CreateTickets.dart';
import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/screens/GetOtpScreen.dart';
import 'package:help_others/screens/GetStartedPage.dart';
import 'package:help_others/screens/MyTickets.dart';
import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/screens/PrivacyPolicy.dart';
import 'package:help_others/screens/ProfilePage.dart';
import 'package:help_others/services/Database.dart';
import 'package:sms_autofill/sms_autofill.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

  runApp(MyApp());
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
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: {'/navigationBar': (context) => navigationBar()},
            home: LandingPage(),
            debugShowCheckedModeBanner: false,
          );
        }

        return CircularProgressIndicator();
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    print("object999999999999999999999999999999");
    print(latitudeData1);
    print(longitudeData1);
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitudeData1 = geoposition.latitude;
      longitudeData1 = geoposition.longitude;
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
  bool acceptAll = true;
  // uploadUserPhoneNumberAndUid() {
  //   Map<String, String> userPhoneMap = {
  //     "mobile_number": _phoneNumberController.text,
  //     "uid": FirebaseAuth.instance.currentUser.uid
  //   };
  //   databaseMethods.uploadUserInfo(userPhoneMap);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup page"),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                labelText: "+91"),
                            validator: (value) {
                              return value.isEmpty
                                  ? "Please provide UserName"
                                  : null;
                            },
                            controller: _phoneNumberController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: acceptAll,
                        onChanged: (value) {
                          setState(() {
                            acceptAll = value;
                          });
                        },
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => privacyPolicy(),
                                ));
                          },
                          child: Text(
                            "I have read and accept the \nTerms & Conditions",
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      child: Text("Get Otp"),
                      onPressed: () async {
                        if (acceptAll) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GetOtpPage(_phoneNumberController.text),
                              ));
                        }
                      },
                    ),
                  ),
                ],
              )),
        ));
  }
} //end of class
