
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repairservices/res/R.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }

}
class ProfileState extends State<Profile> {
  String activeB2bUnit = '';
  Widget _buttonSelectB2bInit(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: GestureDetector(
          child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              child: Center(
                child: Text(
                  R.string.selectB2BUnit,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white
                  ),
                ),
              )
          ),
          onTap: () {
            _showSelectB2bUnit(context);
          },
        )

    );
  }

  void _activeB2bUnit() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint(prefs.getString('b2bUnitName'));
    setState(() {
      activeB2bUnit = prefs.getString('b2bUnitName');
    });
  }
  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      setState(() {});
    });
  }

  _showSelectB2bUnit(BuildContext context) {
    showDemoActionSheet(
        context: context,
        child: CupertinoActionSheet(
            title: Text(R.string.selectB2BUnit),
            actions: _actionItems(context)
        )
    );
  }
  List<CupertinoActionSheetAction> _actionItems(BuildContext context) {
    List<CupertinoActionSheetAction> items = [];
    for (B2bUnit b2bUnit in User.current.b2BUnits) {
      if (b2bUnit.id != "schueco_0001_KU" && b2bUnit.name != "Schüco International KG") {
        final cupertinoAction = CupertinoActionSheetAction (
          child: new Row(
            children: <Widget>[
              Image.asset('assets/unselectedSquare.png'),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: Text(
                      b2bUnit.name + " " + b2bUnit.seePrices.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                      overflow: TextOverflow.clip
                  ),
                ),
              ),
            ],
          ),
          onPressed: () async {
            B2bUnit.current = b2bUnit;
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('seePrices', b2bUnit.seePrices);
            prefs.setBool('canBuy', b2bUnit.canBuy);
            prefs.setString("b2bUnitId", b2bUnit.id);
            prefs.setString("b2bUnitName", b2bUnit.name);
            activeB2bUnit = prefs.getString('b2bUnitName');
            debugPrint(prefs.getString("b2bUnitId") + ", CanSeePrice:" + prefs.getBool("seePrices").toString());
            Navigator.pop(context);
          },
        );
        items.add(cupertinoAction);
      }
    }
    return items;
  }
  @override
  initState(){
    super.initState();
    _activeB2bUnit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.userInfo,style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.name, style: Theme.of(context).textTheme.subtitle1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(User.current != null ? User.current.firstName + " " + User.current.lastName: '', style: Theme.of(context).textTheme.bodyText2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.country+':', style: Theme.of(context).textTheme.subtitle1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(User.current != null ? User.current.country : '', style: Theme.of(context).textTheme.bodyText2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.city+':', style: Theme.of(context).textTheme.subtitle1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(User.current != null ? User.current.city : '', style: Theme.of(context).textTheme.bodyText2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.street+':', style: Theme.of(context).textTheme.subtitle1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(User.current != null ? User.current.street : '', style: Theme.of(context).textTheme.bodyText2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.email+':', style: Theme.of(context).textTheme.subtitle1),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                  child: Text(User.current != null ? User.current.email : '', style: Theme.of(context).textTheme.bodyText2,maxLines: 2),
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.gender, style: Theme.of(context).textTheme.subtitle1),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                  child: Text(User.current != null ? User.current.gender : '', style: Theme.of(context).textTheme.bodyText2),
                )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                child: Text(R.string.activeB2BUnit, style: Theme.of(context).textTheme.subtitle1),
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16,top: 8, bottom: 8),
                    child: Text(activeB2bUnit, style: Theme.of(context).textTheme.bodyText2),
                  )
              )
            ],
          ),
          _buttonSelectB2bInit(context)
        ],
      ),
    );
  }

}
