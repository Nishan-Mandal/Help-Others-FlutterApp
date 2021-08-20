import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:help_others/screens/GetStartedPage.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:help_others/services/Constants.dart';
import 'package:help_others/services/Database.dart';
import 'package:help_others/services/AdMob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../main.dart';
import 'FirstAd.dart';
import 'NavigationBar.dart';

class drawer extends StatefulWidget {
  drawer({
    Key key,
  }) : super(
          key: key,
        );

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  PickedFile imageFile;
  final TextEditingController reasonControler = TextEditingController();
  final reasonKey = GlobalKey<FormState>();
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText;

  @override
  void initState() {
    super.initState();

    // onDeleteAccount();

    _editingController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: SizedBox(
          width: 150,
          child: TextField(
            onSubmitted: (newValue) {
              setState(() {
                initialText = newValue;
                databaseMethods.updateUserName(newValue);
                _isEditingText = false;
              });
            },
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                border: InputBorder.none, focusedBorder: InputBorder.none),
            autofocus: true,
            controller: _editingController,
          ),
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          initialText,
          style: TextStyle(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
        ));
  }

  final ImagePicker picker = ImagePicker();
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
          (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> onBackPress() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => navigationBar(),
        ),
        (route) => false);
  }

  feedback_HelpSupportByEmail(
      String toEmail, String subject, String body) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> onDeleteAccount() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        title: Column(
          children: [
            Text(
              "Do you want to deactivate your account ?",
              style: TextStyle(color: Constants.searchIcon),
            ),
            Form(
              key: reasonKey,
              child: TextFormField(
                inputFormatters: [LengthLimitingTextInputFormatter(70)],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Provide reason",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  return value.length < 10
                      ? "Reason should be more than 10 characters"
                      : null;
                },
                controller: reasonControler,
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.amber[300],
        actions: [
          ElevatedButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
            style: ElevatedButton.styleFrom(primary: Constants.searchIcon),
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Constants.searchIcon),
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              if (reasonKey.currentState.validate()) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                    (route) => false);
                await databaseMethods.deleteAccount(reasonControler.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> onLogoutPress() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to Logout ?",
            style: TextStyle(color: Constants.searchIcon)),
        actions: [
          TextButton(
            child: Text("No", style: TextStyle(color: Constants.searchIcon)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Yes", style: TextStyle(color: Constants.searchIcon)),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
    );
  }

  rateUs() {
    double ratingStars = 0;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),

        child: Container(
          height: 300,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: AssetImage("logo.png"))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enjoying BBold?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  Text("Tap a star to rate it on the"),
                  Text("Play Store."),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 1,
                    height: 6,
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        print(ratingStars);
                        ratingStars = rating;
                      });
                    },
                  ),
                  Divider(
                    thickness: 1,
                    height: 6,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                    onTap: () {
                      if (ratingStars > 2) {
                        StoreRedirect.redirect(
                          androidAppId: "com.android.chrome",
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.orange,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ]),
        ),
        // backgroundColor: Colors.amber[300],
      ),
    );
  }

  updateUserProfilePhoto() async {
    String userImageUrl;
    File file = File(imageFile.path);

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
    databaseMethods.updateUserProfilePhoto(userImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    var querydata = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user_account')
                    .doc('${FirebaseAuth.instance.currentUser.phoneNumber}')
                    .snapshots(),
                builder: (context, snapshot) {
                  var userDocument = snapshot.data;
                  initialText = userDocument["name"];
                  String userMobileNumber = userDocument["mobile_number"];
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        color: Constants.searchIcon,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage: imageFile == null
                                          ? NetworkImage(
                                              userDocument['photo'],
                                            )
                                          //  Image.network(
                                          //     userDocument['photo'],
                                          //     cacheHeight: 120,
                                          //     cacheWidth: 120,
                                          //   )
                                          : FileImage(File(imageFile.path))),
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
                                          color: Colors.black,
                                          size: 28.0,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 45,
                                ),
                                _editTitleTextField(),
                                Visibility(
                                  visible: _isEditingText,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isEditingText = false;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isEditingText = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser.phoneNumber
                                      .substring(0, 3) +
                                  "xxxxxx" +
                                  userMobileNumber.substring(
                                      userMobileNumber.length - 4,
                                      userMobileNumber.length),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          feedback_HelpSupportByEmail(
                              'ultimaterocker1994@gmail.com',
                              'Feedback |${FirebaseAuth.instance.currentUser.phoneNumber} |$initialText',
                              "");
                        },
                        leading:
                            Icon(Icons.feedback, color: Constants.searchIcon),
                        title: Text("Feedback",
                            style: TextStyle(
                                fontSize: 17, color: Constants.searchIcon)),
                      ),
                      ListTile(
                        onTap: () {
                          feedback_HelpSupportByEmail(
                              'ultimaterocker1994@gmail.com',
                              'Help support |${FirebaseAuth.instance.currentUser.phoneNumber} |$initialText',
                              "");
                        },
                        leading: Icon(Icons.contact_support,
                            color: Constants.searchIcon),
                        title: Text("Help & Support",
                            style: TextStyle(
                                fontSize: 17, color: Constants.searchIcon)),
                      ),
                      ListTile(
                        onTap: () => rateUs(),
                        leading: Icon(Icons.rate_review,
                            color: Constants.searchIcon),
                        title: Text("Rate us",
                            style: TextStyle(
                                fontSize: 17, color: Constants.searchIcon)),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.logout, color: Constants.searchIcon),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: 17, color: Constants.searchIcon),
                        ),
                        onTap: () => onLogoutPress(),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: querydata.height,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => onDeleteAccount(),
                              child: Text(
                                "Delete Account",
                                style: TextStyle(
                                    fontSize: 12, color: Constants.searchIcon),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                })),
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
                    icon: Icon(
                      Icons.image,
                      color: Constants.searchIcon,
                    ),
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
        source: source, imageQuality: 25, maxHeight: 500, maxWidth: 500);
    var bytes = new File(pickerFile.path);
    var enc = await bytes.readAsBytes();

    if (enc.length >= 500000) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(imageSizeisTooLarge);
    } else {
      setState(() {
        imageFile = pickerFile;
        updateUserProfilePhoto();
        Navigator.pop(context);
      });
    }
  }
}
