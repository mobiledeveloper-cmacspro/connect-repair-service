import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';

class SlidingDirectionOpening extends StatelessWidget {
  final String imageStr;
  SlidingDirectionOpening(this.imageStr);

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
          title: Text(R.string.openingDirection,style: Theme.of(context).textTheme.body1),
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
                              padding: EdgeInsets.only(top: 8),
                              child: Text(R.string.right,style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,),
                            ),
                            Image.asset('assets/slidingDirectionOpening1.png'),
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
                              child: Text(R.string.left,style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,textAlign: TextAlign.center,),
                            ),
                            Image.asset('assets/slidingDirectionOpening2.png'),
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
                              child: Text(R.string.right,style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),),
                            ),
                            Image.asset('assets/slidingDirectionOpening3.png'),
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
                              child: Text(R.string.left,style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(38, 38, 38, 1.0)),maxLines: 2,),
                            ),
                            Image.asset('assets/slidingDirectionOpening4.png'),
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