//import 'dart:html';

import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

//import 'package:package_info/package_info.dart';
import 'package:repairservices/ArticleBookMarkV.dart';
import 'package:repairservices/ArticleInCart.dart';
import 'package:repairservices/Contac.dart';
import 'package:repairservices/FAQ.dart';
import 'package:repairservices/GlobalSetting.dart';
import 'package:repairservices/ProfileV.dart';
import 'package:repairservices/Utils/ISClient.dart';
import 'package:repairservices/data/dao/shared_preferences_manager.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/Company.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';

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

  @override
  void initState() {
    super.initState();
    _sharedPreferences.setLanguage('de');
    ISClientO.instance.isTokenAvailable().then((bool loggued) {
      this.loggued = loggued;
      setState(() {});
    });
    _readAllProductsInCart();
    _readCompanys();
    _isPhysicalDevice();
  }

  _readAllProductsInCart() async {
    final productList = await helper.queryAllProducts(true);
    debugPrint('Cant products in Cart: ${productList.length}');
    this.setState(() {
      this.cantProductsInCart = productList.length;
    });
  }

  Widget _displayGridItem(String value, String imageUrl, Function action) {
    return new GestureDetector(
        onTap: action,
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imageUrl,
              ),
              new Container(
                child: new Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,

                  ),
                ),
                margin: EdgeInsets.only(top: 8),
              )
            ],
          ),
        )
    );
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
    }
    else {
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
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                child: Center(
                  child: Text(
                    FlutterI18n.translate(context, 'login'),
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white
                    ),
                  ),
                )
            ),
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => LoginV()))
                  .then((value) {
                ISClientO.instance.isTokenAvailable().then((bool loggued) {
                  this.loggued = loggued;
                  setState(() {});
                });
              });
            },
          )

      );
    }
    else {
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
//    debugPrint('Device Data ${deviceData.getData()}');
    debugPrint('Sending pdf by Email');
    final data = deviceData.getData();
//    List languages = List();
    String locale = await Devicelocale.currentLocale;
//    languages = await Devicelocale.preferredLanguages;

    bool isIphone = false;
    if (data['systemVersion'] != null) {
      isIphone = true;
    }
    String deviceType = isIphone ? data['model'] : data['brand'] + ' ' +
        data['model'];
    String systemVersion = isIphone ? data['systemName'] + ' ' +
        data['systemVersion'] : 'Android ' + data['version.release'];

//    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = Platt.Platform.version;

//    String version = packageInfo.version;
    final MailOptions mailOptions = MailOptions(
      body: '<h3>Details</h3><br>V.$version</br><br>$deviceType</br><br>$systemVersion</br><br>$locale</br>',
      subject: 'App feedback',
      recipients: ['lepuchenavarro@gmail.com'],
      isHTML: true,
//      bccRecipients: ['other@example.com'],
//      ccRecipients: ['third@example.com'],
//      attachments: [article.pdfPath],
    );

    await FlutterMailer.send(mailOptions);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final topButtonPadding = screenHeight * 0.020;
    final bottomButtonPadding = screenHeight * 0.010;

    Widget searchBar(BuildContext context) {
      return new Container (
          height: 56.0,
          color: Colors.grey,
          child: Center(
            child: Container(
                width: screenWidth - 16.0,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0)
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(
                        builder: (context) => ArticleListV())).then((value) {
                      ISClientO.instance.isTokenAvailable().then((
                          bool loggued) {
                        this.loggued = loggued;
                        _readAllProductsInCart();
                        setState(() {});
                      });
                    });
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
                        FlutterI18n.translate(context, 'Search'),
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
                )
            ),
          )
      );
    }

    final divider = Container(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      height: 1,
      margin: EdgeInsets.only(left: 0, right: 0),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Container(
              child: Image.asset(
                'assets/schuco.png',
                fit: BoxFit.contain,
                height: 36,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Theme
              .of(context)
              .primaryColor),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => ArticleInCart())
                  ).then((value) {
                    ISClientO.instance.isTokenAvailable().then((bool loggued) {
                      this.loggued = loggued;
                      setState(() {});
                    });
                  });
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
            _profileButton()
          ],
        ),

        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/homeGreen.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          FlutterI18n.translate(context, 'Home'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/articleIdentificationGreen1.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          FlutterI18n.translate(context, 'Art_Ident_Serv'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  NavigationUtils.pushCupertinoWithRoute(
                      context, ArticleIdentificationV(),
                      NavigationUtils.ArticleIdentificationPage);
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/documentListGreen1.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          FlutterI18n.translate(context, 'Art_BookMark_List'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => ArticleBookMark()),
                  ).then((_) {
                    _readAllProductsInCart();
                  });
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/documentGrey.png',
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                          FlutterI18n.translate(context, 'home3'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/docucenter1.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          'Docu-Center',
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () async {
                  String url = Platt.Platform.isIOS
                      ?
                  'https://itunes.apple.com/de/app/docu-center/id586582319?mt=8'
                      :
                  'https://play.google.com/store/apps/details?id=com.schueco.tecdoc&hl=en_US';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  Navigator.pop(context);
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/buildingGreenHome.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          FlutterI18n.translate(context, 'comp_prof'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => CompanyProfileV()),
                  );
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/informationGreen.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          'Service / FAQ',
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => FAQ()),
                  );
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/phoneGreen.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          FlutterI18n.translate(context, 'Contact'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Contact()),
                  );
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/gearGreen1.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          FlutterI18n.translate(context, 'Setting'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, prefix0.CupertinoPageRoute(
                      builder: (context) => GlobalSettings()));
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/headSetGreen.png',
                      height: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          'Feedback',
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  _sendFeedBackByEmail();
                },
              ),
              divider,
              ListTile(
                title: Row(
                  children: <Widget>[

                    Image.asset(
                      'assets/logOnGreen.png',
                      width: 25,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                          !loggued
                              ? FlutterI18n.translate(context, 'login')
                              : FlutterI18n.translate(context, 'logoff'),
                          style: TextStyle(
                              color: Color.fromRGBO(38, 38, 38, 1.0),
                              fontSize: 17
                          )
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (!loggued) {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => LoginV()))
                        .then((value) {
                      ISClientO.instance.isTokenAvailable().then((
                          bool loggued) {
                        this.loggued = loggued;
                        setState(() {});
                      });
                    });
                  }
                  else {
                    ISClientO.instance.clearToken().then((_) {
                      setState(() {
                        this.loggued = false;
                      });
                    });
                  }
                },
              ),
              divider,
            ],
          ),
        ),

        body: Scaffold(
            body: new Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  searchBar(context),
                  Expanded(
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
                                    child: _displayGridItem(
                                        FlutterI18n.translate(context, 'home1'),
                                        'assets/articleIdentificationService.png', () {
                                      NavigationUtils.pushCupertinoWithRoute(
                                          context, ArticleIdentificationV(),
                                          NavigationUtils.ArticleIdentificationPage);
                                    }),
                                  ),
                                )
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(left: BorderSide(
                                      color: Color.fromARGB(100, 191, 191, 191),
                                      width: 1)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: topButtonPadding,
                                      bottom: bottomButtonPadding),
                                  child: _displayGridItem(
                                      FlutterI18n.translate(context, 'home2'),
                                      'assets/articleBookmarkList.png', () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(builder: (context) =>
                                          ArticleBookMark()),
                                    ).then((_) {
                                      _readAllProductsInCart();
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
                                    child: _displayGridItem(
                                        FlutterI18n.translate(context, 'home3'),
                                        'assets/projectDocumentation.png', () {}),
                                  ),
                                )
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(left: BorderSide(
                                      color: Color.fromARGB(100, 191, 191, 191),
                                      width: 1)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: topButtonPadding,
                                      bottom: bottomButtonPadding),
                                  child: _displayGridItem("Docu Center \n",
                                      'assets/docucenter.png', () async {
                                        String url = Platt.Platform.isIOS
                                            ?
                                        'https://itunes.apple.com/de/app/docu-center/id586582319?mt=8'
                                            :
                                        'https://play.google.com/store/apps/details?id=com.schueco.tecdoc&hl=en_US';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }),
                                ),
                              ),
                              flex: 1,
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
                                        FlutterI18n.translate(context, 'home4'),
                                        'assets/companyProfile.png', () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  CompanyProfileV())
                                      );
                                    }),
                                  ),
                                )
                            ),
                            Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(
                                        color: Color.fromARGB(
                                            100, 191, 191, 191), width: 1)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: topButtonPadding,
                                        bottom: bottomButtonPadding),
                                    child: _displayGridItem("Service / FAQ\n",
                                        'assets/FAQ.png', () {
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) => FAQ()));
                                        }),
                                  ),
                                )
                            ),
                          ],
                        ),
                        Divider(height: 1)
                      ],
                    ),
                  ),
                  _loginBt()
                ],
              ),
            )
        )
    );
  }

}