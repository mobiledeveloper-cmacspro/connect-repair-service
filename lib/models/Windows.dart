// database table and column names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:repairservices/WindowsGeneralData.dart';
import 'package:repairservices/domain/article_base.dart';

//import 'package:path_provider/path_provider.dart';
//import 'package:path/path.dart';
import 'package:repairservices/models/Company.dart';
import 'package:repairservices/res/R.dart';

final String tableWindows = 'windows';
final String columnId = '_id';
final String columnName = 'name';
final String columnYear = 'year';
final String columnCreated = 'created';
final String columnNumber = 'number';
final String columnSystemDepth = 'systemDepth';
final String columnProfileSystem = 'profileSystem';
final String columnDescription = 'description';
final String columnWindowsPDFPath = 'pdfPath';

// data model class
class Fitting extends ArticleBase {
  int id;
  String name;
  DateTime created;

  String get getNamei18N => (name.contains('Andere Armatur') || name.contains('Other fitting'))
      ? R.string.otherFitting
      : (name.contains('Fensterbeschläge') || name.contains('Windows fittings'))
          ? R.string.windowsFitting
          : (name.contains('Sonnenschutz') || name.contains('Sun shading and screening'))
              ? R.string.sunShadingScreening
              : (name.contains('Schiebebeschläge') || name.contains('Sliding system fittings'))
                  ? R.string.slidingSystemFitting
                  : (name.contains('Türschlossbeschlag') || name.contains('Door Lock Fitting'))
                      ? R.string.doorLockFitting
                      : (name.contains('Türscharnierbeschlag') || name.contains('Door Hinge Fitting'))
                          ? R.string.doorHingeFitting
                          : R.string.otherFitting;

  String year;
  String pdfPath;
}

class Windows extends Fitting {
  int number;
  String systemDepth;
  String profileSystem;
  String description;
  List<ImageFileModel> images;

  Windows();

  // convenience constructor to create a Word object
  Windows.withData(
      String name,
      DateTime created,
      String year,
      int number,
      String systemDepth,
      String profileSystem,
      String description,
      List<ImageFileModel> images) {
    this.name = name;
    this.created = created;
    this.year = year;
    this.number = number;
    this.systemDepth = systemDepth;
    this.profileSystem = profileSystem;
    this.description = description;
    this.images = images;
  }

  Windows.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    year = map[columnYear];
    String createdStr = map[columnCreated];
    created = DateTime.parse(createdStr);
    number = map[columnNumber];
    systemDepth = map[columnSystemDepth];
    profileSystem = map[columnProfileSystem];
    description = map[columnDescription];
    pdfPath = map[columnWindowsPDFPath];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnYear: year,
      columnCreated: created.toIso8601String(),
      columnNumber: number,
      columnSystemDepth: systemDepth,
      columnProfileSystem: profileSystem,
      columnDescription: description,
      // columnFilePath: filePath,
      // columnIsImage: isImage ? '1' : '0',
      columnWindowsPDFPath: pdfPath
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Future<String> getHtmlString(String htmlFile) async {
    String htmlStr = htmlFile;
    if (images.isNotEmpty) {
      images.forEach((image) {
        if (image.isImage) {
          String imageBase64 = base64Encode(File(image.filePath).readAsBytesSync());
          htmlStr = htmlStr.replaceAll(
              '#articleImage#', 'data:image/png;base64, $imageBase64');
        } else {
          htmlStr = htmlStr.replaceAll(
              '<tr class="details"><td> <img src="#articleImage#" style="width:300%; max-width:300px;"></td></tr>',
              '');
        }
      });
    } else {
      htmlStr = htmlStr.replaceAll(
          '<tr class="details"><td> <img src="#articleImage#" style="width:300%; max-width:300px;"></td></tr>',
          '');
    }
    ByteData data = await rootBundle.load("assets/repairService.png");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String logoBase64Image = base64Encode(bytes);
    htmlStr = htmlStr.replaceAll(
        '#LOGOIMAGE#', 'data:image/png;base64, $logoBase64Image');
    htmlStr = htmlStr.replaceAll(
        "#CREATED#",
        created.month.toString() +
            '/' +
            created.day.toString() +
            '/' +
            created.year.toString());
    if (Company.currentCompany != null) {
      htmlStr = htmlStr.replaceAll(
          '#COMPANYPROFILE#', Company.currentCompany.htmlLayoutPreview());
    } else {
      htmlStr = htmlStr.replaceAll('#COMPANYPROFILE#', '');
    }
    htmlStr = htmlStr.replaceAll('#ISWINDOWS#', name);
    if (number != null && number != 0) {
      htmlStr = htmlStr.replaceAll('#articleNumber#', '$number');
    } else {
      htmlStr = htmlStr.replaceAll(
          '<tr class="heading"><td> Part number of defective component </td><td> <br></td></tr><tr class="details"><td> #articleNumber# </td></tr>',
          '');
    }
    if (year != null && year != '') {
      htmlStr = htmlStr.replaceAll('#year#', year);
    } else {
      htmlStr = htmlStr.replaceAll(
          '<tr class="heading"><td> Year of contruction </td><td> <br></td></tr><tr class="details"><td> #year# </td></tr>',
          '');
    }
    if (systemDepth != null && systemDepth != '') {
      htmlStr = htmlStr.replaceAll('#systemDepth#', systemDepth);
    } else {
      htmlStr = htmlStr.replaceAll(
          '<tr class="heading"><td> Systen depth (mm) </td><td> <br></td></tr><tr class="details"><td> #systemDepth# </td></tr>',
          '');
    }
    if (profileSystem != null && profileSystem != '') {
      htmlStr = htmlStr.replaceAll('#profileSystem#', profileSystem);
    } else {
      htmlStr = htmlStr.replaceAll(
          '<tr class="heading"><td> Profile system / -serie </td><td> <br></td></tr><tr class="details"><td> #profileSystem# </td></tr>',
          '');
    }
    if (description != null && description != '') {
      htmlStr = htmlStr.replaceAll('#description#', description);
    } else {
      htmlStr = htmlStr.replaceAll(
          '<tr class="heading"><td> Description </td><td> <br></td></tr><tr class="details"><td> #description# </td></tr>',
          '');
    }
    debugPrint('html in windows replaced');
    return htmlStr;
  }
}

final String tableImageFile = 'image_file';
final String columnParentId = 'windowId';
final String columnFilePath = 'file';
final String columnIsImage = 'isImage';

class ImageFileModel {
  bool isImage;
  String filePath;
  File file;
  int id;

  ImageFileModel({
    @required this.isImage,
    @required this.filePath,
    @required this.file
  });

  ImageFileModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    filePath = map[columnFilePath];
    isImage = map[columnIsImage] == '0' ? false : true;
    file = File(map[columnFilePath]);
  }

  Map<String, dynamic> toMap(int parentId) {
    return <String, dynamic>{
      columnFilePath: filePath,
      columnIsImage: isImage ? '1' : '0',
      columnParentId: parentId,
    };
  }
}
