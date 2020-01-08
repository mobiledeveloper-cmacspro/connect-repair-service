import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/AddOrderAddress.dart';
import 'package:repairservices/ChekoutOrder.dart';
//import 'package:repairservices/generated/i18n.dart';
import 'package:repairservices/models/Company.dart';

class ShippingAddress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShippingAddressState();
  }
}

class ShippingAddressState extends State<ShippingAddress> {
  Address selectedAddress;

  List<Address> addressArr = [
    Address.forOrder('Mercedes Benz', 'Gitschiner Str.', 100, 'Berlin', 10969, 'Deuthland'),
    Address.forOrder('BMW', 'Schleswiger Ufer', 1987, 'Berlin', 10555, 'Deuthland')
  ];

  List<CupertinoActionSheetAction> _actionItems(BuildContext context) {
    List<CupertinoActionSheetAction> items = [];
    for (Address address in addressArr) {
        final cupertinoAction = CupertinoActionSheetAction (
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: Text(
                      '${address.companyName}, ${address.street} ${address.houseNumber}, ${address.postCode} ${address.city}, ${address.country}',
                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 17),
                      overflow: TextOverflow.clip
                  ),
                ),
              ),
            ],
          ),
          onPressed: () async {
            Navigator.pop(context);
            setState(() {
              selectedAddress = address;
            });
          },
        );
        items.add(cupertinoAction);
    }
    return items;
  }

  _showAlertDialog(BuildContext context, String title, String textButton) {
    debugPrint('Showing Alert with title: $title');
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context ) => CupertinoAlertDialog(
          title: new Text(title, style: Theme.of(context).textTheme.body1),
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
  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  _showSelectAddress(BuildContext context) {
    showDemoActionSheet(
        context: context,
        child: CupertinoActionSheet(
            title: Text(FlutterI18n.translate(context, 'Select B2B Unit')),
            actions: _actionItems(context)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(FlutterI18n.translate(context, 'Shipping address'),style: Theme.of(context).textTheme.body1),
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
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(FlutterI18n.translate(context, 'Select your shipping address'),style: Theme.of(context).textTheme.subhead)
              )
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(top: 34, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                            selectedAddress != null ? '${selectedAddress.companyName}, ${selectedAddress.street} '
                                '${selectedAddress.houseNumber}, ${selectedAddress.postCode} ${selectedAddress.city}, ${selectedAddress.country}' :
                            FlutterI18n.translate(context, 'Select your address'),
                            style: Theme.of(context).textTheme.body1, maxLines: 2, textAlign: TextAlign.center),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Image.asset('assets/upCarrotGreen.png')
                    )
                  ],
                ),
              ),
              onTap: (){
                _showSelectAddress(context);
              },
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'Add new delivery address'),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ),
                      )
                  ),
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => AddOrderAddress()));
                  },
                )
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'Go to chekout page'),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ),
                      )
                  ),
                  onTap: (){
                    if (selectedAddress != null) {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => CheckoutOrder(this.selectedAddress)));
                    }
                    else {
                      _showAlertDialog(context, FlutterI18n.translate(context, 'Select the shipping address first'), 'OK');
                    }
                  },
                )
            )
          ],
        ),
    );
  }

}
