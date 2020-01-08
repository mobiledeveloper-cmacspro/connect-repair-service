import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/models/Company.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:path/path.dart';

final String tableSliding = 'sliding';
final String columnSlidingId = '_id';
final String columnSlidingName = 'name';
final String columnSlidingYear = 'year';
final String columnSlidingCreated = 'created';
final String columnSlidingManufacturer = 'manufacturer';
final String columnSlidingDirectionOpening = 'directionOpening';
final String columnSlidingMaterial  = 'material';
final String columnSlidingSystem = 'system';
final String columnSlidingVentOverlap = 'ventOverlap';
final String columnSlidingTiltSlide = 'tiltSlide';
final String columnSlidingComponents = 'components';
final String columnSlidingDimensionA = 'dimensionA';
final String columnSlidingDimensionB = 'dimensionB';
final String columnSlidingDimensionC = 'dimensionC';
final String columnSlidingDimensionD = 'dimensionD';
final String columnSlidingDimensionImagePath1 = 'dimensionImage1Path';
final String columnSlidingPDFPath = 'pdfPath';

class Sliding extends Fitting {
  String manufacturer,directionOpening,material,system,ventOverlap,tiltSlide,components,dimensionA,dimensionB,dimensionC,dimensionD,dimensionImage1Path;

  Sliding();

  Sliding.withData(String name, DateTime created, String year,String manufacturer,String directionOpening,String material,String system,String ventOverlap,
      String tiltSlide,String components){
    this.name = name;
    this.created = created;
    this.year = year;
    this.manufacturer = manufacturer;
    this.directionOpening = directionOpening;
    this.material = material;
    this.system = system;
    this.ventOverlap = ventOverlap;
    this.tiltSlide = tiltSlide;
    this.components = components;
  }
  Sliding.fromMap(Map<String, dynamic> map) {
    this.id = map[columnSlidingId];
    this.name = map[columnSlidingName];
    this.year = map[columnSlidingYear];
    String createdStr = map[columnSlidingCreated];
    this.created = DateTime.parse(createdStr);
    this.manufacturer = map[columnSlidingManufacturer];
    this.directionOpening = map[columnSlidingDirectionOpening];
    this.material = map[columnSlidingMaterial];
    this.system = map[columnSlidingSystem];
    this.ventOverlap = map[columnSlidingVentOverlap];
    this.tiltSlide = map[columnSlidingTiltSlide];
    this.components = map[columnSlidingComponents];
    this.dimensionA = map[columnSlidingDimensionA];
    this.dimensionB = map[columnSlidingDimensionB];
    this.dimensionC = map[columnSlidingDimensionC];
    this.dimensionD = map[columnSlidingDimensionD];
    this.dimensionImage1Path = map[columnSlidingDimensionImagePath1];
    this.pdfPath = map[columnSlidingPDFPath];
  }

  // convenience method to create a Map from this Door object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSlidingName: name,
      columnSlidingCreated: created.toIso8601String(),
      columnSlidingYear: year,
      columnSlidingManufacturer: manufacturer,
      columnSlidingDirectionOpening: directionOpening,
      columnSlidingMaterial: material,
      columnSlidingSystem: system,
      columnSlidingVentOverlap: ventOverlap,
      columnSlidingTiltSlide: tiltSlide,
      columnSlidingComponents: components,
      columnSlidingDimensionA: dimensionA,
      columnSlidingDimensionB: dimensionB,
      columnSlidingDimensionC: dimensionC,
      columnSlidingDimensionD: dimensionD,
      columnSlidingDimensionImagePath1: dimensionImage1Path,
      columnSlidingPDFPath: pdfPath
    };
    if (id != null) {
      map[columnSlidingId] = id;
    }
    return map;
  }

  Future<String> getHtmlString(String htmlFile) async {
    String htmlStr = htmlFile;
//    Directory directory = await getApplicationDocumentsDirectory();
//    var dbPath = join(directory.path, "logoImage.png");
    ByteData data = await rootBundle.load("assets/repairService.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//    await File(dbPath).writeAsBytes(bytes);
    String logoBase64Image = base64Encode(bytes);
    htmlStr = htmlStr.replaceAll('#LOGO_IMAGE#', 'data:image/png;base64, $logoBase64Image');
    htmlStr = htmlStr.replaceAll("#CREATED#", created.month.toString() + '/' + created.day.toString() + '/' + created.year.toString());
    if (Company.currentCompany != null){
      htmlStr = htmlStr.replaceAll('#COMPANYPROFILE#', Company.currentCompany.htmlLayoutPreview());
    }
    else {
      htmlStr = htmlStr.replaceAll('#COMPANYPROFILE#', '');
    }
    if(year != null && year !=''){
      htmlStr = htmlStr.replaceAll('#year#', year);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Year of contruction </td><td> <br></td></tr><tr class="details"><td> #year# </td></tr>', '');
    }
    if(manufacturer != null && manufacturer != ''){
      htmlStr = htmlStr.replaceAll('#fittingsManufacturer#', manufacturer);
    }else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Fittings manufacturer </td><td> <br></td></tr><tr class="details"><td> #fittingsManufacturer# </td></tr>', '');
    }

    String directionOpeningBase64 = base64Encode(File(await pathDirectionOpening()).readAsBytesSync());
    htmlStr = htmlStr.replaceAll('#directionOfOpeningIm#', 'data:image/png;base64, $directionOpeningBase64');

    htmlStr = htmlStr.replaceAll('#material#', material);
    if(system != null && system != ''){
      htmlStr = htmlStr.replaceAll('#system#', system);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> System </td><td> <br></td></tr><tr class="details"><td> #system# </td></tr>', '');
    }
    htmlStr = htmlStr.replaceAll('#ventOverlap#', ventOverlap);
    htmlStr = htmlStr.replaceAll('#tiltSlideFittings#', tiltSlide);
    if(components != null && components !=''){
      htmlStr = htmlStr.replaceAll('#componentsToBeReplace#', components);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Fittings components to be replaced </td><td> <br></td></tr><tr class="details"><td> #componentsToBeReplace# </td></tr>', '');
    }
    if(dimensionImage1Path != null && dimensionImage1Path != ''){
      String dimensionBase64 = base64Encode(File(dimensionImage1Path).readAsBytesSync());
      htmlStr = htmlStr.replaceAll('#dimensionImage#', 'data:image/png;base64, $dimensionBase64');
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="details"><td> <img src="#dimensionImage#" style="width:200%; max-width:400px;"></td></tr>', '');
    }
    return htmlStr;
  }
  Future<String> pathDirectionOpening() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "slidingDirection${DateTime.now()}.png");
    ByteData data = await rootBundle.load('assets/slidingDirectionOpening${directionOpening.replaceAll('type', '')}.png');
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return dbPath;
  }
}