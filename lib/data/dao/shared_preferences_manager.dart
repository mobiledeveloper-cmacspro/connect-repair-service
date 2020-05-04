import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  final _language = 'languaje';

  Future<bool> setLanguage(String language) async {
    return (await SharedPreferences.getInstance())
        .setString(_language, language);
  }

  Future<String> getLanguage() async {
    String lang = (await SharedPreferences.getInstance()).getString(_language);
    if (lang == null) {
      await setLanguage('de');
      lang = (await SharedPreferences.getInstance()).getString(_language);
    }
    return lang;
  }
}
