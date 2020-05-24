import 'dart:io';

import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';

class AudioBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC{

  static Future<String> getRootFiles() async =>
      await FileUtils.getRootFilesDir();

  Future<String> audioPath() async {
    final appRootFiles = await getRootFiles();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    String newFilePath = "$appRootFiles/$fileName";
    return newFilePath;
  }

  void deleteAudio(String filePath){
    File newFile = new File( filePath);
    newFile.delete();
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }

}