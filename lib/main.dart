import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:repairservices/crashlytics.dart';
import 'package:repairservices/di/injector.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/res/values/text/custom_localizations_delegate.dart';
import 'package:rxdart/subjects.dart';
import 'all_translations.dart';

//import 'Home.dart';
//import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'HomeMaterial.dart';
import 'package:flutter/services.dart';
//import 'dart:async';

void main() {
  Injector.initProd();
  runApp(MyApp());
//  runAppWithCrashlytics(app: MyApp(), debugMode: false);
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final localizationDelegate = CustomLocalizationsDelegate();
  String currentLocale = "de";

  @override
  void initState() {
    super.initState();
    iniLocaleListener();
  }

  iniLocaleListener() async {
    await allTranslations.init();
    allTranslations.onLocaleChangedCallback = () {
      setState(() {
        currentLocale = allTranslations.currentLanguage;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: R.string.appName,
      home: HomeM(),
      localizationsDelegates: [
        localizationDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      localeResolutionCallback: localizationDelegate.resolution(
        fallback: Locale(currentLocale),
      ),
      locale: Locale(currentLocale),
      theme: _getThemeData(),
      darkTheme: _getThemeData(),
    );
  }

  ThemeData _getThemeData() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
//        primaryColor: Colors.lightGreen[500],
      primaryColor: Color.fromRGBO(120, 185, 40, 1.0),
      // Define the default font family.
      fontFamily: 'Montserrat',
      backgroundColor: Colors.white,
      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2:
            TextStyle(fontSize: 17.0, color: Color.fromRGBO(38, 38, 38, 1.0)),
        bodyText1: TextStyle(
            fontSize: 12.0, color: Color.fromRGBO(153, 153, 153, 1.0)),
        subtitle1: TextStyle(
            fontSize: 17.0,
            color: Color.fromRGBO(38, 38, 38, 1.0),
            fontWeight: FontWeight.w600),
        headline4: TextStyle(fontSize: 22.0, color: Colors.lightGreen[500]),
        headline3: TextStyle(fontSize: 22.0, color: Colors.grey),
        subtitle2: TextStyle(
            fontSize: 14.0, color: Color.fromRGBO(153, 153, 153, 1.0)),
      ),
    );
  }
}
