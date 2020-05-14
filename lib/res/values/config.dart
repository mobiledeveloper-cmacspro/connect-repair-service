import 'dart:io';

import 'package:repairservices/res/values/text/custom_localizations_delegate.dart';


enum AppPlatform { ANDROID, IOS }
enum AppLocale { DE, EN }

class AppConfig {
  static bool get isInDebugMode {
    var debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  static AppLocale get locale => CustomLocalizationsDelegate.currentLang;

  static String get localeCode =>
      locale == AppLocale.EN ? 'en' : 'de';

  ///Access to info about current platform
  static AppPlatform get platform =>
      Platform.isIOS ? AppPlatform.IOS : AppPlatform.ANDROID;
}
