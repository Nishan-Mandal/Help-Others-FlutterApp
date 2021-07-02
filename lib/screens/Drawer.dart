import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/MyTickets.dart';

import '../main.dart';
import 'NavigationBar.dart';

class drawer extends StatefulWidget {
  drawer({Key key}) : super(key: key);

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
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
      print(e); // TODO: show dialog with error
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

  @override
  Widget build(BuildContext context) {
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
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        color: Colors.blueGrey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 120,
                              height: 120,
                              child: CircleAvatar(
                                  radius: 80.0,
                                  backgroundImage: snapshot.hasData
                                      ? NetworkImage(userDocument['photo'])
                                      : CircularProgressIndicator()),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              userDocument['name'],
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            Text(
                              userDocument['email'],
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          "Profile",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () => _signOut(),
                      ),
                    ],
                  );
                })),
      ),
    );
  }
}
