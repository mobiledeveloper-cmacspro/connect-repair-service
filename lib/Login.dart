import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:repairservices/FAQ.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/models/User.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:repairservices/res/R.dart';

class LoginV extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginV> {
  bool _saving = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode usernameNode, passwordNode;

  List<CupertinoActionSheetAction> _actionItems(BuildContext context) {
    List<CupertinoActionSheetAction> items = [];
    for (B2bUnit b2bUnit in User.current.b2BUnits) {
      if (b2bUnit.id != "schueco_0001_KU" &&
          b2bUnit.name != "Schüco International KG") {
        final cupertinoAction = CupertinoActionSheetAction(
          child: new Row(
            children: <Widget>[
              Image.asset('assets/unselectedSquare.png'),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(b2bUnit.name,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 17),
                      overflow: TextOverflow.clip),
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
            debugPrint(prefs.getString("b2bUnitId") +
                ", CanSeePrice:" +
                prefs.getBool("seePrices").toString());
            Navigator.pop(context);
          },
        );
        items.add(cupertinoAction);
      }
    }
    return items;
  }

  _showDialog(BuildContext context, String title, String msg) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: msg.isNotEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Text(msg, style: TextStyle(fontSize: 17)),
                    )
                  : Container(),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(R.string.ok),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      Navigator.pop(context);
    });
  }

  _showSelectB2bUnit(BuildContext context) {
    showDemoActionSheet(
        context: context,
        child: SingleChildScrollView(
          child: CupertinoActionSheet(
              title: Text(R.string.selectB2BUnit),
              actions: _actionItems(context)),
        ));
  }

  Future _login(BuildContext context) async {
    debugPrint('Login function');

    if (usernameController.text == "" || passwordController.text == "") {
      _showDialog(context, R.string.missingData, '');
    } else {
      setState(() {
        _saving = true;
      });
      try {
        final logged = await ISClientO.instance
            .loginUser(usernameController.text.trim(), passwordController.text);
        if (logged is int && logged == 200) {
          final bool userUpdated =
              await ISClientO.instance.getUserInformation();
          if (userUpdated) {
            setState(() {
              _saving = false;
            });
            _showSelectB2bUnit(context);
          }
        }
      } catch (e) {
        setState(() {
          _saving = false;
        });
        print('login error:\n $e');
        final m = e.message;
        if (m.contains("Failed host lookup"))
          _showDialog(context, 'Repair Service',
              R.string.connectionProblems);
        else if (e.response != null && (e.response.statusCode == 400 || e.response.statusCode == 401))
          _showDialog(context, 'Repair Service',
              R.string.badCredentials);
        else
          _showDialog(context, 'Repair Service',
              R.string.connectionProblems);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    usernameNode = FocusNode();
    passwordNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    usernameNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  void _changeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    Widget loginBt = Padding(
        padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
        child: GestureDetector(
          child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color.fromRGBO(68, 68, 68, 1.0),
              ),
              child: Center(
                child: Text(
                  R.string.login,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              )),
          onTap: () {
            _login(context);
          },
        ));

    return ModalProgressHUD(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Colors.white,
            actionsIconTheme:
                IconThemeData(color: Theme.of(context).primaryColor),
            title:
                Text(R.string.login,
                style: Theme.of(context).textTheme.bodyText2),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Theme.of(context).primaryColor,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(138, 139, 141, 1.0),
                          width: 1.0)),
                  margin: EdgeInsets.only(top: 32, left: 16, right: 16),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: usernameController,
                      focusNode: usernameNode,
                      decoration: InputDecoration(
                          hintText: R.string.emailUsername,
                          border: InputBorder.none),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                      onSubmitted: (next) {
                        _changeFocus(context, usernameNode, passwordNode);
                      },
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(138, 139, 141, 1.0),
                          width: 1.0)),
                  margin: EdgeInsets.only(top: 32, left: 16, right: 16),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordNode,
                      textInputAction: TextInputAction.go,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: R.string.password,
                          border: InputBorder.none),
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                      onSubmitted: (go) {
                        passwordNode.unfocus();
                        _login(context);
                      },
                    ),
                  )),
              loginBt,
              Row(
                children: <Widget>[
                  CupertinoButton(
                    child: Text(
                      R.string.forgotPassword,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                        await _launchURL();
                    },
                  ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Color.fromRGBO(191, 191, 191, 1.0),
                                width: 1))),
                  ),
                  CupertinoButton(
                    child: Text(
                      R.string.firstTimeRegistration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => FAQ()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )),
      inAsyncCall: _saving,
      opacity: 0.5,
      progressIndicator: CupertinoActivityIndicator(radius: 20),
    );
  }

  _launchURL() async {
    const url = 'https://www.schueco.com/web2/us/fabricators/password_forgotten';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
