import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title:
          Text(R.string.contact, style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              R.string.weAreHereToHelp,
              style: TextStyle(fontSize: 22,color: Color.fromRGBO(38, 38, 38, 1.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              R.string.phoneNumberDE,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16,bottom: 4),
            child: Text(
              "+49 521 783400",
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              R.string.serviceTimes,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              R.string.mondayThursday8am5pm,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,bottom: 4),
            child: Text(
              R.string.friday8am3pm,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              R.string.email,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16,bottom: 4),
            child: Text(
              "cst@schueco.com",
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}