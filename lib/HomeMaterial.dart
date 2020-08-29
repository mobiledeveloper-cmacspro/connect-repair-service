//import 'dart:html';

import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:package_info/package_info.dart';
import 'package:repairservices/ArticleBookMarkV.dart';
import 'package:repairservices/ArticleInCart.dart';
import 'package:repairservices/Contac.dart';
import 'package:repairservices/FAQ.dart';
import 'package:repairservices/GlobalSetting.dart';
import 'package:repairservices/ProfileV.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/Utils/mail_mananger.dart';
import 'package:repairservices/data/dao/shared_preferences_manager.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/Company.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_search_bar_widget.dart';
import 'package:repairservices/ui/Cart/CartIcon.dart';

//import 'package:repairservices/translations.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'ui/article_identification/article_identification_page.dart';
import 'CompanyProfile.dart';
import 'ArticleList.dart';
import 'package:repairservices/Utils/DeviceInfo.dart';

//import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as Platt;
import 'package:devicelocale/devicelocale.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/res/values/text/custom_localizations_delegate.dart';
import 'all_translations.dart';

class HomeM extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeM> {
  DatabaseHelper helper = DatabaseHelper.instance;
  bool loggued = false;
  int cantProductsInCart = 0;
  final _sharedPreferences = SharedPreferencesManager();
  final _localizationDelegate = CustomLocalizationsDelegate();

  @override
  void initState() {
    super.initState();
    //_localizationDelegate.load(Locale('de'));
    //_sharedPreferences.setLanguage('de');

//    allTranslations.init();

    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      setState(() {});
    });
    //_readAllProductsInCart();
    _readCompanys();
    _isPhysicalDevice();

//    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

//  _onLocaleChanged() async {
//    // do anything you need to do if the language changes
//    print('Language has been changed to: ${allTranslations.currentLanguage}');
//  }

  /*
  _readAllProductsInCart() async {
    final productList = await helper.queryAllProducts(true);
    debugPrint('Cant products in Cart: ${productList.length}');
    this.setState(() {
      this.cantProductsInCart = productList.length;
    });
  }
   */

  Widget _displayGridItem(String value, String imageUrl, Function action,
      {double marginTop = 16, double marginBottom = 10, double width = 80, double height = 80}) {
    return new GestureDetector(
        onTap: action,
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                imageUrl,
                width: width,
                height: height,
              ),
              new Container(
                child: new Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
              )
            ],
          ),
        ));
  }

  Widget _profileButton() {
    if (loggued) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Profile()));
        },
        child: Image.asset(
          'assets/user-icon.png',
          height: 25,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _loginBt() {
    if (!loggued) {
      return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 26),
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
              Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => LoginV()))
                  .then((value) {
                ISClientO.instance.isTokenAvailable().then((bool loggued) {
                  this.loggued = loggued;
                  setState(() {});
                });
              });
            },
          ));
    } else {
      return Container(height: 0);
    }
  }

  _readCompanys() async {
    List<Company> companyList = await helper.queryAllCompany();
    for (Company company in companyList) {
      if (company.defaultC) {
        Company.currentCompany = company;
      }
    }
  }

  final deviceData = DeviceInfo();

  _isPhysicalDevice() async {
    await deviceData.initPlatformState();
    final isPhysicalDevice = deviceData.getData()['isPhysicalDevice'];
    debugPrint('Device Data ${deviceData.getData()}');

    debugPrint('DeviceType: ${deviceData.getData()['model']}, \n DeviceIdent');
  }

  _sendFeedBackByEmail() async {
    final data = deviceData.getData();
    String locale = await Devicelocale.currentLocale;

    bool isIphone = false;
    if (data['systemVersion'] != null) {
      isIphone = true;
    }
    String deviceType =
        isIphone ? data['model'] : data['brand'] + ' ' + data['model'];
    String systemVersion = isIphone
        ? data['systemName'] + ' ' + data['systemVersion']
        : 'Android ' + data['version.release'];
    String version = Platt.Platform.version;
    final MailModel model = MailModel(
      subject: 'App feedback',
      body:
          '<h3>Details</h3><br>V.$version</br><br>$deviceType</br><br>$systemVersion</br><br>$locale</br>',
    );

    final res = await MailManager.sendEmail(model);
    if (res != 'OK')
      Fluttertoast.showToast(msg: res, toastLength: Toast.LENGTH_LONG);
  }

  Widget _createDrawerItem(Image icon, Text text, GestureTapCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: EdgeInsets.only(left: 14),
            child: text,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topButtonPadding = screenHeight * 0.020;
    final bottomButtonPadding = screenHeight * 0.010;
    final divider = Container(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      height: 1,
      margin: EdgeInsets.only(left: 0, right: 0),
    );

    Widget searchBar(BuildContext context) {
      return new Container(
          height: 56.0,
          color: Colors.grey,
          child: Center(
            child: Container(
                width: screenWidth - 16.0,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ArticleListV()))
                        .then((value) {
                      ISClientO.instance
                          .isTokenAvailable()
                          .then((bool loggued) {
                        this.loggued = loggued;
                        //_readAllProductsInCart();
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
                        margin: EdgeInsets.only(left: screenWidth - 190),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Container(
            child: Image.asset(
              'assets/schuco.png',
              fit: BoxFit.contain,
              height: 36,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: <Widget>[
          new CartIcon(this.loggued),
          _profileButton()
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/homeGreen.png',
                  width: 25,
                ),
                Text(R.string.home,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              NavigationUtils.pop(context);
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/articleIdentificationGreen1.png',
                  width: 25,
                ),
                Text(R.string.artIdentServ,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              NavigationUtils.pushCupertinoWithRoute(
                  context,
                  ArticleIdentificationV(),
                  NavigationUtils.ArticleIdentificationPage);
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/documentListGreen1.png',
                  width: 25,
                ),
                Text(R.string.artBookMarkList,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => ArticleBookMark()),
              ).then((_) {
                //_readAllProductsInCart();
              });
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/documentGrey.png',
                  width: 20,
                ),
                Text(R.string.projectDoc,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/docucenter1.png',
                  width: 25,
                ),
                Text(R.string.docCenter,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () async {
              Navigator.pop(context);
              String url = Platt.Platform.isIOS
                  ? 'https://itunes.apple.com/de/app/docu-center/id586582319?mt=8'
                  : 'https://play.google.com/store/apps/details?id=com.schueco.tecdoc&hl=en_US';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/buildingGreenHome.png',
                  width: 25,
                ),
                Text(R.string.companyProfile,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => CompanyProfileV()),
              );
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/informationGreen.png',
                  width: 25,
                ),
                Text(R.string.serviceFaq,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => FAQ()),
              );
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/phoneGreen.png',
                  width: 25,
                ),
                Text(R.string.contact,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => Contact()),
              );
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/gearGreen1.png',
                  width: 25,
                ),
                Text(R.string.setting,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  prefix0.CupertinoPageRoute(
                      builder: (context) => GlobalSettings()));
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/headSetGreen.png',
                  height: 25,
                ),
                Text('Feedback',
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              _sendFeedBackByEmail();
            }),
            divider,
            _createDrawerItem(
                Image.asset(
                  'assets/logOnGreen.png',
                  width: 25,
                ),
                Text(!loggued ? R.string.login : R.string.logoff,
                    style: TextStyle(
                        color: Color.fromRGBO(38, 38, 38, 1.0),
                        fontSize: 17)), () {
              Navigator.pop(context);
              if (!loggued) {
                Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => LoginV()))
                    .then((value) {
                  ISClientO.instance.isTokenAvailable().then((bool loggued) {
                    this.loggued = loggued;
                    setState(() {});
                  });
                });
              } else {
                ISClientO.instance.clearToken().then((_) {
                  setState(() {
                    this.loggued = false;
                  });
                });
              }
            }),
            divider,
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TXDividerWidget(),
          TXSearchBarWidget(
            defaultModel: true,
            onQRScanTap: () {},
            onSearchTap: () async {
              final res =
                  await NavigationUtils.pushCupertino(context, ArticleListV());
              ISClientO.instance.isTokenAvailable().then((bool loggued) {
                this.loggued = loggued;
                //_readAllProductsInCart();
                setState(() {});
              });
            },
          ),
