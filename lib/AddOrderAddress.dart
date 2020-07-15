
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/res/R.dart';

class AddOrderAddress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddOrderAddressState();
  }

}
class AddOrderAddressState extends State<AddOrderAddress> {
  bool _loading = false;
  bool _canSave = false;
  Widget righBt = Image.asset('assets/checkGrey.png',height: 25);

  FocusNode companyNode,streetNode,numberNode,cityNode,postCodeNode,countryNode;

  final companyNameController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();
  final postCodeController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    companyNode = FocusNode();
    streetNode = FocusNode();
    numberNode = FocusNode();
    cityNode = FocusNode();
    postCodeNode = FocusNode();
    countryNode = FocusNode();
  }

  @override
  void dispose() {
    companyNode.dispose();
    streetNode.dispose();
    numberNode.dispose();
    cityNode.dispose();
    postCodeNode.dispose();
    countryNode.dispose();
    super.dispose();
  }

  void _changeFocus(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }
  _checkFields(){
    if (companyNameController.text != '' && streetController.text != '' && numberController.text != '' && cityController.text != '' &&
        postCodeController.text != '' && countryController.text != '') {
      _canSave = true;
      setState(() {
        righBt =  Image.asset('assets/checkGreen.png',height: 25);
      });
    }
    else {
      _canSave = false;
      setState(() {
        righBt =  Image.asset('assets/checkGrey.png',height: 25);
      });
    }
  }
  _showAlertDialog(BuildContext context, String title, String textButton) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context ) => CupertinoAlertDialog(
          title: new Text(title, style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            CupertinoDialogAction(
              child: new Text("OK"),
              isDestructiveAction: false,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }

  _addAddress() {
    if (_canSave){
      setState(() {
        _loading = true;
      });
      try {
        ISClientO.instance.saveAddress(companyNameController.text, streetController.text, numberController.text, cityController.text,
            postCodeController.text, countryController.text).then((saved){
              setState(() {
                _loading = false;
              });
           if (saved) {
             Navigator.pop(context);
             _showAlertDialog(context, R.string.addressAdded, "OK");

           }
        });
      }
      catch (e) {
        print('Exception details:\n $e');
        _showAlertDialog(context, e.toString(), "OK");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      opacity: 0.5,
      progressIndicator: CupertinoActivityIndicator(radius: 20),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(R.string.addAddress,style: Theme.of(context).textTheme.bodyText2),
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
                companyNode.unfocus();
                streetNode.unfocus();
                numberNode.unfocus();
                cityNode.unfocus();
                postCodeNode.unfocus();
                countryNode.unfocus();
                _addAddress();
              },
              child: righBt,
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: new TextField(
                focusNode: companyNode,
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                controller: companyNameController,
                textInputAction: TextInputAction.next,
                onChanged: (_) => _checkFields(),
                onSubmitted: (next){
                  _changeFocus(context, companyNode, streetNode);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: R.string.companyName,
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
                ),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: new TextField(
                focusNode: streetNode,
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                controller: streetController,
                textInputAction: TextInputAction.next,
                onChanged: (_) => _checkFields(),
                onSubmitted: (next){
                  _changeFocus(context, streetNode, numberNode);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: R.string.street,
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
                ),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: new TextField(
                focusNode: numberNode,
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                controller: numberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: (_) => _checkFields(),
                onSubmitted: (next){
                  _changeFocus(context, numberNode, cityNode);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: R.string.number,
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
                ),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: new TextField(
                focusNode: cityNode,
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                controller: cityController,
                textInputAction: TextInputAction.next,
                onChanged: (_) => _checkFields(),
                onSubmitted: (next){
                  _changeFocus(context, cityNode, postCodeNode);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: R.string.city,
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
                ),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: new TextField(
                focusNode: postCodeNode,
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                controller: postCodeController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: (_) => _checkFields(),
                onSubmitted: (next){
                  _changeFocus(context, postCodeNode, countryNode);
                },
                onEditingComplete: () => _checkFields(),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: R.string.postcode,
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
                ),
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: new TextField(
                focusNode: countryNode,
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                controller: countryController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: R.string.country,
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
                ),
                onChanged: (_) => _checkFields(),
              ),
            ),
            Divider(height: 1),
          ],
        ),
      ),
    );
  }

}