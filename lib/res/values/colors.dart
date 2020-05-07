import 'dart:ui';

class AppColor {
  final bool isDarkTheme ;

  final primary_color = Color(0xFF78B928);
  final primary_dark_color = Color(0xFF5A9614);
  final accent_color = Color(0xFF448AFF);

  final gray_darkest = Color(0xFF808080);
  final gray_dark = Color(0x5097A0AE);
  final gray = Color(0xFF97A0AE);
  final gray_light = Color(0xFFF6F7FB);

  Color get dialog_background => isDarkTheme ? Color(0xc855d4d4) : Color(0xc8b4b4b4);

  AppColor({this.isDarkTheme = false});
}
