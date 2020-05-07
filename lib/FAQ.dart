import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FAQState();
  }
}

class FAQState extends State<FAQ> {
  bool text1 = false;
  bool text2 = false;
  bool text3 = false;
  bool text4 = false;
  bool text5 = false;

  Widget _getText(BuildContext context, int textNumber) {
    switch(textNumber){
      case 1:
        if(text1) {
          return Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              FlutterI18n.translate(context, 'faq_answer1'),
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            )
          );
        } else return Container();
        break;
      case 2:
        if(text2) {
          return Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              FlutterI18n.translate(context, 'faq_answer2'),
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            )
          );
        } else return Container();
        break;
      case 3:
        if(text3) {
          return Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              FlutterI18n.translate(context, 'faq_answer3'),
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            )
          );
        } else return Container();
        break;
      case 4:
        if(text4) {
          return Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              FlutterI18n.translate(context, 'faq_answer4'),
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            )
          );
        } else return Container();
        break;
      default:
        if(text5) {
          return Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              FlutterI18n.translate(context, 'faq_answer5'),
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            )
          );
        } else return Container();
        break;
    }
  }

  _launchURL() async {
    const url = 'https://ersatzteile.schueco.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Service'),style: Theme.of(context).textTheme.body1),
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
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'Spare Parts Shop'),
              style: TextStyle(fontSize: 22,color: Color.fromRGBO(38, 38, 38, 1.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              FlutterI18n.translate(context, 'firts_text_faq'),
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, 'to the Spare Parts Shop'),
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(CupertinoIcons.forward,color: Theme.of(context).primaryColor,size: 30,),
                  )
                ],
              ),
              onTap: (){
                _launchURL();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'sec_text_faq'),
              style: TextStyle(fontSize: 22,color: Color.fromRGBO(38, 38, 38, 1.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 16,right: 16),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      FlutterI18n.translate(context, 'faq_question1'),
                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: text1 ?
                    Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 40) :
                    Icon(Icons.keyboard_arrow_up,color: Theme.of(context).primaryColor,size: 40),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  text1 = !text1;
                });
              },
            )
          ),
          _getText(context,1),
          Padding(
              padding: EdgeInsets.only(left: 16,top: 16,right: 16),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        FlutterI18n.translate(context, 'faq_question2'),
                        style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: text2 ?
                      Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 40) :
                      Icon(Icons.keyboard_arrow_up,color: Theme.of(context).primaryColor,size: 40),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    text2 = !text2;
                  });
                },
              )
          ),
          _getText(context,2),
          Padding(
              padding: EdgeInsets.only(left: 16,top: 16,right: 16),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        FlutterI18n.translate(context, 'faq_question3'),
                        style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: text3 ?
                      Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 40) :
                      Icon(Icons.keyboard_arrow_up,color: Theme.of(context).primaryColor,size: 40),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    text3 = !text3;
                  });
                },
              )
          ),
          _getText(context,3),
          Padding(
              padding: EdgeInsets.only(left: 16,top: 16,right: 16),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        FlutterI18n.translate(context, 'faq_question4') ,
                        style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: text4 ?
                      Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 40) :
                      Icon(Icons.keyboard_arrow_up,color: Theme.of(context).primaryColor,size: 40),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    text4 = !text4;
                  });
                },
              )
          ),
          _getText(context,4),
          Padding(
              padding: EdgeInsets.only(left: 16,top: 16,right: 16),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        FlutterI18n.translate(context, 'faq_question5'),
                        style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: text5 ?
                      Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 40) :
                      Icon(Icons.keyboard_arrow_up,color: Theme.of(context).primaryColor,size: 40),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    text5 = !text5;
                  });
                },
              )
          ),
          _getText(context,5),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'Were here to help'),
              style: TextStyle(fontSize: 22,color: Color.fromRGBO(38, 38, 38, 1.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'Telephone Number (DE)'),
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16,bottom: 4),
            child: Text(
              "+49 521 783400",
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'Service times:'),
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'Monday - Thursday: 8 am - 5 pm'),
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,bottom: 4),
            child: Text(
              FlutterI18n.translate(context, 'Friday: 8 am - 3 pm'),
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              FlutterI18n.translate(context, 'Email'),
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16,bottom: 4),
            child: Text(
              "technische-hotline@schueco.com",
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Divider(height: 1),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

}