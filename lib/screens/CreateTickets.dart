import 'package:flutter/material.dart';
import 'package:help_others/main.dart';

import 'package:help_others/screens/Dashboard.dart';
import 'package:help_others/services/Database.dart';

import '../main.dart';

final TextEditingController titleControler = TextEditingController();
final TextEditingController descriptionControler = TextEditingController();

class crreateTickets extends StatefulWidget {
  crreateTickets({Key key}) : super(key: key);

  @override
  _crreateTicketsState createState() => _crreateTicketsState();
}

class _crreateTicketsState extends State<crreateTickets> {
  final titleKey = GlobalKey<FormState>();
  final discriptionKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  MyApp myapp = new MyApp();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Ticket"),
      ),
      body: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title :"),
              Form(
                key: titleKey,
                child: Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Provide Title",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      return value.isEmpty ? "Provide Title" : null;
                    },
                    controller: titleControler,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("Description :"),
              Form(
                key: discriptionKey,
                child: Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Provide Description",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      return value.isEmpty ? "Provide Description" : null;
                    },
                    controller: descriptionControler,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      Map<String, dynamic> userTicketTitle = {
                        "title": titleControler.text,
                        "description": descriptionControler.text,
                        "time": DateTime.now().millisecondsSinceEpoch
                      };
                      databaseMethods.uploadTicketInfo(userTicketTitle);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => dashboard(),
                          ));
                    });
                  },
                  child: Text("Upload"),
                ),
              ])
            ],
          )),
    );
  }
}
