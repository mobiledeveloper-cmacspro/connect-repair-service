import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:repairservices/res/R.dart';

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
              R.string.faqAnswer1,
              style: Theme.of(context).textTheme.bodyText2,
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
              R.string.faqAnswer2,
              style: Theme.of(context).textTheme.bodyText2,
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
              R.string.faqAnswer3,
              style: Theme.of(context).textTheme.bodyText2,
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
              R.string.faqAnswer4,
              style: Theme.of(context).textTheme.bodyText2,
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
              R.string.faqAnswer5,
              style: Theme.of(context).textTheme.bodyText2,
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
        title: Text(R.string.service,style: Theme.of(context).textTheme.bodyText2),
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
              R.string.sparePartsShop,
              style: TextStyle(fontSize: 22,color: Color.fromRGBO(38, 38, 38, 1.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: Text(
              R.string.firstTextFaq,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Text(
                    R.string.toTheSparePartsShop,
                    style: Theme.of(context).textTheme.headline4,
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
              R.string.secTextFaq,
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
                      R.string.faqQuestion1,
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
                        R.string.faqQuestion2,
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
                        R.string.faqQuestion3,
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
                        R.string.faqQuestion4,
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
                        R.string.faqQuestion5,
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
              R.string.weAreHereToHelp,
              style: TextStyle(fontSize: 22,color: Color.fromRGBO(38, 38, 38, 1.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16),
            child: Text(
              R.string.phoneNumberDE,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16,bottom: 4),
            child: Text(
              "+49 521 783400",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              R.string.serviceTimes,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              R.string.mondayThursday8am5pm,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8,left: 16,bottom: 4),
            child: Text(
              R.string.friday8am3pm,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16),
            child: Text(
              R.string.email,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4,left: 16,bottom: 4),
            child: Text(
              "technische-hotline@schueco.com",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Divider(height: 1),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

}