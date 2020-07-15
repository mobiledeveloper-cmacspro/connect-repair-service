import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:repairservices/data/dao/shared_preferences_manager.dart';
import 'package:repairservices/res/values/text/custom_localizations_delegate.dart';


class GlobalTranslations {
  Locale _locale;
  VoidCallback _onLocaleChangedCallback;
  final _sharedPreferences = new SharedPreferencesManager();
  final _customIntl = new CustomLocalizationsDelegate();

  ///
  /// Returns the current language code
  ///
  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  ///
  /// Returns the current Locale
  ///
  get locale => _locale;

  ///
  /// One-time initialization
  ///
  Future<Null> init([String language]) async {
    if (_locale == null){
      await setNewLanguage(language);
    }
    return null;
  }

  /// ----------------------------------------------------------
  /// Method that saves/restores the preferred language
  /// ----------------------------------------------------------
  Future<String> getPreferredLanguage() async {
    return await _sharedPreferences.getLanguage();
  }
  Future<void> setPreferredLanguage(String lang) async {
    return await _sharedPreferences.setLanguage(lang);
  }

  ///
  /// Routine to change the language
  ///
  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = true]) async {
    String language = newLanguage;
    if (language == null || language == ""){
      language = 'de';
    }

    _locale = Locale(language);
    _customIntl.load(_locale);

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs){
      await setPreferredLanguage(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    if (_onLocaleChangedCallback != null){
      _onLocaleChangedCallback();
    }

    return null;
  }

  ///
  /// Callback to be invoked when the user changes the language
  ///
  set onLocaleChangedCallback(VoidCallback callback){
    _onLocaleChangedCallback = callback;
  }



  ///
  /// Singleton Factory
  ///
  static final GlobalTranslations _translations = new GlobalTranslations._internal();
  factory GlobalTranslations() {
    return _translations;
  }
  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();