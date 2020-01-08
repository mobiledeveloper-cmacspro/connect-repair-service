import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/DoorFitting.dart';
import 'package:repairservices/SlidingGeneralData.dart';
import 'package:repairservices/WindowsGeneralData.dart';

class FittingSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Fitting selection'),style: Theme.of(context).textTheme.body1),
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
               children: <Widget>[
                 GestureDetector(
                   child: Column(
                     children: <Widget>[
                       Image.asset('assets/windowsFitting.png'),
                       Padding(
                           padding: EdgeInsets.only(top: 8),
                           child: Text(FlutterI18n.translate(context, 'Windows fittings'),style: TextStyle(fontSize: 14))
                       )
                     ],
                   ),
                   onTap: () {
                     Navigator.push(context, CupertinoPageRoute(builder: (context) => WindowsGeneralData(TypeFitting.windows)));
                   },
                 ),
                 GestureDetector(
                   child: Column(
                     children: <Widget>[
                       Image.asset('assets/doorFitting.png'),
                       Padding(
                           padding: EdgeInsets.only(top: 8),
                           child: Text(FlutterI18n.translate(context, 'Door fittings'),style: TextStyle(fontSize: 14))
                       )
                     ],
                   ),
                   onTap: () {
                     Navigator.push(context, CupertinoPageRoute(builder: (context) => DoorFitting()));
                   },
                 ),
                 GestureDetector(
                   child: Column(
                     children: <Widget>[
                       Image.asset('assets/slidingFitting.png'),
                       Padding(
                           padding: EdgeInsets.only(top: 8),
                           child: Text(FlutterI18n.translate(context, 'Sliding system'),style: TextStyle(fontSize: 14))
                       )
                     ],
                   ),
                   onTap: () {
                     Navigator.push(context, CupertinoPageRoute(builder: (context) => SlidingGeneralData()));
                   },
                 )
               ],
             ),
           ),
           Padding(
             padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 GestureDetector(
                   child: Column(
                     children: <Widget>[
                       Image.asset('assets/windowsFitting.png'),
                       Padding(
                           padding: EdgeInsets.only(top: 8),
                           child: Text(FlutterI18n.translate(context, 'Other'),style: TextStyle(fontSize: 14))
                       )
                     ],
                   ),
                   onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => WindowsGeneralData(TypeFitting.other))),
                 ),
                 GestureDetector(
                   child: Column(
                     children: <Widget>[
                       Image.asset('assets/doorFitting.png'),
                       Padding(
                           padding: EdgeInsets.only(top: 8),
                           child: Container(
                               width: 90,
                               child: Text(FlutterI18n.translate(context, 'Sun shading and screening'),style: TextStyle(fontSize: 14),maxLines: 2,textAlign: TextAlign.center,)
                           )
                       )
                     ],
                   ),
                   onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => WindowsGeneralData(TypeFitting.sunShading))),
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