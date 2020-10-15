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
import 'package:repairservices/ui/Login/LoginIcon.dart';
import 'package:repairservices/ui/Login/LoginIconBloc.dart';
import 'package:repairservices/ui/ProfileIcon.dart';
import 'package:repairservices/ui/qr_scan/qr_scan_page.dart';

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
import 'package:permission_handler/permission_handler.dart';


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

    ISClientO.instance.isTokenAvailable().then((bool loggued) async {
      this.loggued = loggued;
      if(loggued){
        await ISClientO.instance.getUserInformation();
      }
      LoginIconBloc.changeLoggedInStatus(loggued);
      //setState(() {});
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
    return ProfileIcon();
  }

  Widget _loginBt() {
    return new LoginIcon(paddingLeft: 16, paddingRight: 16, paddingTop: 5, paddingBottom: 20);
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

  Widget _createDrawerItem(Image icon, Text text, GestureTapCallback onTap, {paddingLeft = 14.0}) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: EdgeInsets.only(left: paddingLeft),
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
          CartIcon(),
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
            },
              paddingLeft: 18.0,
            ),
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
            },
            ),
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
            StreamBuilder<bool>(
              stream: LoginIconBloc.loggedInStream,
              initialData: false,
              builder: (context, snapshot) => _createDrawerItem(
                  Image.asset(
                    'assets/logOnGreen.png',
                    width: 25,
                  ),
                  Text(!snapshot.data ? R.string.login : R.string.logoff,
                      style: TextStyle(
                          color: Color.fromRGBO(38, 38, 38, 1.0), fontSize: 17)), () {
                Navigator.pop(context);
                if (!snapshot.data) {
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => LoginV()));
                } else {
                  ISClientO.instance.clearToken().then((_) {
                    LoginIconBloc.changeLoggedInStatus(false);
                  });
                }
              }),
            ),
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
            onQRScanTap: () async {
              bool permission = await Permission.camera.request().isGranted;
              if(permission)
                NavigationUtils.push(context, QRScanPage());
              else
                _showDialog(context, 'Exception', "Camera permissions required");
            },
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
}
