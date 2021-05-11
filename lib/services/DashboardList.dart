import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:help_others/screens/PopUpTicket.dart';
import 'package:help_others/services/Database.dart';

class TicketsListPage extends StatefulWidget {
  TicketsListPage({Key key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketsListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tickets')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.tealAccent,
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PopupTicketPage(),
                      );
                    },
                    title: Text(snapshot.data.docs[index]['title']),
                    subtitle: Text(snapshot.data.docs[index]['description']),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
