// database table and column names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:path/path.dart';
import 'package:repairservices/models/Company.dart';

final String tableDoorHinge = 'doorhinge';
final String columnDoorHingeId = '_id';
final String columnDoorHingeName = 'name';
final String columnDoorHingeYear = 'year';
final String columnDoorHingeCreated = 'created';
final String columnDoorHingeBasicDepthOfDoor = 'basicDepthOfDoorLeaf';
final String columnDoorHingeSystemHinge = 'systemHinge';
final String columnDoorHingeMaterial = 'material';
final String columnDoorHingeThermally = 'thermally';
final String columnDoorHingeDoorOpening = 'doorOpening';
final String columnDoorHingeFitted = 'fitted';
final String columnDoorHingeHingeType = 'hingeType';
final String columnDoorHingeDoorHingeDetailsIm = 'doorHingeDetailsIm';
final String columnDoorHingeDimensionsSurfaceA = 'dimensionsSurfaceA';
final String columnDoorHingeDimensionsSurfaceB = 'dimensionsSurfaceB';
final String columnDoorHingeDimensionsSurfaceC = 'dimensionsSurfaceC';
final String columnDoorHingeDimensionsSurfaceD = 'dimensionsSurfaceD';
final String columnDoorHingeDimensionSurfaceIm = 'dimensionSurfaceIm';
final String columnDoorHingeCoverCaps = 'coverCaps';
final String columnDoorHingeDoorLeafBarrel = 'doorLeafBarrel';
final String columnDoorHingeSystemDoorLeaf = 'systemDoorLeaf';
final String columnDoorHingeDoorFrame = 'doorFrame';
final String columnDoorHingeSystemDoorFrames = 'systemDoorFrame';
final String columnDoorHingeDimensionsBarrelA = 'dimensionsBarrelA';
final String columnDoorHingeDimensionsBarrelB = 'dimensionsBarrelB';
final String columnDoorHingeDimensionBarrelIm = 'dimensionBarrelIm';
final String columnDoorHingePDFPath = 'pdfPath';

class DoorHinge extends Fitting{
  String basicDepthOfDoorLeaf,systemHinge,material,thermally,doorOpening,fitted,hingeType,doorHingeDetailsIm,
      dimensionsSurfaceA,dimensionsSurfaceB,dimensionsSurfaceC,dimensionsSurfaceD,dimensionSurfaceIm,coverCaps,doorLeafBarrel,systemDoorLeaf,
      doorFrame,systemDoorFrame,dimensionsBarrelA,dimensionsBarrelB,dimensionBarrelIm;
  DoorHinge();
  // convenience constructor to create a Door object
  DoorHinge.withData(String name, DateTime created, String dimensionsSurfaceA,String dimensionsSurfaceB,String dimensionsSurfaceC,String dimensionsSurfaceD,
      String dimensionSurfaceImPath) {
    this.name = name;
    this.created = created;
    this.dimensionsSurfaceA = dimensionsSurfaceA;
    this.dimensionsSurfaceB = dimensionsSurfaceB;
    this.dimensionsSurfaceC = dimensionsSurfaceC;
    this.dimensionsSurfaceD = dimensionsSurfaceD;
    this.dimensionSurfaceIm = dimensionSurfaceImPath;
  }

