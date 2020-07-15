//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/data/dao/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/res/values/text/custom_localizations_delegate.dart';
import 'all_translations.dart';


class GlobalSettings extends StatelessWidget {
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
              title: Text(R.string.legalInformation,
                  style: Theme.of(context).textTheme.bodyText2),
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
              title: Text(R.string.signature,
                  style: Theme.of(context).textTheme.bodyText2),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Signature()));
              }),
          Divider(height: 1),
          ListTile(
              title: Text(R.string.imprint,
                  style: Theme.of(context).textTheme.bodyText2),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Impressum()));
              }),
          Divider(height: 1),
          ListTile(
              title: Text(R.string.language,
                  style: Theme.of(context).textTheme.bodyText2),
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
        title: Text(R.string.legalInformation,
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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 52),
            child: Center(
              child: Text(
                R.string.legalInformationDetails,
                style: Theme.of(context).textTheme.bodyText2,
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
        title: Text(R.string.signature,
            style: Theme.of(context).textTheme.bodyText2),
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
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: R.string.standardTextExportEmail,
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
          title: Text(R.string.imprint,
              style: Theme.of(context).textTheme.bodyText2),
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
                  R.string.shucoServiceAppProvidedBy,
                  style: Theme.of(context).textTheme.headline3),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                  R.string.schucoInternational,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  R.string.karolinenstrasse,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  R.string.bielefeld33609,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  R.string.germany,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(
                  R.string.mrAndreasEngelhardtCEOManagingPartnerResponsibleAccordanceWith +
                  R.string.germanInterstateBroadcastingTreaty+".",
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(
                  R.string.executiveManagementBoard,
                  style: Theme.of(context).textTheme.headline3),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                  R.string.andreasEngelhardtCEOAndManaging,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(R.string.partner,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(R.string.philipNeuhausCFO,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  R.string.drWalterStadlbauerCOOandCTO,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(R.string.tel,
                      style: Theme.of(context).textTheme.bodyText2),
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
                  Text(R.string.fax,
                      style: Theme.of(context).textTheme.bodyText2),
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
                  Text(R.string.eMail,
                      style: Theme.of(context).textTheme.bodyText2),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('info@schueco.com',
                        style: TextStyle(
                            color: Colors.lightGreen[500], fontSize: 17)),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text('www.schueco.com',
                  style:
                      TextStyle(color: Colors.lightGreen[500], fontSize: 17)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 16, right: 16),
              child: Text(
                  R.string.vatId,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  R.string.registeredOfficeCourtOfRecord,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(R.string.limitedPartnership,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(R.string.bielefeld,
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
              ),
              child: Text(
                  R.string.commercialRegister,
                  style: Theme.of(context).textTheme.bodyText2),
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
        title: Text(R.string.language,
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
        children: <Widget>[
          InkWell(
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(R.string.english,
                        style: Theme.of(context).textTheme.bodyText2),
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
              //await FlutterI18n.refresh(context, Locale('en'));
              //await _sharedPreferences.setLanguage('en');
              await allTranslations.setNewLanguage('en');
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
                    child: Text(R.string.deutsch,
                        style: Theme.of(context).textTheme.bodyText2),
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
              //await FlutterI18n.refresh(context, Locale('de'));
              //await _sharedPreferences.setLanguage('de');
              await allTranslations.setNewLanguage('de');
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
