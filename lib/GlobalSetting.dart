//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/data/dao/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Setting'),
            style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          InkWell(
            child: Image.asset(
              'assets/questionMarkGreen.png',
              height: 25,
            ),
            onTap: () {
              debugPrint('Help');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
              title: Text(FlutterI18n.translate(context, 'Legal Information'),
                  style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => LegalInformation()));
              }),
          Divider(height: 1),
          ListTile(
              title: Text(FlutterI18n.translate(context, 'Signature'),
                  style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Signature()));
              }),
          Divider(height: 1),
          ListTile(
              title: Text(FlutterI18n.translate(context, 'Imprint'),
                  style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Impressum()));
              }),
          Divider(height: 1),
          ListTile(
              title: Text(FlutterI18n.translate(context, 'Language'),
                  style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Language()));
              }),
          Divider(height: 1)
        ],
      ),
    );
  }
}

class LegalInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Legal Information'),
            style: Theme.of(context).textTheme.body1),
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
          Padding(
            padding: EdgeInsets.only(top: 52),
            child: Center(
              child: Text(
                FlutterI18n.translate(context, 'Legal Information Details'),
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Signature extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

class SignatureState extends State<Signature> {
  final emailText = TextEditingController();

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'standard_text_email';
    final value = prefs.getString(key) ?? '';
    if (value != null) {
      setState(() {
        emailText.text = value;
      });
    }
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'standard_text_email';
    prefs.setString(key, emailText.text);
    Navigator.pop(context);
  }

  @override
  initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Signature'),
            style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          InkWell(
            child: Image.asset(
              'assets/checkGreen.png',
              height: 25,
            ),
            onTap: () {
              _save();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Color.fromRGBO(241, 241, 241, 1.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: TextField(
                  textAlign: TextAlign.left,
                  minLines: 10,
                  maxLines: 10,
                  controller: emailText,
                  style: Theme.of(context).textTheme.body1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: FlutterI18n.translate(context,
                          'Enter the standard text here for the export by e-mail'),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
              )),
        ],
      ),
    );
  }
}

class Impressum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(FlutterI18n.translate(context, 'Imprint'),
              style: Theme.of(context).textTheme.body1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(
                      context, 'The Schüco service app is provided by:'),
                  style: Theme.of(context).textTheme.display2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(context, 'Schüco International KG'),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(context, "Karolinenstrasse 1-15"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(FlutterI18n.translate(context, "33609 Bielefeld"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(FlutterI18n.translate(context, "Germany"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(context,
                          "Mr Andreas Engelhardt, CEO and Managing Partner, is responsible in accordance with § 55 of RStV ") +
                      FlutterI18n.translate(
                          context, "(German Interstate Broadcasting Treaty)."),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(context, "Executive Management Board:"),
                  style: Theme.of(context).textTheme.display2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(
                      context, "Andreas Engelhardt, CEO and Managing"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(FlutterI18n.translate(context, "Partner"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(FlutterI18n.translate(context, "Philip Neuhaus, CFO"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(
                      context, "Dr Walter Stadlbauer, COO and CTO"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(FlutterI18n.translate(context, "Tel:"),
                      style: Theme.of(context).textTheme.body1),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('+49 (0)521 78 30',
                        style: TextStyle(
                            color: Colors.lightGreen[500], fontSize: 17)),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(FlutterI18n.translate(context, "Fax:"),
                      style: Theme.of(context).textTheme.body1),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('+49 (0)521 78 34 51',
                        style: TextStyle(
                            color: Colors.lightGreen[500], fontSize: 17)),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(FlutterI18n.translate(context, "E-mail:"),
                      style: Theme.of(context).textTheme.body1),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                        FlutterI18n.translate(context, "info@schueco.com"),
                        style: TextStyle(
                            color: Colors.lightGreen[500], fontSize: 17)),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(FlutterI18n.translate(context, "www.schueco.com"),
                  style:
                      TextStyle(color: Colors.lightGreen[500], fontSize: 17)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(context, "VAT ID No.: DE 124001363"),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  FlutterI18n.translate(
                      context, 'Registered office and court of record:'),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(FlutterI18n.translate(context, 'Limited partnership'),
                  style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child:
                  Text(FlutterI18n.translate(context, "Bielefeld"), style: Theme.of(context).textTheme.body1),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
              ),
              child: Text(
                  FlutterI18n.translate(
                      context, 'Commercial register: HRA 8135'),
                  style: Theme.of(context).textTheme.body1),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }
}

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  final _sharedPreferences = SharedPreferencesManager();
  String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = "";
    _getLocate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Language'),
            style: Theme.of(context).textTheme.body1),
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
          InkWell(
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(FlutterI18n.translate(context, "English"),
                        style: Theme.of(context).textTheme.body1),
                  ),
                  _currentLanguage == 'en'
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : Container()
                ],
              ),
            ),
            onTap: () async {
              await FlutterI18n.refresh(context, Locale('en'));
              await _sharedPreferences.setLanguage('en');
              Navigator.pop(context);
            },
          ),
          Divider(height: 1),
          InkWell(
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(FlutterI18n.translate(context, "Deutsch"),
                        style: Theme.of(context).textTheme.body1),
                  ),
                  _currentLanguage == 'de'
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : Container()
                ],
              ),
            ),
            onTap: () async {
              await FlutterI18n.refresh(context, Locale('de'));
              await _sharedPreferences.setLanguage('de');
              Navigator.pop(context);
            },
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  _getLocate() async {
    String res = await _sharedPreferences.getLanguage();
    setState(() {
      _currentLanguage = res;
    });
  }
}
