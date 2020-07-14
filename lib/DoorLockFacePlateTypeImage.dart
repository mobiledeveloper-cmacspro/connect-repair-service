import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';

class DoorLockFacePlateTypeImage extends StatelessWidget {
  final String imageStr;
  DoorLockFacePlateTypeImage(this.imageStr);
  Image _getSquare(int imageNumber){
    if (imageStr != null && imageStr != ''){
      switch (imageNumber){
        case 1:
          if (imageStr == 'type1'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 2:
          if (imageStr == 'type2'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 3:
          if (imageStr == 'type3'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        default:
          if (imageStr == 'type4'){
            return Image.asset('assets/selectedSquare.png');
          }
      }
    }
    return Image.asset('assets/unselectedSquare.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(R.string.facePlateType,style: Theme.of(context).textTheme.body1),
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
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSquare(1),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Image.asset('assets/facePlateType1.png'),
                            )
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type1')
                    ),
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSquare(2),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Image.asset('assets/facePlateType2.png'),
                            )
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type2')
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSquare(3),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Image.asset('assets/facePlateType3.png'),
                            )
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type3')
                    ),
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSquare(4),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Image.asset('assets/facePlateType4.png'),
                            )
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type4')
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}