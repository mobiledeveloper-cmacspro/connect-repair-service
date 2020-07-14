import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:repairservices/crashlytics.dart';
import 'package:repairservices/di/injector.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/res/values/text/custom_localizations_delegate.dart';

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

class MyApp extends StatelessWidget {
  final localizationDelegate = CustomLocalizationsDelegate();

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
      theme: ThemeData(
        // Define the default brightness and colors.
//        brightness: Brightness.dark,
//        primaryColor: Colors.lightGreen[500],
        primaryColor: Color.fromRGBO(120, 185, 40, 1.0),
        // Define the default font family.
        fontFamily: 'Montserrat',
        backgroundColor: Colors.white,
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1:
              TextStyle(fontSize: 17.0, color: Color.fromRGBO(38, 38, 38, 1.0)),
          body2: TextStyle(
              fontSize: 12.0, color: Color.fromRGBO(153, 153, 153, 1.0)),
          subhead: TextStyle(
              fontSize: 17.0,
              color: Color.fromRGBO(38, 38, 38, 1.0),
              fontWeight: FontWeight.w600),
          display1: TextStyle(fontSize: 22.0, color: Colors.lightGreen[500]),
          display2: TextStyle(fontSize: 22.0, color: Colors.grey),
          subtitle: TextStyle(
              fontSize: 14.0, color: Color.fromRGBO(153, 153, 153, 1.0)),
        ),
      ),
      home: HomeM(),
      localizationsDelegates: [
        localizationDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      localeResolutionCallback: localizationDelegate.resolution(
        fallback: Locale("de"),
      ),
    );
  }
}
