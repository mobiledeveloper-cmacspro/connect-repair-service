import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/Cart/ArticleInCartBloc.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';
import 'package:repairservices/utils/ISClient.dart';

import '../../ArticleInCart.dart';
import '../../database_helpers.dart';

class CartIcon extends StatefulWidget {
  final bool fromArtDetails;

  CartIcon({this.fromArtDetails = false});

  @override
  State<StatefulWidget> createState() => CartIconState();
}

class CartIconState extends StateWithBloC<CartIcon, ArticleInCartBloc> {
  static int prodQuantity = 0;
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  initState(){
    super.initState();
    _readAllProductsInCart();
  }

  _readAllProductsInCart() async {
    final productList = await helper.queryAllProducts(true);
    debugPrint('Products in Cart: ${productList.length}');
    prodQuantity = productList.length;
    ArticleInCartBloc.setInCart(prodQuantity);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<bool>(
      stream: LoginIconBloc.loggedInStream,
      initialData: false,
      builder: (context, snapshot) => GestureDetector(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ArticleInCart(comeFromArtDetails: widget.fromArtDetails,)));
          },
          child: Container(
              margin: EdgeInsets.only(right: snapshot.data ? 2 : 8),
              child: Center(
                child: new Stack(children: <Widget>[
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
                          child: StreamBuilder<int>(
                            stream: bloc.inCartStream,
                            initialData: 0,
                            builder: (context, snapshot) {
                              return Text(
                                '${snapshot.data}',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        )),
                  )
                ]),
              ))),
    );
  }

  static void addToCart() {
    ArticleInCartBloc.setInCart(++prodQuantity);
  }

  static void removeFromCart() {
    ArticleInCartBloc.setInCart(--prodQuantity);
  }

  static void removeAllFromCart() {
    prodQuantity = 0;
    ArticleInCartBloc.setInCart(prodQuantity);
  }
}
