import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';

class DoorLockMultipointLocking extends StatefulWidget {
  final String imageStr;
  DoorLockMultipointLocking(this.imageStr);
  @override
  State<StatefulWidget> createState() {
    return DoorLockMultipointLockingState(this.imageStr);
  }

}
class DoorLockMultipointLockingState extends State<DoorLockMultipointLocking>{
  final String imageStr;
  bool standard = false;
  DoorLockMultipointLockingState(this.imageStr);

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
        case 5:
          if (imageStr == 'type5'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 6:
          if (imageStr == 'type6'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 7:
          if (imageStr == 'type7'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 8:
          if (imageStr == 'type8'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 9:
          if (imageStr == 'type9'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        case 10:
          if (imageStr == 'type10'){
            return Image.asset('assets/selectedSquare.png');
          }
          break;
        default:
          if (imageStr == 'type11'){
            return Image.asset('assets/selectedSquare.png');
          }
      }
    }
    return Image.asset('assets/unselectedSquare.png');
  }

  List<Widget> _getImagesForSelectedFilter() {
    List<Widget> options;
    if (!standard) {
      options = [
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
                        child: Image.asset('assets/multipointLocking1.png'),
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
                        child: Image.asset('assets/multipointLocking2.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type2')
              ),
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
                        child: Image.asset('assets/multipointLocking3.png'),
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
                        child: Image.asset('assets/multipointLocking4.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type4')
              ),
            ],
          ),
        ),
      ];
    }
    else {
      options = [
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
                      _getSquare(5),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking5.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type5')
              ),
              InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getSquare(6),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking6.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type6')
              ),
              InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getSquare(7),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking7.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type7')
              ),
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
                      _getSquare(8),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking8.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type8')
              ),
              InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getSquare(9),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking9.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type9')
              ),
              InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getSquare(10),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking10.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type10')
              ),
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
                      _getSquare(11),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset('assets/multipointLocking11.png'),
                      )
                    ],
                  ),
                  onTap: () => Navigator.pop(context,'type11')
              ),
            ],
          ),
        ),
      ];
    }
    return options;
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((_) {
      setState(() {});
    });
  }
      void _onActionSheetPress(BuildContext context)  {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: new Text(R.string.emergencyExists, style: Theme.of(context).textTheme.display1),
            onPressed: (){
              Navigator.pop(context);
              setState(() {
                standard = false;
              });
            },
          ),
          CupertinoActionSheetAction(
            child: new Text(R.string.standardDoors, style: Theme.of(context).textTheme.display1),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                standard = true;
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.multiPointLocking,style: Theme.of(context).textTheme.body1),
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
            InkWell(
              child: Container(
                color: Color.fromRGBO(249, 249, 249, 1),
                height: 44,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(standard ? R.string.standardDoors : R.string.emergencyExists,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 35),
                    )
                  ],
                ),
              ),
              onTap: () => _onActionSheetPress(context)
            ),
            Divider(height: 1),
            Expanded(
             child: ListView(
               children: _getImagesForSelectedFilter(),
             ),
            )
          ],
        )
      ),
    );
  }

}