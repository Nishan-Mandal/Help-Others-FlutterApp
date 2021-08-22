import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/Drawer.dart';
import 'package:help_others/services/Constants.dart';

import 'package:pinput/pin_put/pin_put.dart';

import 'ProfilePage.dart';

class GetOtpPage extends StatefulWidget {
  String phoneNumber;
  bool acceptAllTermsAndConditions;
  bool iam18Plus;

  GetOtpPage(
      this.phoneNumber, this.acceptAllTermsAndConditions, this.iam18Plus);

  @override
  _GetOtpPageState createState() => _GetOtpPageState();
}

class _GetOtpPageState extends State<GetOtpPage> {
  int counter = 180;
  Timer timer;
  void startTimer() {
    counter = 180;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          resendButton = true;
          timer.cancel();
        }
      });
    });
  }

  // final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  bool resendButton = false;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            child: Center(
              child: Text(
                'OTP sent to ${widget.phoneNumber}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Constants.searchIcon),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(fontSize: 25.0, color: Constants.searchIcon),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => checkUserExistance(
                                  widget.acceptAllTermsAndConditions,
                                  widget.iam18Plus)),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          ),
          Text(
            "You can resend OTP after ${counter} seconds",
            style: TextStyle(color: Constants.searchIcon),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Text(
              "Wrong number? I want to edit my number.",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Constants.searchIcon),
            child: Text("Resend OTP", style: TextStyle(color: Colors.black)),
            onPressed: () {
              setState(() {
                if (resendButton) {
                  resendButton = false;
                  startTimer();
                  _verifyPhone();
                }
              });
            },
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    startTimer();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              timer.cancel();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => checkUserExistance(
                        widget.acceptAllTermsAndConditions, widget.iam18Plus),
                  ),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }
}
