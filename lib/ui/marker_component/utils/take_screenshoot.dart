import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';

Future<String> takeScreenShot({
  GlobalKey previewContainer,
  BuildContext context,
  double pixelRatio = 1,
  String fileName,
}) async {
  ui.Image image = await getBitmap(
    previewContainer: previewContainer,
    context: context,
    pixelRatio: pixelRatio,
  );
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData.buffer.asUint8List();
  final directory = await FileUtils.getRootFilesDir();
  File imgFile = File('$directory/$fileName');
  imgFile.writeAsBytes(pngBytes);

  return imgFile.path;
}

Future<ui.Image> getBitmap({
  GlobalKey previewContainer,
  BuildContext context,
  double pixelRatio = 1,
}) {
  RenderRepaintBoundary boundary =
      previewContainer.currentContext.findRenderObject();
  return boundary.toImage(pixelRatio: pixelRatio);
}

class EsysFlutterShare {
  static const MethodChannel _channel = const MethodChannel(
      'channel:github.com/orgs/esysberlin/esys-flutter-share');

  /// Shares images with other supported applications on Android and iOS.
  /// The title parameter is just supported on Android and does nothing on iOS.
  static Future shareFile(String fileName, String droidTitle) async {
    Map argsMap = <String, String>{
      'fileName': '$fileName',
      'title': '$droidTitle'
    };
    _channel.invokeMethod('shareImage', argsMap);
  }
}
