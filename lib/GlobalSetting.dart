import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Setting'),style: Theme.of(context).textTheme.body1),
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
            onTap: (){
              debugPrint('Help');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(FlutterI18n.translate(context, 'Legal Information'),style: Theme.of(context).textTheme.body1),
            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
            trailing: Icon(CupertinoIcons.forward),
            onTap: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>LegalInformation()));
            }
          ),
          Divider(height: 1),
          ListTile(
              title: Text(FlutterI18n.translate(context, 'Signature'),style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>Signature()));
              }
          ),
          Divider(height: 1),
          ListTile(
              title: Text('Impressum',style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>Impressum()));
              }
          ),
          Divider(height: 1),
          ListTile(
              title: Text(FlutterI18n.translate(context, 'Language'),style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
              trailing: Icon(CupertinoIcons.forward),
              onTap: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>Language()));
              }
          ),
          Divider(height: 1)
        ],
      ),
    );
  }

}

class LegalInformation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Legal Information'),style: Theme.of(context).textTheme.body1),
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
              child: Text(FlutterI18n.translate(context, 'Legal Information Details'),style: Theme.of(context).textTheme.body1,textAlign: TextAlign.center,),
            ),
          )
        ],
      ),
    );
  }
}
class Signature extends StatefulWidget{
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
    if(value != null){
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
  initState(){
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
        title: Text(FlutterI18n.translate(context, 'Signature'),style: Theme.of(context).textTheme.body1),
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
            onTap: (){
              _save();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
              color: Color.fromRGBO(241, 241, 241, 1.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
                child: TextField(
                  textAlign: TextAlign.left,
                  minLines: 10,
                  maxLines: 10,
                  controller: emailText,
                  style: Theme.of(context).textTheme.body1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: FlutterI18n.translate(context, 'Enter the standard text here for the export by e-mail'),
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}

class Impressum extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text("Impressum",style: Theme.of(context).textTheme.body1),
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
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(FlutterI18n.translate(context, 'The Schüco service app is provided by:'),style: Theme.of(context).textTheme.display2),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Schüco International KG',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Karolinenstrasse 1-15',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('33609 Bielefeld',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Germany',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22,left: 16,right: 16),
            child: Text('Mr Andreas Engelhardt, CEO and Managing Partner, is responsible in accordance with § 55 of RStV '
                '(German Interstate Broadcasting Treaty).',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22,left: 16,right: 16),
            child: Text('Executive Management Board:',style: Theme.of(context).textTheme.display2),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Andreas Engelhardt, CEO and Managing',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Partner',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Philip Neuhaus, CFO',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Dr Walter Stadlbauer, COO and CTO',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22,left: 16,right: 16),
            child: Row(
              children: <Widget>[
                Text('Tel:',style: Theme.of(context).textTheme.body1),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('+49 (0)521 78 30',style: TextStyle(color: Colors.lightGreen[500],fontSize: 17)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Row(
              children: <Widget>[
                Text('Fax:',style: Theme.of(context).textTheme.body1),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('+49 (0)521 78 34 51',style: TextStyle(color: Colors.lightGreen[500],fontSize: 17)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22,left: 16,right: 16),
            child: Row(
              children: <Widget>[
                Text('E-mail:',style: Theme.of(context).textTheme.body1),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('info@schueco.com',style: TextStyle(color: Colors.lightGreen[500],fontSize: 17)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22,left: 16,right: 16),
            child: Text('www.schueco.com',style: TextStyle(color: Colors.lightGreen[500],fontSize: 17)),
          ),


          Padding(
            padding: EdgeInsets.only(top: 22,left: 16,right: 16),
            child: Text('VAT ID No.: DE 124001363',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text(FlutterI18n.translate(context, 'Registered office and court of record:'),style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text(FlutterI18n.translate(context, 'Limited partnership'),style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text('Bielefeld',style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,right: 16),
            child: Text(FlutterI18n.translate(context, 'Commercial register: HRA 8135'),style: Theme.of(context).textTheme.body1),
          ),
        ],
      )
    );
  }
}

class Language extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Language'),style: Theme.of(context).textTheme.body1),
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
          ListTile(
              title: Text('English',style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
              onTap: () async{
                await FlutterI18n.refresh(context, Locale('en'));
                Navigator.pop(context);
              }
          ),
          Divider(height: 1),
          ListTile(
              title: Text('Deutsch',style: Theme.of(context).textTheme.body1),
              contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
              onTap: () async {
                await FlutterI18n.refresh(context, Locale('de'));
                Navigator.pop(context);
              }
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

}