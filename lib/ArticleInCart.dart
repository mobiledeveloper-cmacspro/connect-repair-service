import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repairservices/ArticleDetailsBloc.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/ArticleList.dart';
import 'package:repairservices/Login.dart';
import 'package:repairservices/ShippingAddress.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/NetworkImageSSL.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_bottom_sheet.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_search_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/Cart/CartIcon.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';
import 'package:repairservices/ui/qr_scan/qr_scan_page.dart';
import 'package:repairservices/utils/custom_scrollbar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ArticleDetails.dart';
import 'models/User.dart';
import 'utils/ISClient.dart';
import 'database_helpers.dart';
import 'package:repairservices/res/R.dart';

class ArticleInCart extends StatefulWidget {
  final bool comeFromArtDetails;

  ArticleInCart({this.comeFromArtDetails = false});

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
  BuyerUser currentBuyer;
  bool canSeePrice = false;
  bool canBuy = false;
  int selected = 0;
  bool _loading = false;
  final _scrollController = ScrollController();

  final cardNameController = TextEditingController();

  BehaviorSubject<bool> cartSent = new BehaviorSubject();

  @override
  void dispose() {
    cartSent.close();
    super.dispose();
  }

  _readAllProducts() async {
    this.productList = await helper.queryAllProducts(true);
    debugPrint("Products in Cart: " + productList.length.toString());
    this.setState(() {});
    if (loggued && canSeePrice) {
      for (int i = 0; i < productList.length; i++) {
        _getArticleDetails(productList[i]).then((product) {
          int id = productList[i].id;
          productList[i] = product;
          productList[i].id = id;
          setState(() {});
        });
      }
    }
  }

