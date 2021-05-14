import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/main.dart';
import 'package:help_others/services/Database.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'ProfilePage.dart';

class GetOtpPage extends StatefulWidget {
  String phoneNumber;
  GetOtpPage(this.phoneNumber);

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
          print(counter);
        } else {
          resendButton = true;
          timer.cancel();
        }
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
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
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            child: Center(
              child: Text(
                'OTP sent to ${widget.phoneNumber}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
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
                              builder: (context) => userSignupPage()),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          ),
          Text("You can resend OTP after ${counter} seconds"),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            child: Text("Resend OTP"),
            onPressed: () {
              setState(() {
                if (resendButton) {
                  resendButton = false;
                  startTimer();
                  _verifyPhone();
                } else {
                  print("Button i s disable");
                  null;
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
    if(widget.phoneNumber[0]!='+'){
      widget.phoneNumber="+91"+widget.phoneNumber;
  }
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              timer.cancel();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userSignupPage(),
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
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
