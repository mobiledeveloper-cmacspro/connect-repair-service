import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/models/Company.dart';

class CompanyEmailStandartTextV extends StatelessWidget {
  final Company comp;
  CompanyEmailStandartTextV(this.comp);

  final emailText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.grey),
          title: Text(FlutterI18n.translate(context, 'E-mail standart text'),style: Theme.of(context).textTheme.body1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                comp.textExportEmail = emailText.text;
                Navigator.pop(context,comp);
              },
              child: Image.asset('assets/checkGreen.png',
                height: 25,
              ),
            ),
          ],
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  controller: emailText..text = comp.textExportEmail,
                  style: Theme.of(context).textTheme.body1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: FlutterI18n.translate(context, 'My Company'),
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                  ),
                ),
              )
            ),
            Divider(height: 1)
          ]
        )
    );
  }
}