  DoorHinge.fromMap(Map<String, dynamic> map) {
    id = map[columnDoorHingeId];
    name = map[columnDoorHingeName];
    year = map[columnDoorHingeYear];
    String createdStr = map[columnDoorHingeCreated];
    created = DateTime.parse(createdStr);
    basicDepthOfDoorLeaf = map[columnDoorHingeBasicDepthOfDoor];
    systemHinge = map[columnDoorHingeSystemHinge];
    material = map[columnDoorHingeMaterial];
    thermally = map[columnDoorHingeThermally];
    doorOpening = map[columnDoorHingeDoorOpening];
    fitted = map[columnDoorHingeFitted];
    hingeType = map[columnDoorHingeHingeType];
    doorHingeDetailsIm = map[columnDoorHingeDoorHingeDetailsIm];
    dimensionsSurfaceA = map[columnDoorHingeDimensionsSurfaceA];
    dimensionsSurfaceB = map[columnDoorHingeDimensionsSurfaceB];
    dimensionsSurfaceC = map[columnDoorHingeDimensionsSurfaceC];
    dimensionsSurfaceD = map[columnDoorHingeDimensionsSurfaceD];
    dimensionSurfaceIm = map[columnDoorHingeDimensionSurfaceIm];
    coverCaps = map[columnDoorHingeCoverCaps];
    doorLeafBarrel = map[columnDoorHingeDoorLeafBarrel];
    systemDoorLeaf = columnDoorHingeSystemDoorLeaf;
    doorFrame = map[columnDoorHingeDoorFrame];
    systemDoorFrame = map[columnDoorHingeSystemDoorFrames];
    dimensionsBarrelA = map[columnDoorHingeDimensionsBarrelA];
    dimensionsBarrelB = map[columnDoorHingeDimensionsBarrelB];
    dimensionBarrelIm = map[columnDoorHingeDimensionBarrelIm];
    pdfPath = map[columnDoorHingePDFPath];
  }

