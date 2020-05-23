import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';

class VideoBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {

  static Future<String> getRootFiles() async =>
      await FileUtils.getRootFilesDir();

  Future<File> saveVideo(File currentFile) async {
    final appRootFiles = await getRootFiles();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();

    String newFilePath = "$appRootFiles/$fileName.mp4";
    File newFile = await currentFile.copy('${newFilePath}');

    return newFile;
  }

  void deleteVideo(String filePath){
    File newFile = new File( filePath);
    newFile.delete();
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }

}