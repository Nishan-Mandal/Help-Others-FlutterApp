import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:help_others/screens/TicketViewScreen.dart';
import 'package:help_others/services/Constants.dart';

class seeProfileOfTicketOwner extends StatefulWidget {
  String photo;
  String name;
  String ticketOwnweMobileNumber;
  seeProfileOfTicketOwner(this.photo, this.name, this.ticketOwnweMobileNumber);

  @override
  _seeProfileOfTicketOwnerState createState() =>
      _seeProfileOfTicketOwnerState();
}

class _seeProfileOfTicketOwnerState extends State<seeProfileOfTicketOwner> {
  bool myFavFlag = false;
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.scaffoldBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Constants.appBar,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      widget.photo,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ph :" +
                            FirebaseAuth.instance.currentUser.phoneNumber
                                .substring(0, 3) +
                            "xxxxxx" +
                            widget.ticketOwnweMobileNumber.substring(
                                widget.ticketOwnweMobileNumber.length - 4,
                                widget.ticketOwnweMobileNumber.length),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Published Ads",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                height: 300,
                width: queryData.width,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('global_ticket')
                        .where('ticket_owner',
                            isEqualTo: widget.ticketOwnweMobileNumber)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Constants.searchIcon)),
                        );
                      } else {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('global_ticket')
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (context, snapshot2) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  String title =
                                      snapshot.data.docs[index]["title"];
                                  String description =
                                      snapshot.data.docs[index]["description"];
                                  String address =
                                      snapshot.data.docs[index]["address"];
                                  try {
                                    List l = snapshot2.data.docs[index]
                                        ["favourites"];
                                    if (l.contains(FirebaseAuth
                                        .instance.currentUser.phoneNumber)) {
                                      myFavFlag = true;
                                    }
                                  } catch (e) {
                                    myFavFlag = false;
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ticketViewScreen(
                                                snapshot.data.docs[index]
                                                    ["ticket_owner"],
                                                snapshot.data.docs[index]
                                                    ["title"],
                                                snapshot.data.docs[index]
                                                    ["description"],
                                                snapshot.data.docs[index]["id"],
                                                snapshot.data.docs[index]
                                                    ["uplodedPhoto"],
                                                snapshot.data.docs[index]
                                                    ["latitude"],
                                                snapshot.data.docs[index]
                                                    ["longitude"],
                                                snapshot.data.docs[index]
                                                    ["date"],
                                                snapshot.data.docs[index]
                                                    ["share_mobile"],
                                                myFavFlag,
                                                snapshot.data.docs[index]
                                                    ["address"],
                                                snapshot.data.docs[index]
                                                    ["category"],
                                              ),
                                            ));
                                      },
                                      child: Container(
                                          height: 50,
                                          width: 180,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 180,
                                                  width: 160,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              "loadingImage.png")),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      )),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    child: Image.network(
                                                      snapshot.data.docs[index]
                                                          ["uplodedPhoto"],
                                                      cacheHeight: 250,
                                                      cacheWidth: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                height: 2,
                                                thickness: 1,
                                                color: Constants.divider,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  title.length > 20
                                                      ? title.substring(0, 20) +
                                                          "..."
                                                      : title,
                                                  style: TextStyle(
                                                      color:
                                                          Constants.titleText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  description.length > 20
                                                      ? description.substring(
                                                              0, 20) +
                                                          "..."
                                                      : description,
                                                  style: TextStyle(
                                                      color: Constants
                                                          .descriptionText),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, top: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Constants
                                                              .addressText,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          address.length > 7
                                                              ? address
                                                                      .substring(
                                                                          0,
                                                                          8) +
                                                                  ".."
                                                              : address,
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .locationMarker,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 20,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            snapshot.data.docs[
                                                                        index][
                                                                    "share_mobile"]
                                                                ? Icons.call
                                                                : Icons
                                                                    .phone_disabled,
                                                            size: 22,
                                                            color: Constants
                                                                .callIcon,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            FontAwesome
                                                                .comments_o,
                                                            color: Constants
                                                                .chatIcon,
                                                            size: 22,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              );
                            });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
