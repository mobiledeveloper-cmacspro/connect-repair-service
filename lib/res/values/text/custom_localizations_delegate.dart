import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:repairservices/res/values/config.dart';
import 'package:repairservices/res/values/text/strings_base.dart';
import 'package:repairservices/res/values/text/strings_de.dart';
import 'package:repairservices/res/values/text/strings_en.dart';

class CustomLocalizationsDelegate extends LocalizationsDelegate<StringsBase> {
  static StringsBase stringsBase = StringsDe();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("de", ""),
      Locale("en", ""),
    ];
  }

  @override
  Future<StringsBase> load(Locale locale) {
    switch (locale.languageCode) {
      case "en":
        stringsBase = StringsEn();
        currentLang = AppLocale.EN;
        break;
      default:
        stringsBase = StringsDe();
        currentLang = AppLocale.DE;
        break;
    }
    return SynchronousFuture<StringsBase>(stringsBase);
  }

  static AppLocale currentLang;

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return resolve(locale, fallback, supported);
    };
  }

  Locale resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  bool isSupported(Locale locale) {
    return supportedLocales
        .map((l) => l.languageCode)
        .toList()
        .contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<StringsBase> old) => false;
}
