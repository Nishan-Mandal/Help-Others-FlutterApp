import 'package:flutter/material.dart';

class PopupTicketPage extends StatefulWidget {
  PopupTicketPage({Key key}) : super(key: key);

  @override
  _PopupTicketPageState createState() => _PopupTicketPageState();
}

class _PopupTicketPageState extends State<PopupTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        color: Colors.amber,
        height: 400,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(),
        ),
      ),
    );
  }
}
