import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/TicketViewScreen.dart';

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
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
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
                        "Ph : ******" +
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
            Container(
              height: 4,
              width: queryData.width,
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Published Ads",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                height: 250,
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
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            String title = snapshot.data.docs[index]["title"];
                            String description =
                                snapshot.data.docs[index]["description"];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ticketViewScreen(
                                            snapshot.data.docs[index]
                                                ["ticket_owner"],
                                            snapshot.data.docs[index]["title"],
                                            snapshot.data.docs[index]
                                                ["description"],
                                            snapshot.data.docs[index]["id"],
                                            snapshot.data.docs[index]
                                                ["uplodedPhoto"],
                                            snapshot.data.docs[index]
                                                ["latitude"],
                                            snapshot.data.docs[index]
                                                ["longitude"],
                                            snapshot.data.docs[index]["date"],
                                            snapshot.data.docs[index]
                                                ["share_mobile"]),
                                      ));
                                },
                                child: Container(
                                    height: 50,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 140,
                                            width: 160,
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(snapshot.data
                                                  .docs[index]["uplodedPhoto"]),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            title.length > 20
                                                ? title.substring(0, 20) + "..."
                                                : title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            description.length > 20
                                                ? description.substring(0, 20) +
                                                    "..."
                                                : description,
                                            style: TextStyle(),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            );
                          },
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