//                  searchBar(context),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: topButtonPadding,
                                bottom: bottomButtonPadding),
                            child: _displayGridItem(R.string.artIdentServ,
                                'assets/articleIdentificationService.png', () {
                                  NavigationUtils.pushCupertinoWithRoute(
                                      context,
                                      ArticleIdentificationV(),
                                      NavigationUtils.ArticleIdentificationPage);
                                }),
                          ),
                        )),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Color.fromARGB(100, 191, 191, 191),
                                  width: 1)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: topButtonPadding,
                              bottom: bottomButtonPadding),
                          child: _displayGridItem(R.string.artBookMarkList,
                              'assets/articleBookmarkList.png', () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ArticleBookMark()),
                                ).then((_) {
                                  //_readAllProductsInCart();
                                });
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 1),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: topButtonPadding,
                                bottom: bottomButtonPadding),
                            child: _displayGridItem(R.string.projectDoc,
                                'assets/projectDocumentation.png', () {}),
                          ),
                        )),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Color.fromARGB(100, 191, 191, 191),
                                  width: 1)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: topButtonPadding,
                              bottom: bottomButtonPadding),
                          child: _displayGridItem(R.string.docCenter,
                              'assets/docucenter.png', () async {
                                String url = Platt.Platform.isIOS
                                    ? 'https://itunes.apple.com/de/app/docu-center/id586582319?mt=8'
                                    : 'https://play.google.com/store/apps/details?id=com.schueco.tecdoc&hl=en_US';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },width: 60),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 1),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: topButtonPadding,
                                bottom: bottomButtonPadding),
                            child: _displayGridItem(
                                R.string.companyProfile, 'assets/companyProfile.png', () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => CompanyProfileV()));
                            }),
                          ),
                        )),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Color.fromARGB(100, 191, 191, 191),
                                    width: 1)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: topButtonPadding,
                                bottom: bottomButtonPadding),
                            child: _displayGridItem(
                                R.string.serviceFaq, 'assets/FAQ.png', () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => FAQ()));
                            }),
                          ),
                        )),
                  ],
                ),
                Divider(height: 1)
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          _loginBt()
        ],
      ),
    );
  }
}
