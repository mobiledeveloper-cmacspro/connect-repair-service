import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/ArticleBookMarkV.dart';
import 'package:repairservices/ArticleInCart.dart';
import 'package:repairservices/NetworkImageSSL.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/all_translations.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/utils/custom_scrollbar.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/res/R.dart';

import 'data/dao/shared_preferences_manager.dart';

class ArticleDetailsV extends StatefulWidget {
  final Product product;
  final bool isFromBookMark;
  ArticleDetailsV(this.product,this.isFromBookMark);

  @override
  State<StatefulWidget> createState() {
    return ArticleDetailsState(this.product,this.isFromBookMark);
  }
}

class ArticleDetailsState extends State<ArticleDetailsV> {
  bool loggued = false;
  Product product;
  bool isFromBookMark;
  Image productImage = Image.asset('assets/productImage.png');
  ArticleDetailsState(this.product,this.isFromBookMark);
  bool _loading = false;
  List<TupleData> sourceProduct;
  DatabaseHelper helper = DatabaseHelper.instance;
  int cantProductsInCart = 0;
  final _sharedPreferences = new SharedPreferencesManager();
  String lang = 'de';
  final _scrollController = ScrollController();

  _refillSourceProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final seePrices = prefs.getBool("seePrices");
//    final canBuy = prefs.getBool("canBuy");
    sourceProduct = new List<TupleData>();
//    if(product.avability != null) {
//      sourceProduct.add(product.avability);
//    }
    if(product.currency != null && product.currency.value != "" && seePrices) {
      sourceProduct.add(product.currency);
    }
//    if(product.quantity != null) {
//      sourceProduct.add(TupleData(en: "Quantity:", de: "Menge:",value: product.quantity.value));
//    }
    if(product.unitText != null && product.unitText.value != "") {
      sourceProduct.add(TupleData(en: "sales unit", de: "Einheit", value: _translateUnitText(product.unitText.value)));
    }
    if(product.listPrice != null && product.listPrice.value != "" && seePrices) {
      sourceProduct.add(TupleData(en: "list price", de: "Listenpreis/VKME",value: product.listPrice.value.replaceAll(",", ",")));
    }
    if(product.netPrice != null && product.netPrice.value != "" && seePrices) {
      sourceProduct.add(TupleData(en: "net price", de: product.netPrice.de, value: product.netPrice.value.replaceAll(".", ",")));
    }
    if(product.discount != null  && product.discount.value != "" && seePrices) {
      sourceProduct.add(TupleData(
          en: product.discount.en,
          de: product.discount.de,
          value: double.parse(product.discount.value).toStringAsFixed(2).replaceAll(((".")),",") + " %"));
    }
    setState(() {});
  }

  String _translateUnitText(String value) {
    switch (value) {
      case 'piece':
        return lang == 'de' ? 'Stück' : 'Piece';
      case 'Pair':
        return lang == 'de' ? 'Paar' : 'Pair';
      default:
        return 'Pack';
    }
  }

  String _getTextByAvability(String avability) {
    switch (avability) {
      case "1":
        return R.string.availability1;
      case "2":
        return R.string.availability2;
      case "3":
        return R.string.availability3;
      case "4":
        return R.string.availability4;
      default:
        return R.string.availability5;
    }
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

  Future _getArticleDetails(String number) async {
    setState(() {
      _loading = true;
    });
    try {
      Product product = await ISClientO.instance.getProductDetails(number,null);
      if (product != null) {
        setState(() {
          _loading = false;
          this.product = product;
          _refillSourceProduct();
        });
      }
    }
    catch (e) {
      setState(() {
        _loading = false;
      });
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
  }

  _readAllProductsInCart() async {
    final productList = await helper.queryAllProducts(true);
    debugPrint('Cant products in Cart: ${productList.length}');
    this.setState((){
      this.cantProductsInCart = productList.length;
    });
  }

  Widget _loginBt() {
    if (loggued) {
      return Padding(
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
                    R.string.addToCart,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white
                    ),
                  ),
                )
            ),
            onTap: (){
              _addToCart();
            },
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
                  _getArticleDetails(product.number.value);
                });
              });
            },
          )
      );
    }
  }

  Widget _articleDetails(){
    if(loggued) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
            Container(
              color: Color.fromRGBO(242, 242, 242, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 41,
                    width: 154,
                    child: Center(
                      child: Text(
                        R.string.availability, style: TextStyle(fontSize: 20,color: _getColorByAvability(product.avability != null ? product.avability.value : "1"),fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4),bottomRight: Radius.circular(4)),
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor,width: 1)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text(
                      _getTextByAvability(product.avability != null ? product.avability.value : "1"),
                      style: TextStyle(
                        color: Color.fromRGBO(152, 152, 152, 1.0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: sourceProduct == null ? 0 : sourceProduct.length,
                  itemBuilder:(BuildContext context, int index) {
                    return Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 34),
                            child: Text(lang == 'de' ? sourceProduct[index].de + ":" : sourceProduct[index].en + ":",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 11),
                            child: Text(sourceProduct[index].value),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: 140,
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon:  Image.asset('assets/Minus.png',color: Theme.of(context).primaryColor),
                    onPressed: () {
                      if(int.parse(product.quantity.value)  > 1) {
                        setState(() {
                          _loading = true;
                        });
                        ISClientO.instance.getProductDetails(product.number.value, int.parse(product.quantity.value) - 1).then((Product product){
                          setState(() {
                            _loading = false;
                            this.product = product;
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
                            child: Text(product.quantity != null ? product.quantity.value : "1")
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
                      setState(() {
                        _loading = true;
                      });
                      ISClientO.instance.getProductDetails(product.number.value, int.parse(product.quantity.value) + 1).then((Product product){
                        setState(() {
                          _loading = false;
                          this.product = product;
                        });
                      });
                    },
                  ),
                ],
              ),
            )
        ],
      );
    }
    else {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              child: GestureDetector(
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
                        padding: EdgeInsets.only(right: 8,left: 4),
                        child: Text(
                          R.string.toSeePricesAvailabilityLogIn,
                          style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.w400),
                        ),
                      )
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => LoginV()),
                  );
                },
              ),
            )
          )
        ],
      );
    }
  }

  _saveProduct() async {
    int id = await helper.insertProduct(product,false);
    print('inserted row: $id');
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ArticleBookMark())
    );
  }

  _addToCart() async {
    await helper.insertProduct(product,true).then((int id){
      print('inserted row: $id to Cart');
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => ArticleInCart())
      ).then((_){
        setState(() {
          _readAllProductsInCart();
        });
      });
    });
  }
  @override
  void initState() {
    super.initState();
    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      _loadLang();
      _refillSourceProduct();
      _getImage();
      _readAllProductsInCart();
      setState(()  {});
    });
  }

  Future<void> _loadLang() async {
    lang = await _sharedPreferences.getLanguage();
  }

  _getImage() async{
    debugPrint('getting Image');
    if (product.url.value != null && product.url.value != "") {
      final baseUrl = await ISClientO.instance.baseUrl;
      productImage = Image(image: NetworkImageSSL(baseUrl + product.url.value),height: 100);
      setState((){});
    }
  }

  _bookMarkButton() {
    if (!isFromBookMark) {
      return IconButton(
        icon:  Image.asset('assets/bookmarkWhite.png',color: Theme.of(context).primaryColor),
        onPressed: () {
          debugPrint('bookmark tapped');
          _saveProduct();
        },
      );
    }
    else {
      return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
//        actionsIconTheme: IconThemeData(color: Colors.red),
          title: Text(R.string.articleDetails,style: Theme.of(context).textTheme.bodyText2),
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
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => ArticleInCart())
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(right: this.loggued ? 0 : 8),
                    child: Center(
                      child: new Stack(
                          children: <Widget>[
                            Container(
                              height: 40,
                              child: Image.asset(
                                'assets/shopping-cart.png',
                                height: 25,
                              ),
                            ),

                            new Positioned(
                              right: 0,
                              child: new Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: new Text(
                                      '$cantProductsInCart',
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            )
                          ]
                      ),
                    )
                )
            ),
            _bookMarkButton()
          ]
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        opacity: 0.5,
        progressIndicator: CupertinoActivityIndicator(radius: 20),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor,width: 2.0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 100,
                              child:  productImage,
                            ),
                            Expanded(
                                child: Container(
                                  height: 140,
                                  color: Theme.of(context).primaryColor,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 16,right: 7,bottom: 16),
                                          child: Text(product.shortText.value,
                                              style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold,letterSpacing: 0)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16,right: 7,bottom: 25),
                                          child: Text(product.number.value,
                                              style: TextStyle(color: Colors.white,fontSize: 17,letterSpacing: 0)),
                                        ),
                                      ]
                                  ),
                                )
                            )
                          ],
                        ),
                        Container(height: 2,color: Theme.of(context).primaryColor),
                        Expanded(
                          child: _articleDetails(),
                        )
                      ],
                    ),
                  )
              ),
              _loginBt(),
            ],
          ),
        ),
      )
    );
  }

}