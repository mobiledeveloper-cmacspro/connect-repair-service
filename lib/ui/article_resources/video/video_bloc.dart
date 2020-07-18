import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:video_player/video_player.dart';

class VideoBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {

  Future<File> saveVideo(File currentFile, String fileName) async {
    FileUtils.getRootFilesDir();
    final appRootFiles = await FileUtils.getRootFilesDir();

    String newFilePath = "$appRootFiles/$fileName.mp4";
    File newFile = await currentFile.copy(newFilePath);

    return newFile;
  }

  Future<void> deleteVideo(String filePath) async{
    File newFile = new File(filePath);
    await newFile.delete();
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}