import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/ArticleBookMarkV.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_search_bar_widget.dart';
import 'Login.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'ArticleDetails.dart';

class ArticleListV extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticleListState();
  }
}

class ArticleListState extends State<ArticleListV> {
  bool _loading = false;
  bool loggued = false;

  FocusNode numberNode;
  var numberController = TextEditingController();
  var isSearching = true;
  List<String> articlesList;

  @override
  void initState() {
    super.initState();
    numberNode = FocusNode();
    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    numberNode.dispose();
    super.dispose();
  }

  Future _searchArticle(String number) async {
    setState(() {
      isSearching = true;
    });
    debugPrint('Searching: $number');
    if (number != "") {
      articlesList =
          await ISClientO.instance.getProductNumberAutocompletion(number);
      debugPrint('Artices count: ${articlesList.length}');
      setState(() {});
    }
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
                    builder: (context) => ArticleDetailsV(product, false)))
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

  _endSearch() {
    numberNode.unfocus();
    setState(() {
      isSearching = false;
    });
  }

  Widget _qrButton() {
    if (!isSearching) {
      return IconButton(
        icon: Image.asset('assets/qrCodeGrey.png'),
        onPressed: () {
          debugPrint('GoQRcode Scaner');
        },
      );
    } else {
      return Container(width: 0);
    }
  }

  Widget _cancelButton() {
    if (isSearching) {
      return CupertinoButton(
        child: Text(
          FlutterI18n.translate(context, 'Cancel'),
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          _endSearch();
        },
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 8),
      );
    } else {
      return Container(width: 0);
    }
  }

  Widget searchBar(BuildContext context) {
    return new Container(
        height: 56.0,
        color: Colors.grey,
        child: new Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          color: Colors.grey,
                          icon: Icon(Icons.search),
                          onPressed: () =>
                              _searchArticle(numberController.text),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: new TextField(
                              focusNode: numberNode,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.body1,
                              maxLines: 1,
                              controller: numberController,
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.number,
                              onSubmitted: (search) {
                                _searchArticle(numberController.text);
                                _endSearch();
                              },
                              autofocus: true,
                              onChanged: (string) {
                                _searchArticle(string);
                              },
                              decoration: InputDecoration.collapsed(
                                  border: InputBorder.none,
                                  hintText:
                                      FlutterI18n.translate(context, 'Search'),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 17)),
                            ),
                          ),
                        ),
                        _qrButton()
                      ],
                    ),
                  ),
                ),
                _cancelButton()
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: TXMainBarWidget(
//        actionsIconTheme: IconThemeData(color: Colors.red),
        title: FlutterI18n.translate(context, 'Article List'),
        onLeadingTap: () {
          NavigationUtils.pop(context);
        },
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/bookmarkWhite.png',
                color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => ArticleBookMark()),
              );
            },
          ),
        ],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TXDividerWidget(),
            TXSearchBarWidget(
              onSubmitted: (value) {
                _searchArticle(numberController.text);
                isSearching = false;
                numberNode.unfocus();
                setState(() {});
              },
              onChanged: (value) {
                _searchArticle(value);
              },
              onCancelTap: () {
                isSearching = false;
                numberNode.unfocus();
                setState(() {});
              },
              onQRScanTap: () {},
              onSearchTap: () {
                isSearching = true;
                setState(() {});
              },
              defaultModel: !isSearching,
            ),
//            searchBar(context),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: articlesList == null ? 0 : articlesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(articlesList[index],
                        style: Theme.of(context).textTheme.body1),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      _getArticleDetails(articlesList[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(height: 1),
                shrinkWrap: true,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  child: Container(
                      height: loggued ? 0 : 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, 'login'),
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      )),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => LoginV()),
                    ).then((value) {
                      ISClientO.instance
                          .isTokenAvailable()
                          .then((bool loggued) {
                        this.loggued = loggued;
                        setState(() {});
                      });
                    });
                  },
                ))
          ],
        ),
      ),
      progressIndicator: CupertinoActivityIndicator(radius: 20),
    );
  }
}
