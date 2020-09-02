import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/ArticleDetails.dart';
import 'package:repairservices/ArticleInCart.dart';
import 'package:repairservices/ArticleList.dart';
import 'package:repairservices/ProfileV.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/NetworkImageSSL.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_action_sheet_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_search_bar_widget.dart';
import 'package:repairservices/ui/Cart/CartIcon.dart';
import 'package:repairservices/ui/Login/LoginIcon.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';
import 'package:repairservices/ui/ProfileIcon.dart';
import 'package:repairservices/utils/custom_scrollbar.dart';
import 'Utils/ISClient.dart';
import 'database_helpers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairservices/res/R.dart';

class ArticleBookMark extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticleBookMarkState();
  }
}

class ArticleBookMarkState extends State<ArticleBookMark> {
  bool _loading = false;
  bool loggued = false;
  String baseUrl;
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Product> productList;
  int selected = 0;
  int cantProductsInCart = 0;
  final pdf = pw.Document();
  final _scrollController = ScrollController();

  _readAllProducts() async {
    this.productList = await helper.queryAllProducts(false);
    debugPrint("Product list in BookMark: ${productList.length.toString()}");
  }

  /*
  _readAllProductsInCart() async {
    final productList = await helper.queryAllProducts(true);
    debugPrint('Cant products in Cart: ${productList.length}');
    this.setState(() {
      this.cantProductsInCart = productList.length;
    });
  }

   */

  _removeProduct(int id) {
    helper.deleteProduct(id, false);
  }

  @override
  void initState() {
    super.initState();
    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      LoginIconBloc.changeLoggedInStatus(loggued);
      this.setState(() {
        _readAllProducts();
        _updateBaseUrl();
        //_readAllProductsInCart();
      });
    });
  }

  _updateBaseUrl() async {
    final baseUrl = await ISClientO.instance.baseUrl;
    this.baseUrl = baseUrl;
    setState(() {});
  }

  Widget _profileButton() {
    return ProfileIcon();
  }

  Future _getArticleDetails(String number) async {
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
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ArticleListV())).then((value) {
                    ISClientO.instance.isTokenAvailable().then((bool loggued) {
                      this.loggued = loggued;
                      setState(() {});
                    });
                  });
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
          title: Text(R.string.articleBookmark,
              style: Theme.of(context).textTheme.bodyText2),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
          ),
          actions: <Widget>[CartIcon(), _profileButton()],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TXDividerWidget(),
            TXSearchBarWidget(
              defaultModel: true,
              onQRScanTap: () {},
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
//            _searchBar(context),
            Expanded(
              child: SingleChildScrollViewWithScrollbar(
                scrollbarColor: Colors.grey.withOpacity(0.75),
                controller: _scrollController,
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
                                                  .body1),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 16, top: 4),
                                          child: Text(
                                              productList[index].number.value,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2),
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
                                      height: 22,
                                      child: productList[index].selected
                                          ? Image.asset(
                                              'assets/check_filled.png')
                                          : Image.asset(
                                              'assets/check_empty.png'),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        productList[index].selected =
                                            !productList[index].selected;
                                      });
                                    },
                                  ),
                                ],
                              )),
                          Divider(
                            height: 1,
                            color: Color.fromRGBO(191, 191, 191, 1.0),
                          )
                        ],
                      ),
                      onTap: () {
                        _getArticleDetails(productList[index].number.value);
                      },
                    );
                  },
                  shrinkWrap: true,
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.only(bottom: 0),
              height: 70,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: new Image.asset('assets/options-icon.png',
                              color: Colors.white),
                        ),
                        new Text(
                          R.string.options,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 0.5),
                        )
                      ],
                    ),
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (ctx) {
                            return TXCupertinoActionSheetWidget(
                              onActionTap: (action) {
                                if (action.key == 'Remove selected ones') {
                                  setState(() {
                                    _loading = true;
                                  });
                                  productList.forEach((product) {
                                    if (product.selected) {
                                      _removeProduct(product.id);
                                    }
                                  });
                                  setState(() {
                                    productList.removeWhere(
                                        (element) => element.selected);
                                    _readAllProducts();
                                    _loading = false;
                                  });
                                } else if (action.key == 'Deselect all') {
                                  setState(() {
                                    productList
                                        .forEach((p) => p.selected = false);
                                  });
                                } else if (action.key == 'Select all') {
                                  setState(() {
                                    productList
                                        .forEach((p) => p.selected = true);
                                  });
                                }
                              },
                              actions: [
                                ActionSheetModel(
                                    key: "Select all",
                                    title: R.string.selectAll,
                                    color: Theme.of(context).primaryColor),
                                ActionSheetModel(
                                    key: "Deselect all",
                                    title: R.string.deselectAll,
                                    color: Theme.of(context).primaryColor),
                                ActionSheetModel(
                                    key: "Remove selected ones",
                                    title: R.string.removeSelected,
                                    color: Colors.red)
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