  // convenience method to create a Map from this Door object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDoorHingeName: name,
      columnDoorHingeCreated: created.toIso8601String(),
      columnDoorHingeYear: year,
      columnDoorHingeBasicDepthOfDoor: basicDepthOfDoorLeaf,
      columnDoorHingeSystemHinge: systemHinge,
      columnDoorHingeMaterial: material,
      columnDoorHingeThermally: thermally,
      columnDoorHingeDoorOpening: doorOpening,
      columnDoorHingeFitted: fitted,
      columnDoorHingeHingeType: hingeType,
      columnDoorHingeDoorHingeDetailsIm: doorHingeDetailsIm,
      columnDoorHingeDimensionsSurfaceA: dimensionsSurfaceA,
      columnDoorHingeDimensionsSurfaceB: dimensionsSurfaceB,
      columnDoorHingeDimensionsSurfaceC: dimensionsSurfaceC,
      columnDoorHingeDimensionsSurfaceD: dimensionsSurfaceD,
      columnDoorHingeDimensionSurfaceIm: dimensionSurfaceIm,
      columnDoorHingeCoverCaps: coverCaps,
      columnDoorHingeDoorLeafBarrel: doorLeafBarrel,
      columnDoorHingeSystemDoorLeaf: systemDoorLeaf,
      columnDoorHingeDoorFrame: doorFrame,
      columnDoorHingeSystemDoorFrames: systemDoorFrame,
      columnDoorHingeDimensionsBarrelA: dimensionsBarrelA,
      columnDoorHingeDimensionsBarrelB: dimensionsBarrelB,
      columnDoorHingeDimensionBarrelIm: dimensionBarrelIm,
      columnDoorHingePDFPath: pdfPath
    };
    if (id != null) {
      map[columnDoorHingeId] = id;
    }
    return map;
  }
  Future<String> getHtmlString(String htmlFile) async {
    String htmlStr = htmlFile;
//    Directory directory = await getApplicationDocumentsDirectory();
//    var dbPath = join(directory.path, "logoImage.png");
    ByteData data = await rootBundle.load("assets/repairService.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String logoBase64Image = base64Encode(bytes);
//    await File(dbPath).writeAsBytes(bytes);
//    htmlStr = htmlStr.replaceAll('#LOGO_IMAGE#', 'file://'+dbPath);
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
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Year of contruction </td><td> <br></td></tr><tr class="details"><td> #year# </td></tr><tr class="heading"><td> Year of manufacturing </td><td> <br></td></tr><tr class="details"><td> #year# </td></tr>', '');
    }

    htmlStr = htmlStr.replaceAll('#basicDepthOfDoorLeaf#', basicDepthOfDoorLeaf);
    htmlStr = htmlStr.replaceAll('#systemHinge#', systemHinge);
    htmlStr = htmlStr.replaceAll('#material#', material);
    htmlStr = htmlStr.replaceAll('#thermally#', thermally);
    htmlStr = htmlStr.replaceAll('#doorOpening#', doorOpening);
    htmlStr = htmlStr.replaceAll('#fitted#', fitted);
    htmlStr = htmlStr.replaceAll('#hingeType#', hingeType);
    if(hingeType=='Surface-mounted door hinge'){
      htmlStr = htmlStr.replaceAll('#coverCaps#', coverCaps);
      if(doorHingeDetailsIm !=null && doorHingeDetailsIm !=''){
        String imageBase64 = base64Encode(File(await pathSurfaceDetails()).readAsBytesSync());
        htmlStr = htmlStr.replaceAll('#doorHingeDetailsIm#', 'data:image/png;base64, $imageBase64');
      }
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Door hinge details: </td><td> <br></td></tr>'
          '<tr class="details"><td> <img src="#doorHingeDetailsIm#" style="width:100%; max-width:200px;"></td></tr>'
          '<tr class="heading"><td> Cover caps of the door hinge</td><td> <br> </td></tr><tr class="details"><td> #coverCaps# </td></tr>', '');
    }
    if(dimensionSurfaceIm != null && dimensionSurfaceIm != ''){
      String imageBase64 = base64Encode(File(dimensionSurfaceIm).readAsBytesSync());
      htmlStr = htmlStr.replaceAll('#dimensionSurfaceIm#', 'data:image/png;base64, $imageBase64');
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Dimension Surface </td><td> <br></td></tr><tr class="details"><td> <img src="#dimensionSurfaceIm#" style="width:200%; max-width:400px;"></td></tr>', '');
    }
    if(hingeType=='Barrel hinge'){
      htmlStr = htmlStr.replaceAll('#doorLeafBarrel#', doorLeafBarrel);
      htmlStr = htmlStr.replaceAll('#doorFrame#', doorFrame);
      if(systemDoorLeaf != null && systemDoorLeaf !=''){
        htmlStr = htmlStr.replaceAll('#systemDoorLeaf#', systemDoorLeaf);
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> System </td><td> <br></td></tr><tr class="details"><td> #systemDoorLeaf# </td></tr>', '');
      }
      if(systemDoorFrame != null && systemDoorFrame !=''){
        htmlStr = htmlStr.replaceAll('#systemDoorFrame#', systemDoorFrame);
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> System </td><td> <br></td></tr><tr class="details"><td> #systemDoorFrame# </td></tr>', '');
      }
      if(dimensionBarrelIm != null && dimensionBarrelIm != ''){
        String imageBase64 = base64Encode(File(dimensionBarrelIm).readAsBytesSync());
        htmlStr = htmlStr.replaceAll('#dimensionBarrelIm#', 'data:image/png;base64, $imageBase64');
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Dimension Barrel </td><td> <br></td></tr>'
            '<tr class="details"><td> <img src="#dimensionBarrelIm#" style="width:200%; max-width:400px;"></td></tr>', '');
      }
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Door Leaf (mm) </td><td> <br></td></tr><tr class="details"><td> #doorLeafBarrel# </td></tr>'
          '<tr class="heading"><td> System </td><td> <br></td></tr><tr class="details"><td> #systemDoorLeaf# </td></tr>'
          '<tr class="heading"><td> Door frame (mm) </td><td> <br></td></tr><tr class="details"><td> #doorFrame# </td></tr>'
          '<tr class="heading"><td> System </td><td> <br></td></tr><tr class="details"><td> #systemDoorFrame# </td></tr>', '');
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Dimension Barrel </td><td> <br></td></tr>'
          '<tr class="details"><td> <img src="#dimensionBarrelIm#" style="width:200%; max-width:400px;"></td></tr>', '');
    }
    return htmlStr;
  }

  Future<String> pathSurfaceDetails() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "surfaceType${DateTime.now()}.png");
    ByteData data = await rootBundle.load("assets/surface${doorHingeDetailsIm.replaceAll('t', 'T')}.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return dbPath;
  }
}