import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_others/main.dart';
import 'package:help_others/screens/GetStartedPage.dart';

import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/Database.dart';
import 'package:help_others/screens/FirstAd.dart';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

class checkUserExistance extends StatefulWidget {
  bool acceptAllTermsAndConditions;
  bool iam18Plus;
  checkUserExistance(this.acceptAllTermsAndConditions, this.iam18Plus);

  @override
  _checkUserExistanceState createState() => _checkUserExistanceState();
}

class _checkUserExistanceState extends State<checkUserExistance> {
  bool flag = false;
  void checkDefaultTicket() async {
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
  }

  @override
  void initState() {
    super.initState();
    checkDefaultTicket();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference user =
        FirebaseFirestore.instance.collection("user_account");
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(FirebaseAuth.instance.currentUser.phoneNumber).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Something went wrong")));
        }
        if (snapshot.hasData && !snapshot.data.exists) {
          return userSignupPage(
              widget.acceptAllTermsAndConditions, widget.iam18Plus);
        } else if (!flag) {
          return firstAd(latitudeData1, longitudeData1);
        } else {
          FirebaseFirestore.instance
              .collection("user_account")
              .doc(FirebaseAuth.instance.currentUser.phoneNumber)
              .update({"uid": FirebaseAuth.instance.currentUser.uid});
          return navigationBar();
        }
      },
    );
  }
}

TextEditingController userNameControler = new TextEditingController();

class userSignupPage extends StatefulWidget {
  bool acceptAllTermsAndConditions;
  bool iam18Plus;
  userSignupPage(this.acceptAllTermsAndConditions, this.iam18Plus);
  @override
  _userSignupPageState createState() => _userSignupPageState();
}

class _userSignupPageState extends State<userSignupPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final nameformKey = GlobalKey<FormState>();

  PickedFile imageFile;

  final ImagePicker picker = ImagePicker();

  signUp() async {
    String userImageUrl;
    bool flag = false;
    File file;
    try {
      file = File(imageFile.path);
    } catch (e) {
      flag = true;
      print(e.toString());
    }

    if (nameformKey.currentState.validate() && !flag) {
      try {
        var folder = FirebaseAuth.instance.currentUser.phoneNumber;
        await FirebaseStorage.instance
            .ref('$folder/user_profile_image')
            .putFile(file);

        userImageUrl = await FirebaseStorage.instance
            .ref('$folder/user_profile_image')
            .getDownloadURL();
      } on FirebaseException catch (e) {
        print("error in uploding user image");
      }

      databaseMethods.uploadUserInfo(
        userNameControler.text,
        FirebaseAuth.instance.currentUser.phoneNumber,
        userImageUrl,
        FirebaseAuth.instance.currentUser.uid,
        widget.acceptAllTermsAndConditions,
        widget.iam18Plus,
      );
    } else {
      userImageUrl =
          "https://firebasestorage.googleapis.com/v0/b/bbold-6f546.appspot.com/o/person%20icon.png?alt=media&token=2f605669-8a3e-4fcd-b03a-f1a368e3179b";
      databaseMethods.uploadUserInfo(
        userNameControler.text,
        FirebaseAuth.instance.currentUser.phoneNumber,
        userImageUrl,
        FirebaseAuth.instance.currentUser.uid,
        widget.acceptAllTermsAndConditions,
        widget.iam18Plus,
      );
    }
  }

  defaultAccountDetails() {
    String userImageUrl =
        "https://firebasestorage.googleapis.com/v0/b/bbold-6f546.appspot.com/o/person%20icon.png?alt=media&token=2f605669-8a3e-4fcd-b03a-f1a368e3179b";
    String uid = FirebaseAuth.instance.currentUser.uid;
    String defaultName =
        uid.substring(0, 5) + uid.substring(uid.length - 5, uid.length - 1);
    databaseMethods.uploadUserInfo(
      defaultName,
      FirebaseAuth.instance.currentUser.phoneNumber,
      userImageUrl,
      FirebaseAuth.instance.currentUser.uid,
      widget.acceptAllTermsAndConditions,
      widget.iam18Plus,
    );
  }

  @override
  void initState() {
    super.initState();
    defaultAccountDetails();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Constants.appBar,
        title: Text(
          "Profile",
          style: TextStyle(color: Constants.searchIcon),
        ),
      ),
      body: Container(
        height: queryData.size.height,
        width: queryData.size.width,
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage: imageFile == null
                        ? AssetImage("personIcon.png")
                        : FileImage(File(imageFile.path)),
                  ),
                  Positioned(
                      bottom: 15.0,
                      right: 0.0,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => bottomSheet(),
                          );
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: Constants.searchIcon,
                          size: 28.0,
                        ),
                      ))
                ],
              ),
            )),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: nameformKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(color: Constants.searchIcon),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.searchIcon),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.searchIcon),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: Constants.searchIcon),
                  validator: (value) {
                    return value.isEmpty ? "Please provide UserName" : null;
                  },
                  controller: userNameControler,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Constants.searchIcon),
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (nameformKey.currentState.validate()) {
                    signUp();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              firstAd(latitudeData1, longitudeData1),
                        ),
                        (route) => false);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
      height: 100,
      width: queryData.size.width,
      margin: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Text(
            "choose a profile photo",
            style: TextStyle(fontSize: 20, color: Constants.searchIcon),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera, color: Constants.searchIcon),
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                  ),
                  Text("Camera", style: TextStyle(color: Constants.searchIcon))
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Constants.searchIcon),
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                  ),
                  Text("Gallery", style: TextStyle(color: Constants.searchIcon))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  final imageSizeisTooLarge = SnackBar(
    content: Text('Image size is too large'),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.redAccent,
  );
  void takePhoto(ImageSource source) async {
    final pickerFile = await picker.getImage(
        source: source, imageQuality: 25, maxHeight: 200, maxWidth: 200);
    var bytes = new File(pickerFile.path);
    var enc = await bytes.readAsBytes();

    if (enc.length >= 500000) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(imageSizeisTooLarge);
    } else {
      setState(() {
        imageFile = pickerFile;
        Navigator.pop(context);
      });
    }
  }
}
