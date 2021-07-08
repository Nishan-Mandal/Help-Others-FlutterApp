import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/CreateTickets.dart';

import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/screens/NavigationBar.dart';
import 'package:help_others/services/Database.dart';

import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class checkUserExistance extends StatefulWidget {
  checkUserExistance({Key key}) : super(key: key);

  @override
  _checkUserExistanceState createState() => _checkUserExistanceState();
}

class _checkUserExistanceState extends State<checkUserExistance> {
  @override
  Widget build(BuildContext context) {
    CollectionReference user =
        FirebaseFirestore.instance.collection("user_account");
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(FirebaseAuth.instance.currentUser.phoneNumber).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data.exists) {
          return userSignupPage();
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
  @override
  _userSignupPageState createState() => _userSignupPageState();
}

class _userSignupPageState extends State<userSignupPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final nameformKey = GlobalKey<FormState>();

  // final TextEditingController userEmailControler = TextEditingController();

  PickedFile imageFile;

  final ImagePicker picker = ImagePicker();

  signUp() async {
    String userImageUrl;
    File file = File(imageFile.path);

    if (nameformKey.currentState.validate()) {
      try {
        await FirebaseStorage.instance
            .ref(
                'user_profile_image${FirebaseAuth.instance.currentUser.phoneNumber}')
            .putFile(file);

        userImageUrl = await FirebaseStorage.instance
            .ref(
                'user_profile_image${FirebaseAuth.instance.currentUser.phoneNumber}')
            .getDownloadURL();
      } on FirebaseException catch (e) {
        print("error in uploding user image");
      }

      databaseMethods.uploadUserInfo(
          userNameControler.text,
          FirebaseAuth.instance.currentUser.phoneNumber,
          userImageUrl,
          FirebaseAuth.instance.currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        height: queryData.size.height,
        width: queryData.size.width,
        child: Column(
          children: [
            Center(
                child: Stack(
              children: [
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: imageFile == null
                      ? AssetImage("PicsArt_01-01-08.21.28.jpg")
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
                        color: Colors.teal,
                        size: 28.0,
                      ),
                    ))
              ],
            )),
            SizedBox(
              height: 50,
            ),
            Form(
              key: nameformKey,
              child: Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    return value.isEmpty ? "Please provide UserName" : null;
                  },
                  controller: userNameControler,
                ),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Form(
            //   key: emailformKey,
            //   child: Flexible(
            //     child: TextFormField(
            //       decoration: InputDecoration(
            //         labelText: "Email",
            //         enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.black),
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       validator: (value) {
            //         return value.isEmpty ? "Please provide email" : null;
            //       },
            //       controller: userEmailControler,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () {
                signUp();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => navigationBar(),
                    ),
                    (route) => false);
              },
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
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
              ),
              SizedBox(
                width: 50,
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickerFile = await picker.getImage(source: source);

    setState(() {
      imageFile = pickerFile;
    });
  }
}
