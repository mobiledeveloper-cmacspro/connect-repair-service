import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';

class DoorHingeSurfaceDetails extends StatefulWidget {
  final String imageStr;
  DoorHingeSurfaceDetails(this.imageStr);
  @override
  State<StatefulWidget> createState() {
    return DoorHingeSurfaceDetailsState(this.imageStr);
  }

}

class DoorHingeSurfaceDetailsState extends State<DoorHingeSurfaceDetails> {
  String imageStr;
  DoorHingeSurfaceDetailsState(this.imageStr);

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
        case 4:
          if (imageStr == 'type4'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        default:
          if (imageStr == 'type5'){
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
        title: Text(R.string.doorHingeDetails,style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context,imageStr);
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
                              padding: EdgeInsets.only(top: 8,bottom: 8),
                              child: Text(R.string.type + ' A',style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,),
                            ),
                            Image.asset('assets/surfaceType1.png'),
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
                              padding: EdgeInsets.only(top: 8,bottom: 8),
                              child: Text(R.string.type + ' B',style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,textAlign: TextAlign.center,),
                            ),
                            Image.asset('assets/surfaceType2.png'),
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type2')
                    ),
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSquare(3),
                            Padding(
                              padding: EdgeInsets.only(top: 8,bottom: 8),
                              child: Text(R.string.type + ' C',style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,textAlign: TextAlign.center,),
                            ),
                            Image.asset('assets/surfaceType3.png'),
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type3')
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
                            _getSquare(4),
                            Padding(
                              padding: EdgeInsets.only(top: 8,bottom: 8),
                              child: Text(R.string.type + ' D',style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),),
                            ),
                            Image.asset('assets/surfaceType4.png'),
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type4')
                    ),
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getSquare(5),
                            Padding(
                              padding: EdgeInsets.only(top: 8,bottom: 8),
                              child: Text(R.string.type + ' E',style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,),
                            ),
                            Image.asset('assets/surfaceType5.png'),
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type5')
                    ),
                    InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/whiteSurfaceDetailsIm.png'),
                          ],
                        ),
                        onTap: () => Navigator.pop(context,'type5')
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