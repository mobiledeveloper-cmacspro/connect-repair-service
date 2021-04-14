import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';

class SettingsArticleIdentificationV extends StatefulWidget {
  @override
  SettingsArticleIdentificationState createState() =>
      new SettingsArticleIdentificationState();
}

class SettingsArticleIdentificationState
    extends State<SettingsArticleIdentificationV> {
  bool _showTips;
  bool _gpsPhotos;
  bool _savePhotos;
  bool _showTutorial;
  //bool _selOpt;

  Future<void> _readValues() async {
//    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    _showTips = prefs.getBool('showTips') ?? false;
    _gpsPhotos = prefs.getBool('gpsPhotos') ?? true;
    _savePhotos = prefs.getBool('savePhotos') ?? false;
    _showTutorial = prefs.getBool('showTutorial') ?? false;
    this.setState(() {});
  }

  Future<void> _saveValue(bool value, String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    print('saved $value');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () async {
      await _readValues();
      this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.setting,
            style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: new Container(
          child: new Column(
//          crossAxisAlignment: CrossAxisAlignment.,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
            // new Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Container(
            //       margin: EdgeInsets.only(left: 16,top: 4),
            //         child: Text(
            //           R.string.showTipsEditing,
            //           style: Theme.of(context).textTheme.bodyText2,
            //         )
            //     ),
            //
            //     Container(
            //       margin: EdgeInsets.only(right: 16,top: 4),
            //       child: CupertinoSwitch(
            //         value: _showTips == null ? false : _showTips,
            //         activeColor: Theme.of(context).primaryColor,
            //         onChanged: (bool value) {
            //           setState(() {
            //             _showTips = value;
            //             this._saveValue(value, 'showTips');
            //           });
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Divider(),
            // new Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Container(
            //         margin: EdgeInsets.only(left: 16,top: 4),
            //         child: Text(
            //           R.string.gpsTagsPhotos,
            //           style: Theme.of(context).textTheme.bodyText2,
            //         )
            //     ),
            //
            //     Container(
            //       margin: EdgeInsets.only(right: 16,top: 4),
            //       child: CupertinoSwitch(
            //         value: _gpsPhotos == null ? true : _gpsPhotos,
            //         activeColor: Theme.of(context).primaryColor,
            //         onChanged: (bool value) {
            //           setState(() {
            //             _gpsPhotos = value;
            //             this._saveValue(value, 'gpsPhotos');
            //           });
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 16, top: 4),
                    child: Text(
                      R.string.savePhotosGallery,
                      style: Theme.of(context).textTheme.bodyText2,
                    )),
                Container(
                  margin: EdgeInsets.only(right: 16, top: 4),
                  child: CupertinoSwitch(
                    value: _savePhotos ?? false,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) async {
                      bool ok = value;
                      if (ok ?? false) {
                        if (Platform.isIOS) {
                          final granted = await Permission.photos.isGranted;
                          if (!granted) {
                            final response = await Permission.photos.request();
                            ok = response.isGranted;

                            if(!ok){
                              openAppSettings();
                              return;
                            }
                          }
                        }
                      } else {
                        ok = false;
                      }
                      await _saveValue(ok, 'savePhotos');
                      setState(() {
                        _savePhotos = ok;
                      });
                    },
                  ),
                )
              ],
            ),
            Divider(),
            // new Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Container(
            //         margin: EdgeInsets.only(left: 16,top: 4),
            //         child: Text(
            //           R.string.showTutorialsAtStart,
            //           style: Theme.of(context).textTheme.bodyText2,
            //         )
            //     ),
            //
            //     Container(
            //       margin: EdgeInsets.only(right: 16,top: 4),
            //       child: CupertinoSwitch(
            //         value: _showTutorial == null ? false : _showTutorial,
            //         activeColor: Theme.of(context).primaryColor,
            //         onChanged: (bool value) {
            //           setState(() {
            //             _showTutorial = value;
            //             this._saveValue(value, 'showTutorial');
            //           });
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Divider()
          ])),
    );
  }

  // Future<void> launchAllowOpt() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: Text(R.string.settingsPopupTitle),
  //         content: Text(R.string.settingsPopupDescription),
  //         actions: <Widget>[
  //           Column(
  //             children: [
  //               // CupertinoDialogAction(
  //               //   child: Text(R.string.settingsPhotosSelect),
  //               //   onPressed: () {
  //               //     Navigator.of(context).pop();
  //               //   },
  //               // ), TXDividerWidget(),
  //               CupertinoDialogAction(
  //                 child: Text(R.string.settingsAllowAccessPhotos),
  //                 onPressed: () {
  //                   _selOpt = true;
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //               TXDividerWidget(),
  //               CupertinoDialogAction(
  //                 child: Text(R.string.settingsDontAllowAccessPhotos),
  //                 onPressed: () {
  //                   _selOpt = false;
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