  _removeProduct(int id) {
    helper.deleteProduct(id, true).then((_) {
      CartIconState.removeFromCart();
      _readAllProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    cartSent.listen((value) {
        _showAlertDialog(context, R.string.cartSent(
            sent: value ?? false,
            purchaser: currentBuyer.userId,
            cartName: cardNameController.text), R.string.ok);

    });
    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      LoginIconBloc.changeLoggedInStatus(loggued);
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

  _requestOrder(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      final buyers = await ISClientO.instance.getBuyerUsers();
      setState(() {
        _loading = false;
      });
      if (buyers == null || (buyers != null && buyers.isEmpty)) {
        _showAlertDialog(
            context, R.string.noUserWithPurchasingAuth, R.string.ok);
      } else {
        showTXModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      TXTextWidget(
                        text: "Select a Purchaser",
                        size: 18,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(height: 1, color: R.color.gray),
                      ...List.generate(
                          buyers.length,
                          (index) => InkWell(
                                onTap: () {
                                  NavigationUtils.pop(context);
                                  _showAlertRequestOrder(
                                      context, buyers[index]);
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: TXTextWidget(
                                          text: buyers[index].name,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: TXTextWidget(
                                          text: buyers[index].userId,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(height: 1, color: R.color.gray),
                                    ],
                                  ),
                                ),
                              )),
                    ],
                  ),
                ),
              );
            });
      }
    } catch (ex) {
      print(ex.toString());
      setState(() {
        _loading = false;
      });
      _showAlertDialog(context, ex.toString(), R.string.ok);
    }
  }

  _order() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => ShippingAddress()));
  }

  Widget _priceDetails(BuildContext context, int pos) {
    if (canSeePrice &&
        productList[pos].totalAmount != null &&
        productList[pos].totalAmount.value != "" &&
        productList[pos].currency != null &&
        productList[pos].currency.value != "") {
      return Container(
        margin: EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            Text(R.string.netValue,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(
                productList[pos].totalAmount.value.replaceAll('.', ',') +
                    " " +
                    productList[pos].currency.value,
                style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _loginBt(BuildContext context) {
    if (loggued && canBuy) {
      return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
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
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      )),
                  onTap: () {
                    _requestOrder(context);
                  },
                ),
              ),
              // GestureDetector(
              //   child: Container(
              //       height: 30,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5.0),
              //         color: Theme.of(context).primaryColor,
              //       ),
              //       child: Center(
              //         child: Text(
              //           R.string.order,
              //           style: TextStyle(fontSize: 17, color: Colors.white),
              //         ),
              //       )),
              //   onTap: () {
              //     _order();
              //   },
              // )
            ],
          )));
    } else if (loggued && !canBuy) {
      return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
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
                        child: Icon(CupertinoIcons.info,
                            color: Theme.of(context).primaryColor),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(
                            right: 8, left: 4, top: 16, bottom: 16),
                        child: Text(
                          R.string.selectedB2BUnitHasNoBuyer,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                    ],
                  )),
              GestureDetector(
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: R.color.gray,
                    ),
                    child: Center(
                      child: Text(
                        R.string.requestOrder,
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    )),
                onTap: () {
                  //_requestOrder(context);
                },
              )
            ],
          )));
    } else {
      return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
          child: GestureDetector(
            child: Container(
                height: loggued ? 0 : 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    R.string.login,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                )),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => LoginV()),
              ).then((value) {
                ISClientO.instance.isTokenAvailable().then((bool loggued) {
                  this.loggued = loggued;
                  _updateBaseUrl();
                });
              });
            },
          ));
    }
  }

  _showAlertDialog(BuildContext context, String title, String textButton) {
    debugPrint('Showing Alert with title: $title');
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title:
                  new Text(title, style: Theme.of(context).textTheme.bodyText2),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: new Text(textButton),
                  isDestructiveAction: false,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Future<bool> _sendRequestOrder(BuyerUser buyer) async {
    try {
      debugPrint('calling create cart');
      final created = await ISClientO.instance
          .createCart(cardNameController.text, productList, buyer);
      cardNameController.text = '';
      return created;
    } catch (e) {
      cardNameController.text = '';
      print('Exception details:\n $e');
      _showAlertDialog(context, e.toString(), "OK");
      return false;
    }
  }

  _showAlertRequestOrder(BuildContext context, BuyerUser buyer) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
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
                        padding: EdgeInsets.only(bottom: 16, top: 30),
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
                                      fontSize: 17, color: Colors.white),
                                ),
                              )),
                          onTap: () async {
                            if (cardNameController.text == "") {
                              _showAlertDialog(
                                  context, "Cart name is empty", 'OK');
                            } else {
                              NavigationUtils.pop(context);
                              setState(() {
                                _loading = true;
                              });
                              final sent = await _sendRequestOrder(buyer);
                              setState(() {
                                _loading = false;
                              });
                              currentBuyer = buyer;
                              cartSent.sink.add(sent);
                            }
                          },
                        )),
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
                                      fontSize: 17, color: Colors.white),
                                ),
                              )),
                          onTap: () {
                            Navigator.pop(context);
                            cardNameController.text = '';
                          },
                        ))
                  ],
                ))));
  }

  Future _goToArticleDetails(String number) async {
    setState(() {
      _loading = true;
    });
    try {
      Product product =
          await ISClientO.instance.getProductDetails(number, null);
      if (product != null) {
        setState(() {
          _loading = false;
        });
        Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ArticleDetailsV(product, true)))
            .then((value) {
          ISClientO.instance.isTokenAvailable().then((bool loggued) {
            this.loggued = loggued;
            setState(() {});
          });
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Exception details:\n $e');
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text("Error"),
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(e.toString(), style: TextStyle(fontSize: 17)),
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
              ));
    }
  }

  Future<Product> _getArticleDetails(Product prod) async {
    try {
      Product product = await ISClientO.instance
          .getProductDetails(prod.number.value, int.parse(prod.quantity.value));
      if (product != null) {
        return product;
      }
    } catch (e) {
      print('Exception details:\n $e');
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text("Error"),
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(e.toString(), style: TextStyle(fontSize: 17)),
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
              ));
    }
    return prod;
  }

  Widget _searchBar(BuildContext context) {
    return new Container(
        height: 56.0,
        color: Colors.grey,
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width - 16.0,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.0)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => ArticleListV()));
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.search, color: Colors.grey),
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
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width - 190),
                      width: 40,
                      height: 40,
                      child: InkWell(
                        child: Image.asset(
                          'assets/qrCodeGrey.png',
                        ),
                        onTap: () {
                          debugPrint('QRCode Pressed');
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ));
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

  _showDialog(BuildContext context, String title, String msg) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: msg.isNotEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Text(msg, style: TextStyle(fontSize: 17)),
                    )
                  : Container(),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("OK"),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
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
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(R.string.articleInCart,
              style: Theme.of(context).textTheme.bodyText2),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (widget.comeFromArtDetails) {
                ArticleDetailsBloc.setNeedToReload(true);
              }
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ShippingAddress()));
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
              onQRScanTap: () async {
                bool permission = await Permission.camera.request().isGranted;
                if (permission)
                  NavigationUtils.push(context, QRScanPage());
                else
                  _showDialog(
                      context, 'Exception', "Camera permissions required");
              },
              onSearchTap: () async {
                final res = await NavigationUtils.pushCupertino(
                    context, ArticleListV());
                ISClientO.instance.isTokenAvailable().then((bool loggued) {
                  this.loggued = loggued;
                  //_readAllProductsInCart();
                  setState(() {});
                });
              },
            ),
            Expanded(
              child: SingleChildScrollViewWithScrollbar(
                controller: _scrollController,
                scrollbarColor: Colors.grey.withOpacity(0.75),
                child: new ListView.builder(
                  controller: _scrollController,
                  itemCount: productList == null ? 0 : productList.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                    child: baseUrl == null ||
                                            productList[index].url == null
                                        ? Image.asset('assets/productImage.png')
                                        : productList[index].url.value == ""
                                            ? Image.asset(
                                                'assets/productImage.png')
                                            : Image(
                                                image: NetworkImageSSL(baseUrl +
                                                    productList[index]
                                                        .url
                                                        .value)),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16, top: 10),
                                          child: Text(
                                              productList[index]
                                                  .shortText
                                                  .value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 16, top: 4),
                                          child: Text(
                                              productList[index].number.value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 16,
                                          left: 16,
                                          bottom: 0,
                                          top: 0),
                                      height: 30,
                                      child: Image.asset('assets/trashRed.png'),
                                    ),
                                    onTap: () {
                                      _removeProduct(productList[index].id);
                                    },
                                  ),
                                ],
                              )),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Image.asset('assets/Minus.png',
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: () {
                                            if (int.parse(productList[index]
                                                    .quantity
                                                    .value) >
                                                1) {
                                              if (loggued) {
                                                ISClientO.instance
                                                    .getProductDetails(
                                                        productList[index]
                                                            .number
                                                            .value,
                                                        int.parse(productList[
                                                                    index]
                                                                .quantity
                                                                .value) -
                                                            1)
                                                    .then((Product product) {
                                                  setState(() {
                                                    int id = this
                                                        .productList[index]
                                                        .id;
                                                    productList[index] =
                                                        product;
                                                    productList[index].id = id;
                                                    helper.updateProduct(
                                                        productList[index],
                                                        true);
                                                  });
                                                });
                                              } else {
                                                setState(() {
                                                  productList[index]
                                                      .quantity
                                                      .value = (int.parse(
                                                              productList[index]
                                                                  .quantity
                                                                  .value) -
                                                          1)
                                                      .toString();
                                                  helper.updateProduct(
                                                      productList[index], true);
                                                });
                                              }
                                            }
                                          },
                                        ),
                                        Expanded(
                                            child: Center(
                                                child: Container(
                                          height: 22,
                                          width: 52,
                                          child: Center(
                                              child: Text(
                                                  productList[index].quantity !=
                                                          null
                                                      ? productList[index]
                                                          .quantity
                                                          .value
                                                      : "1")),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      121, 121, 121, 1),
                                                  width: 0.3)),
                                        ))),
                                        IconButton(
                                          icon: Image.asset('assets/Plus.png',
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: () {
                                            if (loggued) {
                                              ISClientO.instance
                                                  .getProductDetails(
                                                      productList[index]
                                                          .number
                                                          .value,
                                                      int.parse(
                                                              productList[index]
                                                                  .quantity
                                                                  .value) +
                                                          1)
                                                  .then((Product product) {
                                                setState(() {
                                                  int id = this
                                                      .productList[index]
                                                      .id;
                                                  this.productList[index] =
                                                      product;
                                                  this.productList[index].id =
                                                      id;
                                                  helper.updateProduct(
                                                      productList[index], true);
                                                });
                                              });
                                            } else {
                                              setState(() {
                                                productList[index]
                                                    .quantity
                                                    .value = (int.parse(
                                                            productList[index]
                                                                .quantity
                                                                .value) +
                                                        1)
                                                    .toString();
                                                helper.updateProduct(
                                                    productList[index], true);
                                              });
                                            }
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
                                        margin: EdgeInsets.only(
                                            right: 16, bottom: 10, top: 5),
                                        child: Text(
                                          R.string.availability,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: loggued
                                                  ? _getColorByAvability(
                                                      productList[index]
                                                                  .avability ==
                                                              null
                                                          ? "1"
                                                          : productList[index]
                                                              .avability
                                                              .value)
                                                  : Colors.black38,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Divider(
                            height: 1,
                            color: Color.fromRGBO(191, 191, 191, 1.0),
                          )
                        ],
                      ),
                      onTap: () {
                        _goToArticleDetails(productList[index].number.value);
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
      ),
    );
  }
}
