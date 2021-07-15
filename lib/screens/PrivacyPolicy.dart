import 'package:flutter/material.dart';

class privacyPolicy extends StatefulWidget {
  @override
  _privacyPolicyState createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
      ),
      body: Container(
        child: Container(
          child: Text("Terms & Conditions"),
        ),
      ),
    );
  }
}
