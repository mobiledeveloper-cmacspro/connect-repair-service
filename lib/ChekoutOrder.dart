import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/NetworkImageSSL.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/Company.dart';
import 'package:repairservices/models/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutOrder extends StatefulWidget {
  final Address shippingAddress;
  CheckoutOrder(this.shippingAddress);

  @override
  State<StatefulWidget> createState() {
    return CheckoutOrderState(this.shippingAddress);
  }

}
class CheckoutOrderState extends State<CheckoutOrder> {
  bool loggued = false;
  bool _loading = false;
  bool canSeePrice = false;
  bool canBuy = false;
  bool expressDelivery = false;
  Address shippingAddress;
  CheckoutOrderState(this.shippingAddress);
  List<Product> productList;
  DatabaseHelper helper = DatabaseHelper.instance;
  String baseUrl;

  _readAllProducts() async {
    this.productList = await helper.queryAllProducts(true);
    debugPrint(productList.length.toString());
    this.setState((){});
    for (int i = 0; i < productList.length; i++) {
      _getArticleDetails(productList[i]).then((product){
        int id = productList[i].id;
        productList[i] = product;
        productList[i].id = id;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      setState(() {
        _updateBaseUrl();
      });
    });
  }

  _updateBaseUrl() async {
    final baseUrl = await ISClientO.instance.baseUrl;
    this.baseUrl = baseUrl;
    final prefs = await SharedPreferences.getInstance();
    final seePrices = prefs.getBool("seePrices");
    final canBuy = prefs.getBool("canBuy");
    if (seePrices != null) {
      this.canSeePrice = seePrices;
      this.canBuy = canBuy;
    }
    _readAllProducts();
    setState(() {});
  }

  Future<Product> _getArticleDetails(Product prod) async {
    try {
      Product product = await ISClientO.instance.getProductDetails(prod.number.value,int.parse(prod.quantity.value));
      if (product != null) {
        return product;
      }
    }
    catch (e) {
      print('Exception details:\n $e');
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context ) => CupertinoAlertDialog(
            title: const Text("Error"),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
              child: Text(e.toString(),style: TextStyle(fontSize: 17)),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("OK"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
      );
    }
    return prod;
  }

  Widget _priceDetails(BuildContext context, int pos) {
    if (canSeePrice && productList[pos].totalAmount != null && productList[pos].totalAmount.value != "" && productList[pos].currency != null && productList[pos].currency.value != "") {
      return Container(
        margin: EdgeInsets.only(right: 16),
        width: 120,
        child: Row(
          children: <Widget>[
            Text(FlutterI18n.translate(context, 'Price: '), style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(productList[pos].totalAmount.value + " " + productList[pos].currency.value,style: TextStyle(fontSize: 14)),
            )
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }

  _showAlertDialog(BuildContext context, String title, String textButton, Function function) {
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
                function();
              },
            )
          ],
        )
    );
  }

  _removeProduct(int id){
    helper.deleteProduct(id,true).then((_) {
      _readAllProducts();
    });
  }

  Color _getColorByAvability(String avability) {
    switch (avability) {
      case "1":
        return Color.fromRGBO(28, 105, 51, 1);
      case "2":
        return Colors.yellow;
      case "3":
        return Colors.redAccent;
      case "4":
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  _saveOrder() {
    if(productList.length>0){
      setState(() {
        _loading = true;
      });
      try {
        ISClientO.instance.saveOrder(expressDelivery, 'test', shippingAddress, productList).then((saved){
          if(saved){
            _showAlertDialog(context, FlutterI18n.translate(context, 'Order sended'), "OK",(){
              for(Product product in productList) {
                _removeProduct(product.id);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            });
          }
        });
      }
      catch (e) {
        print('Exception details:\n $e');
        _showAlertDialog(context, e.toString(), "OK", null);
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
          title: Text(FlutterI18n.translate(context, 'Check Order'),style: Theme.of(context).textTheme.body1),
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
              padding: EdgeInsets.only(top: 20,bottom: 16),
              child: Center(
                child: Text(FlutterI18n.translate(context, 'Shipping address'), style: Theme.of(context).textTheme.subhead)
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 16,right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        '${shippingAddress.companyName}, ${shippingAddress.street} ${shippingAddress.houseNumber}, '
                            '${shippingAddress.postCode} ${shippingAddress.city}, ${shippingAddress.country}',
                        style: Theme.of(context).textTheme.body1, maxLines: 2, textAlign: TextAlign.center
                      )
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      child: Icon(CupertinoIcons.pen,color: Theme.of(context).primaryColor,size:30),
                      onTap: () => Navigator.pop(context),
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Center(
                      child: Text(FlutterI18n.translate(context, 'Express deilvery'),style: Theme.of(context).textTheme.body1),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.80,
                    child: CupertinoSwitch(
                      onChanged: (active){
                        setState(() {
                          expressDelivery = active;
                        });
                        debugPrint('Express delivery $active');
                      },
                      value: expressDelivery,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(FlutterI18n.translate(context, 'Products'),style: Theme.of(context).textTheme.subhead),
                  Text(FlutterI18n.translate(context, 'Click here to edit the cart'),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14))
                ],
              ),
            ),
            Divider(height: 8,color: Colors.black38),
            Expanded(
              child: new ListView.builder(
                itemCount: productList == null ? 0 : productList.length,
                itemBuilder: (BuildContext context, int index){
                  return new GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 50,
                            color: Color.fromRGBO(249, 249, 249, 1.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 16),
                                  height: 29,
                                  width: 36,
                                  child: baseUrl == null ?
                                  Image.asset('assets/productImage.png') :
                                  Image(image: NetworkImageSSL(baseUrl + productList[index].url.value)),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 10),
                                        child: Text(
                                            productList[index].shortText.value,
                                            style:  Theme.of(context).textTheme.body1
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 4),
                                        child: Text(
                                            productList[index].number.value,
                                            style: Theme.of(context).textTheme.body2
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                            height: 50,
                            color: Color.fromRGBO(249, 249, 249, 1.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  height: 35,
                                  margin: EdgeInsets.only(left: 68),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(FlutterI18n.translate(context, 'Quantity: ')),
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            height: 22,
                                            width: 52,
                                            child: Center(
                                                child: Text(productList[index].quantity != null ? productList[index].quantity.value : "1")
                                            ),
                                          )
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  children: <Widget>[
                                    _priceDetails(context, index),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.only(right: 16,top: 8),
                                            child: Text(FlutterI18n.translate(context, 'avability'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: _getColorByAvability(productList[index].avability == null ? "1" : productList[index].avability.value ),
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        )
                                    )
                                  ],
                                )
                              ],
                            )
                        ),
                        Divider(
                          height: 1,
                          color: Color.fromRGBO(191, 191, 191, 1.0),
                        )
                      ],
                    ),
                    onTap: () {
                      debugPrint('tap index: $index');
//                    _getArticleDetails(productList[index].number.value);
                    },
                  );
                },
                shrinkWrap: true,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 16,right: 16, bottom: 30),
                child: GestureDetector(
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'Check Order'),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white
                          ),
                        ),
                      )
                  ),
                  onTap: (){

                  },
                )
            )
          ],
        ),
      ),
    );
  }

}