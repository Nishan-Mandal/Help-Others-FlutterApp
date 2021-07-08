import 'package:flutter/material.dart';

class privacyPolicy extends StatefulWidget {
  @override
  _privacyPolicyState createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
  bool acceptAll = false;
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        color: Colors.white,
        height: queryData.height,
        width: queryData.width,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.black12,
                height: queryData.height * 0.1,
                width: queryData.width,
                child: Text(""),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: acceptAll,
                        onChanged: (value) {
                          setState(() {
                            acceptAll = value;
                          });
                        },
                      ),
                      Text("I have read and accept the \nTerms & Conditions")
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (acceptAll) {
                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ,), (route) => false);
                      }
                    },
                    child: Text("Continue"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
