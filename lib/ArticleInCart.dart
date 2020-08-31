import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/ArticleList.dart';
import 'package:repairservices/Login.dart';
import 'package:repairservices/ShippingAddress.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/NetworkImageSSL.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_search_bar_widget.dart';
import 'package:repairservices/utils/custom_scrollbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Utils/ISClient.dart';
import 'database_helpers.dart';
import 'package:repairservices/res/R.dart';

class ArticleInCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticleInCartState();
  }
}

class ArticleInCartState extends State<ArticleInCart> {
  bool loggued = false;
  String baseUrl;
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Product> productList;
  bool canSeePrice = false;
  bool canBuy = false;
  int selected = 0;
  bool _loading = false;
  final _scrollController = ScrollController();

  final cardNameController = TextEditingController();

  _readAllProducts() async {
    this.productList = await helper.queryAllProducts(true);
    debugPrint("Products in Cart: " + productList.length.toString());
    this.setState((){});
    if(loggued && canSeePrice) {
      for (int i = 0; i < productList.length; i++) {
         _getArticleDetails(productList[i]).then((product){
           int id = productList[i].id;
           productList[i] = product;
           productList[i].id = id;
           setState(() {});
         });
      }
    }
  }

  _removeProduct(int id){
    helper.deleteProduct(id,true).then((_) {
      _readAllProducts();
    });
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

  _requestOrder(BuildContext context) {
    _showAlertRequestOrder(context);
  }

  _order(){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ShippingAddress()));
  }

  Widget _priceDetails(BuildContext context, int pos) {
    if (canSeePrice && productList[pos].totalAmount != null && productList[pos].totalAmount.value != "" && productList[pos].currency != null && productList[pos].currency.value != "") {
      return Container(
        margin: EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            Text(R.string.price, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
            Text(productList[pos].totalAmount.value + " " + productList[pos].currency.value,style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget _loginBt(BuildContext context) {
    if (loggued && canBuy) {
      return Padding(
          padding: EdgeInsets.only(left: 16,right: 16, bottom: 30),
          child: Container(
            child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              R.string.requestOrder,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white
                              ),
                            ),
                          )
                      ),
                      onTap: (){
                        _requestOrder(context);
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            R.string.order,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                    onTap: (){
                      _order();
                    },
                  )
                ],
            )
          )
      );
    }
    else if(loggued && !canBuy) {
      return Padding(
          padding: EdgeInsets.only(left: 16,right: 16, bottom: 30),
          child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(CupertinoIcons.info,color: Theme.of(context).primaryColor),
                        ),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8,left: 4,top: 16,bottom: 16),
                              child: Text(
                                R.string.selectedB2BUnitHasNoBuyer,
                                style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.w400),
                              ),
                            )
                        ),
                      ],
                    )
                  ),
                  GestureDetector(
                    child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            R.string.requestOrder,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                    onTap: (){
                      _requestOrder(context);
                    },
                  )
                ],
              )
          )
      );
    }
    else {
      return Padding(
          padding: EdgeInsets.only(left: 16,right: 16, bottom: 30),
          child: GestureDetector(
            child: Container(
                height: loggued?0:30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    R.string.login,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white
                    ),
                  ),
                )
            ),
            onTap: (){
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => LoginV()),
              ).then((value){
                ISClientO.instance.isTokenAvailable().then((bool loggued) {
                  this.loggued = loggued;
                  _updateBaseUrl();
                });
              });
            },
          )
      );
    }
  }

  _showAlertDialog(BuildContext context, String title, String textButton) {
    debugPrint('Showing Alert with title: $title');
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

  _sendRequestOrder(BuildContext context) {
    if(cardNameController.text == "" ){
      _showAlertDialog(context, "Please type the name for the card", 'OK');
    }
    else {
      setState(() {
        _loading = true;
      });
      try {
        debugPrint('calling create cart');
         ISClientO.instance.createCart(cardNameController.text, productList).then((bool created){
          if (created) {
            _showAlertDialog(context, "Cart sended", "OK");
          }
          else {
            _showAlertDialog(context, "The cart could not send", "OK");
          }
        });
      }
      catch (e) {
        print('Exception details:\n $e');
        _showAlertDialog(context, e.toString(), "OK");
      }
    }
  }
  
  _showAlertRequestOrder(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context ) => CupertinoAlertDialog(
          title: new Text(R.string.giveNameForCart),
          content: new Container(
              margin: EdgeInsets.only(top: 16),
              child: Column(
                children: <Widget>[
                  CupertinoTextField(
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    keyboardType: TextInputType.url,
                    maxLines: 1,
                    controller: cardNameController,
                    placeholder: R.string.cartName,
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 16,top: 30),
                      child: GestureDetector(
                        child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                R.string.sendCartToPurchase,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                        onTap: (){
                          _sendRequestOrder(context);
                        },
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                R.string.cancel,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white
                                ),
                              ),
                            )
                        ),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      )
                  )
                ],
              )
          )
        )
    );
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

  Widget _searchBar(BuildContext context) {
    return new Container (
        height: 56.0,
        color: Colors.grey,
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width - 16.0,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.0)
              ) ,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ArticleListV()));
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                          Icons.search,
                          color: Colors.grey
                      ),
                    ),
                    new Text(
                      R.string.search,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width  - 190),
                      width: 40,
                      height: 40,
                      child: InkWell(
                        child: Image.asset(
                          'assets/qrCodeGrey.png',
                        ),
                        onTap: (){
                          debugPrint('QRCode Pressed');
                        },
                      ),
                    ),
                  ],
                ),
              )
          ),
        )
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.articleInCart,style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => ShippingAddress()));
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //_searchBar(context),
          TXDividerWidget(),
          TXSearchBarWidget(
            defaultModel: true,
            onQRScanTap: () {},
            onSearchTap: () async {
              NavigationUtils.pushCupertino(context, ArticleListV());
            },
          ),
          Expanded(
            child: SingleChildScrollViewWithScrollbar(
              controller: _scrollController,
              scrollbarColor: Colors.grey.withOpacity(0.75),
              child: new ListView.builder(
                controller: _scrollController,
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
                                  child: baseUrl == null || productList[index].url == null
                                      ? Image.asset('assets/productImage.png')
                                      : productList[index].url.value == ""
                                        ? Image.asset('assets/productImage.png')
                                        : Image(image: NetworkImageSSL(baseUrl + productList[index].url.value)),
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
                                            style:  Theme.of(context).textTheme.bodyText2
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 4),
                                        child: Text(
                                            productList[index].number.value,
                                            style: Theme.of(context).textTheme.bodyText1
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 16,left: 16,bottom: 0,top: 0),
                                    height: 30,
                                    child: Image.asset('assets/trashRed.png'),
                                  ),
                                  onTap: (){
                                    _removeProduct(productList[index].id);
                                  },
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
                                  width: 140,
                                  height: 35,
                                  margin: EdgeInsets.only(left: 52),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon:  Image.asset('assets/Minus.png',color: Theme.of(context).primaryColor),
                                        onPressed: () {
                                          if(int.parse(productList[index].quantity.value)  > 1) {
                                            ISClientO.instance.getProductDetails(productList[index].number.value, int.parse(productList[index].quantity.value) - 1).then((Product product){
                                              setState(() {
                                                int id = this.productList[index].id;
                                                productList[index] = product;
                                                productList[index].id = id;
                                                helper.updateProduct(productList[index], true);
                                              });
                                            });
                                          }
                                        },
                                      ),
                                      Expanded(
                                          child: Center(
                                              child: Container(
                                                height: 22,
                                                width: 52,
                                                child: Center(
                                                    child: Text(productList[index].quantity != null ? productList[index].quantity.value : "1")
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Color.fromRGBO(121, 121, 121, 1),width: 0.3)
                                                ),
                                              )
                                          )
                                      ),
                                      IconButton(
                                        icon:  Image.asset('assets/Plus.png',color: Theme.of(context).primaryColor),
                                        onPressed: () {
                                          ISClientO.instance.getProductDetails(productList[index].number.value, int.parse(productList[index].quantity.value) + 1).then((Product product){
                                            setState(() {
                                              int id = this.productList[index].id;
                                              this.productList[index] = product;
                                              this.productList[index].id = id;
                                              helper.updateProduct(productList[index], true);
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    _priceDetails(context, index),
                                    Container(
                                      margin: EdgeInsets.only(right: 16, bottom: 10,top: 5),
                                      child: Text(
                                        R.string.availability,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _getColorByAvability(productList[index].avability == null ? "1" : productList[index].avability.value ),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
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
          ),
          _loginBt(context)
        ],
      ),
    );
  }

}
