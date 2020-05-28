import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarUtils {
  static String getTimeIdBasedSeconds({bool withTempPrefix = false}) {
    final DateTime now = DateTime.now();
    return "${withTempPrefix ? 'temp_' : ''}${now.year}_${now.month}_${now.day}_${now.hour}_${now.minute}_${now.second}";
  }

  static DateTime getDateTimeFromString(String dateTimeStr) {
    final splittedArray = dateTimeStr.split("_");
    bool hasTempPrefix = splittedArray[0].contains('temp');

    int year = int.parse(splittedArray[hasTempPrefix ? 1 : 0]);
    int month = int.parse(splittedArray[hasTempPrefix ? 2 : 1]);
    int day = int.parse(splittedArray[hasTempPrefix ? 3 : 2]);
    int hour = int.parse(splittedArray[hasTempPrefix ? 4 : 3]);
    int minute = int.parse(splittedArray[hasTempPrefix ? 5 : 4]);
    int second =
        int.parse(splittedArray[hasTempPrefix ? 6 : 5].split(".").first);
    final DateTime dateTime = DateTime(year, month, day, hour, minute, second);
    return dateTime;
  }

  static String showInFormat(String dateFormat, DateTime datetime) {
    DateFormat formatter = DateFormat(dateFormat);
    return formatter.format(datetime);
  }
}
