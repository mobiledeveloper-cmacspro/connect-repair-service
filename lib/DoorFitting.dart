import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/DoorHingeDimension.dart';
import 'package:repairservices/LockDimensions.dart';

class DoorFitting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Door type'),style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/doorType.png'),
                          Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(FlutterI18n.translate(context, 'Lock'),style: TextStyle(fontSize: 14))
                          )
                        ],
                      ),
                      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => LockDimensions())),
                    ),
                    GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/hingeType.png'),
                          Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Container(
                                  width: 90,
                                  child: Text(FlutterI18n.translate(context, 'Door hinge'),style: TextStyle(fontSize: 14),maxLines: 2,textAlign: TextAlign.center,)
                              )
                          )
                        ],
                      ),
                      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => DoorHingeDimension())),
                    ),
                    GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/whiteSquare.png'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

}