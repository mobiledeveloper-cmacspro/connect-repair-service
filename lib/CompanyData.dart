import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/models/Company.dart';
import 'AddressCompany.dart';
import 'package:repairservices/res/R.dart';


class CompanyDataV extends StatefulWidget {
  final Company company;

  CompanyDataV(this.company);

  @override
  CompanyDataState createState() => new CompanyDataState(this.company);

}

class CompanyDataState extends State<CompanyDataV> {
  Company company;

  FocusNode nameNode,informationNode,phoneNode,emailNode,faxNode,websiteNode;

  CompanyDataState(this.company);
  final nameController = TextEditingController();
  final aditionalInformationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final faxController = TextEditingController();
  final websiteController = TextEditingController();

  void showAlertDialog(BuildContext context, String title, String textButton, Function action) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context ) => CupertinoAlertDialog(
          title: new Text(title, style: Theme.of(context).textTheme.bodyText2,),
          actions: <Widget>[
            CupertinoDialogAction(
              child: new Text(textButton, style: TextStyle(color: Theme.of(context).primaryColor)),
              isDefaultAction: true,
              onPressed: action,
            ),
            CupertinoDialogAction(
              child: new Text(R.string.cancel),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    nameNode = FocusNode();
    informationNode = FocusNode();
    phoneNode = FocusNode();
    emailNode = FocusNode();
    faxNode = FocusNode();
    websiteNode = FocusNode();
    nameController.text = company.name;
    aditionalInformationController.text = company.additionalInf;
    phoneController.text = company.phone;
    emailController.text = company.email;
    faxController.text = company.fax;
    websiteController.text = company.website;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameNode.dispose();
    informationNode.dispose();
    phoneNode.dispose();
    emailNode.dispose();
    faxNode.dispose();
    websiteNode.dispose();
    super.dispose();
  }

  void _changeFocus(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.grey),
        title: Text(R.string.companyData,style: Theme.of(context).textTheme.bodyText2),
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
              nameNode.unfocus();
              informationNode.unfocus();
              phoneNode.unfocus();
              emailNode.unfocus();
              faxNode.unfocus();
              websiteNode.unfocus();
              if (nameController.text == "") {
                this.showAlertDialog(context, R.string.nameIsNecessaryForCompany, "OK", () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(nameNode);
                });
              }
              else {
                company.name = nameController.text;
                company.additionalInf = aditionalInformationController.text;
                company.phone = phoneController.text;
                company.email = emailController.text;
                company.fax = faxController.text;
                company.website = websiteController.text;
                Navigator.pop(context,company);
//                debugPrint(nameController.text);
              }
            },
            child: Image.asset(
              'assets/checkGreen.png',
              height: 25,
            ),

          ),
        ],
      ),
      body: new ListView(

//        itemExtent: 48,
        children: <Widget>[
          Container(
//            height: 48,
            padding: EdgeInsets.all(0),
            child: new Column(
//              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                      child: new Text(R.string.companyName,style: Theme.of(context).textTheme.bodyText2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 2,bottom: 0),
                      child: new Text('*',style: TextStyle(color: Colors.red,fontSize: 17)),
                    )
                  ],
                ),
                new Padding(
//                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                  child: new TextField(
                    focusNode: nameNode,
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (next){
                      _changeFocus(context, nameNode, informationNode);
                    },
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: R.string.newCompany,
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
//            height: 48,
            padding: EdgeInsets.all(0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                      child: new Text(R.string.aditionalInformation,style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                new Container(
//                  color: Colors.red,
                  margin: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                  child: new TextField(
                    focusNode: informationNode,
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    controller: aditionalInformationController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (next){
                      _changeFocus(context, informationNode, phoneNode);
                    },
                    decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: R.string.information,
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Container(
//              height: 48,
              padding: EdgeInsets.all(0),
              child: new Row(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                              child: new Text(R.string.address,style: Theme.of(context).textTheme.bodyText2),
                            ),
                          ],
                        ),
                        new Container(
                          margin: EdgeInsets.only(left: 16,right: 16,top: 4,bottom: 0),
                          child: Text(
                            R.string.address,
                            style: TextStyle(color: Colors.grey,fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
                  )
                ],
              )
          ),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) =>  AddressCompanyV(this.company.address)))
              .then((_){

              });
            },
          ),
          Divider(height: 1),
          Container(
//            height: 48,
            padding: EdgeInsets.all(0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                      child: new Text(R.string.phoneNumber,style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                new Container(
//                  color: Colors.red,
                  margin: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                  child: new TextField(
                    focusNode: phoneNode,
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (next){
                      _changeFocus(context, phoneNode, emailNode);
                    },
                    decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: '+1 555-555-5555',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
//            height: 48,
            padding: EdgeInsets.all(0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                      child: new Text(R.string.emailAddress,style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                new Container(
//                  color: Colors.red,
                  margin: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                  child: new TextField(
                    focusNode: emailNode,
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (next){
                      _changeFocus(context, emailNode, faxNode);
                    },
                    decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: 'company@address.com',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
//            height: 48,
            padding: EdgeInsets.all(0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                      child: new Text(R.string.fax,style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                new Container(
//                  color: Colors.red,
                  margin: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                  child: new TextField(
                    focusNode: faxNode,
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                    controller: faxController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (next){
                      _changeFocus(context, faxNode, websiteNode);
                    },
                    decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: '+1 555-555-5555',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
//            height: 48,
            padding: EdgeInsets.all(0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 16,bottom: 0),
                      child: new Text(R.string.website,style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                new Container(
//                  color: Colors.red,
                  margin: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 0),
                  child: new TextField(
                    focusNode: websiteNode,
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    controller: websiteController,
                    decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: 'https://www.website.com',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
        ],
      )
    );
  }
}