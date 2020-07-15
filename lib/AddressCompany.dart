import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/models/Company.dart';
import 'package:repairservices/res/R.dart';

class AddressCompanyV extends StatefulWidget {
  final Address address;

  AddressCompanyV(this.address);

  @override
//  AddressCompanyState createSate() => new AddressCompanyState(this.address);
  AddressCompanyState createState() => new AddressCompanyState(this.address);
}

class AddressCompanyState extends State<AddressCompanyV> {
  Address address;
  FocusNode streetNode,numberNode,extraAddressNode,postCodeNode,locationNode;

  AddressCompanyState(this.address);

  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final extraAddressController = TextEditingController();
  final postCodeController = TextEditingController();
  final locationController = TextEditingController();
  double lat,lng;

  @override
  void initState() {
    super.initState();
    streetNode = FocusNode();
    numberNode = FocusNode();
    extraAddressNode = FocusNode();
    postCodeNode = FocusNode();
    locationNode = FocusNode();
    streetController.text = address.street;
    numberController.text = address.houseNumber != null ? address.houseNumber.toString() : "";
    extraAddressController.text = address.extraAddressLine;
    postCodeController.text = address.postCode != null ? address.postCode.toString() : "";
    if(address.lat != null) {
      locationController.text = address.lat.toString() + ", " + address.lng.toString();
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    streetNode.dispose();
    numberNode.dispose();
    extraAddressNode.dispose();
    postCodeNode.dispose();
    locationNode.dispose();
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
        title: Text(R.string.address,style: Theme.of(context).textTheme.bodyText2),
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
              streetNode.unfocus();
              numberNode.unfocus();
              extraAddressNode.unfocus();
              postCodeNode.unfocus();
              locationNode.unfocus();
              address.street = streetController.text;
              if (numberController.text != "") {
                address.houseNumber = int.parse(numberController.text);
              }
              address.extraAddressLine = extraAddressController.text;
              if (postCodeController.text != "") {
                address.postCode = int.parse(postCodeController.text);
              }
              address.lat = lat;
              address.lng = lng;
              address.location = locationController.text;
              Navigator.pop(context,address);
            },
            child: Image.asset(
              'assets/checkGreen.png',
              height: 25,
            ),

          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          Container(
            height: 48,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: GestureDetector(
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          R.string.useCurrentLocation,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ),
                      )
                  ),
                  onTap: (){
                    debugPrint('Location');
                  },
                )
            )
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
              onSubmitted: (next){
                _changeFocus(context, numberNode, extraAddressNode);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: R.string.houseNumber,
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
            child: new TextField(
              focusNode: extraAddressNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: extraAddressController,
              textInputAction: TextInputAction.next,
              onSubmitted: (next){
                _changeFocus(context, extraAddressNode, postCodeNode);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: R.string.extraAddressLine,
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
              onSubmitted: (next){
                _changeFocus(context, postCodeNode, locationNode);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'PostCode',
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
            child: new TextField(
              focusNode: locationNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: locationController,
              keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: R.string.location,
                  hintStyle: TextStyle(color: Colors.grey,fontSize: 17)
              ),
            ),
          ),
          Divider(height: 1),
        ],
      )
    );
  }

}