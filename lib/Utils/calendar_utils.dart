import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarUtils {
  static String getTimeIdBasedSeconds() {
    final DateTime now = DateTime.now();
    return "${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}";
  }

  static String showInFormat(String dateFormat, DateTime datetime) {
    DateFormat formatter = DateFormat(dateFormat, "de");
    return formatter.format(datetime);
  }
}
