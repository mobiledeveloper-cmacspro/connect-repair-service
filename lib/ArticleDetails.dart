import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/ArticleBookMarkV.dart';
import 'package:repairservices/ArticleDetailsBloc.dart';
import 'package:repairservices/ArticleInCart.dart';
import 'package:repairservices/NetworkImageSSL.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/all_translations.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/Cart/CartIcon.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';
import 'package:repairservices/utils/custom_scrollbar.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/res/R.dart';
import 'data/dao/shared_preferences_manager.dart';

class ArticleDetailsV extends StatefulWidget {
  final Product product;
  final bool isFromBookMark;
  ArticleDetailsV(this.product, this.isFromBookMark);

  @override
  State<StatefulWidget> createState() => ArticleDetailsState();
}

class ArticleDetailsState
    extends StateWithBloC<ArticleDetailsV, ArticleDetailsBloc> {
  DatabaseHelper helper = DatabaseHelper.instance;
  final _sharedPreferences = new SharedPreferencesManager();
  final _scrollController = ScrollController();
  String lang = 'de';

  _refillSourceProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final seePrices = prefs.getBool("seePrices");
//   final canBuy = prefs.getBool("canBuy");

    bloc.loadTupleData(seePrices, lang);
  }

  Future<void> _loadLang() async {
    lang = await _sharedPreferences.getLanguage();
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

  Future<void> _getArticleDetails(String number) async {
    bloc.setLoading();
    try {
      Product product =
          await ISClientO.instance.getProductDetails(number, null);
      if (product != null) {
        bloc.loadProduct(product);
        _refillSourceProduct();
      }
      bloc.unsetLoading();
    } catch (e) {
      bloc.unsetLoading();
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

  /*
  _readAllProductsInCart() async {
    final productList = await helper.queryAllProducts(true);
    debugPrint('Cant products in Cart: ${productList.length}');
    this.setState((){
      this.cantProductsInCart = productList.length;
    });
  }

   */

  Widget _loginBt() {
    return StreamBuilder<bool>(
      stream: LoginIconBloc.loggedInStream,
      initialData: false,
      builder: (context, snapshot) {
        return snapshot.data
            ? Container()
            : Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: GestureDetector(
                  child: Container(
                      height: 30,
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
                      _reloadData();
                    });
                  },
                ));
      },
    );
  }

  Widget _addToCartButton() {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 5),
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
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              )),
          onTap: () {
            _addToCart();
          },
        ));
  }

  Widget _articleDetails() {
    return StreamBuilder<bool>(
      stream: LoginIconBloc.loggedInStream,
      initialData: false,
      builder: (context, snapshot) {
        return snapshot.data
            ? StreamBuilder<bool>(
          stream: bloc.needReloadStream,
          initialData: false,
          builder: (context, snapshot){
            if(snapshot.data){
              _reloadData();
              ArticleDetailsBloc.setNeedToReload(false);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<Product>(
                  stream: bloc.productStream,
                  initialData: bloc.product,
                  builder: (context, snapshot) {
                    return Container(
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
                                R.string.availability,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: _getColorByAvability(
                                        snapshot.data.avability != null
                                            ? snapshot.data.avability.value
                                            : "1"),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4)),
                                color: Colors.white,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1)),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Text(
                                _getTextByAvability(
                                    snapshot.data.avability != null
                                        ? snapshot.data.avability.value
                                        : "1"),
                                style: TextStyle(
                                    color: Color.fromRGBO(152, 152, 152, 1.0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    child: StreamBuilder<List<TupleData>>(
                      stream: bloc.tupleDataStream,
                      initialData: null,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: snapshot.data == null
                              ? 0
                              : snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 34),
                                    child: Text(
                                      lang == 'de'
                                          ? snapshot.data[index].de + ":"
                                          : snapshot.data[index].en + ":",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 11),
                                    child: Text(snapshot.data[index].value),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                StreamBuilder<Product>(
                  stream: bloc.productStream,
                  initialData: bloc.product,
                  builder: (context, snapshot) {
                    return Container(
                      width: 140,
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('assets/Minus.png',
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if (int.parse(snapshot.data.quantity.value) >
                                  1) {
                                bloc.setLoading();
                                ISClientO.instance
                                    .getProductDetails(
                                    snapshot.data.number.value,
                                    int.parse(snapshot
                                        .data.quantity.value) -
                                        1)
                                    .then((Product product) {
                                  bloc.loadProduct(product);
                                  bloc.unsetLoading();
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
                                        child: Text(snapshot.data.quantity != null
                                            ? snapshot.data.quantity.value
                                            : "1")),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromRGBO(121, 121, 121, 1),
                                            width: 0.3)),
                                  ))),
                          IconButton(
                            icon: Image.asset('assets/Plus.png',
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              bloc.setLoading();
                              ISClientO.instance
                                  .getProductDetails(
                                  snapshot.data.number.value,
                                  int.parse(
                                      snapshot.data.quantity.value) +
                                      1)
                                  .then((Product product) {
                                bloc.loadProduct(product);
                                bloc.unsetLoading();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        )
            : Column(
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
                            child: Icon(CupertinoIcons.info,
                                color: Theme.of(context).primaryColor),
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(right: 8, left: 4),
                            child: Text(
                              R.string.toSeePricesAvailabilityLogIn,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          )),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => LoginV()),
                        ).then((value) {
                          _reloadData();
                        });
                      },
                    ),
                  ))
                ],
              );
      },
    );
  }

  _saveProduct() async {
    int id = await helper.insertProduct(bloc.product, false);
    print('inserted row: $id');
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => ArticleBookMark())).then((value) {
        _reloadData();
    });
  }

  _addToCart() async {
    await helper.insertProduct(bloc.product, true).then((int id) {
      CartIconState.addToCart();
      print('inserted row: $id to Cart');
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => ArticleInCart())).then((value) {
          _reloadData();
      });
    });
  }

  void _reloadData(){
    ISClientO.instance
        .isTokenAvailable()
        .then((bool loggued) async {
      LoginIconBloc.changeLoggedInStatus(loggued);
      if (loggued) {
        await _getArticleDetails(widget.product.number.value);
        await _scrollController.position.animateTo(1.0,
            duration: Duration(seconds: 1),
            curve: Threshold(1.0));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    ISClientO.instance.isTokenAvailable().then((bool loggued) async {
      await _loadLang();
      LoginIconBloc.changeLoggedInStatus(loggued);
      bloc.loadProduct(widget.product);
      _refillSourceProduct();
      bloc.loadImage();
      //_readAllProductsInCart();
    });
  }

  _bookMarkButton() {
    if (!widget.isFromBookMark) {
      return IconButton(
        icon: Image.asset('assets/bookmarkWhite.png',
            color: Theme.of(context).primaryColor),
        onPressed: () {
          debugPrint('bookmark tapped');
          _saveProduct();
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Colors.white,
//        actionsIconTheme: IconThemeData(color: Colors.red),
            title: Text(R.string.articleDetails,
                style: Theme.of(context).textTheme.bodyText2),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                NavigationUtils.pop(context);
              },
              color: Theme.of(context).primaryColor,
            ),
            actions: <Widget>[CartIcon(fromArtDetails: true,), _bookMarkButton()]),
        body: StreamBuilder<bool>(
          stream: bloc.loadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return ModalProgressHUD(
              inAsyncCall: snapshot.data,
              opacity: 0.5,
              progressIndicator: CupertinoActivityIndicator(radius: 20),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              StreamBuilder<Image>(
                                stream: bloc.imageStream,
                                initialData:
                                    Image.asset('assets/productImage.png'),
                                builder: (context, snapshot) {
                                  return Container(
                                    width: 100,
                                    child: snapshot.data,
                                  );
                                },
                              ),
                              Expanded(
                                  child: Container(
                                height: 140,
                                color: Theme.of(context).primaryColor,
                                child: StreamBuilder<Product>(
                                  stream: bloc.productStream,
                                  initialData: bloc.product,
                                  builder: (context, snapshot) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 7, bottom: 16),
                                            child: snapshot.data == null
                                            ? Container()
                                            : Text(
                                                snapshot.data.shortText.value,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 7, bottom: 25),
                                            child: snapshot.data == null
                                            ? Container()
                                            : Text(
                                                snapshot.data.number.value,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    letterSpacing: 0)),
                                          ),
                                        ]);
                                  },
                                ),
                              ))
                            ],
                          ),
                          Container(
                              height: 2, color: Theme.of(context).primaryColor),
                          Expanded(
                            child: _articleDetails(),
                          )
                        ],
                      ),
                    )),
                    _addToCartButton(),
                    _loginBt(),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }
}
