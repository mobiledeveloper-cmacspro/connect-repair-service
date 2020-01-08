// database table and column names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:path/path.dart';
import 'package:repairservices/models/Company.dart';

final String tableDoorLock = 'doorlock';
final String columnDoorLockId = '_id';
final String columnDoorLockName = 'name';
final String columnDoorLockYear = 'year';
final String columnDoorLockCreated = 'created';
final String columnDoorLockLogoVisible = 'logoVisible';
final String columnDoorLockProfile = 'profile';
final String columnDoorLockProtection = 'protection';
final String columnDoorLockBasicDepthDoor = 'basicDepthDoor';
final String columnDoorLockOpeningDirection = 'openingDirection';
final String columnDoorLockLeafDoor = 'leafDoor';
final String columnDoorLockBolt = 'bolt';
final String columnDoorLockDinDirection = 'dinDirection';
final String columnDoorLockType = 'type';
final String columnDoorLockPanicFunction = 'panicFunction';
final String columnDoorLockSelfLocking= 'selfLocking';
final String columnDoorLockSecureLatchBoltStop = 'secureLatchBoltStop';
final String columnDoorLockMonitoring= 'monitoring';
final String columnDoorLockElectricStrike = 'electricStrike';
final String columnDoorLockDaytime = 'daytime';
final String columnDoorLockLockWithTopLocking = 'lockWithTopLocking';
final String columnDoorLockShootBoltLock = 'shootBoltLock';
final String columnDoorLockHandleHeight = 'handleHeight';
final String columnDoorLockDoorLeafHight = 'doorLeafHight';
final String columnDoorLockRestrictor = 'restrictor';
final String columnDoorLockLockType = 'lockType';
final String columnDoorLockFacePlateType = 'facePlateType';
final String columnDoorLockFacePlateFixing = 'facePlateFixing';
final String columnDoorLockMultipointLocking = 'multipointLocking';
final String columnDoorLockDimensionA = 'dimensionA';
final String columnDoorLockDimensionB = 'dimensionB';
final String columnDoorLockDimensionC = 'dimensionC';
final String columnDoorLockDimensionD = 'dimensionD';
final String columnDoorLockDimensionE = 'dimensionE';
final String columnDoorLockDimensionF = 'dimensionF';
final String columnDimensionImage1Path = 'dimensionImage1Path';
final String columnDimensionImage2Path = 'dimensionImage2Path';
final String columnDimensionImage3Path = 'dimensionImage3Path';
final String columnDoorLockPDFPath = 'pdfPath';

// data model class
class DoorLock extends Fitting {
  String logoVisible,profile,protection,basicDepthDoor,openingDirection,leafDoor,bolt,dinDirection,type,panicFunction,selfLocking,
      secureLatchBoltStop,monitoring,electricStrike,daytime,lockWithTopLocking,shootBoltLock,handleHeight,doorLeafHight,restrictor,lockType,
      facePlateType,facePlateFixing,multipointLocking,dimensionA,dimensionB,dimensionC,dimensionD,dimensionE,dimensionF,dimensionImage1Path,
      dimensionImage2Path,dimensionImage3Path;
  DoorLock();

  // convenience constructor to create a Door object
  DoorLock.withData(String name, DateTime created, String dimensionA,String dimensionB,String dimensionC,String dimensionD,
      String dimensionE,String dimensionF, String dimensionImage1Path, String dimensionImage2Path,String dimensionImage3Path) {
    this.name = name;
    this.created = created;
    this.dimensionA = dimensionA;
    this.dimensionB = dimensionB;
    this.dimensionC = dimensionC;
    this.dimensionD = dimensionD;
    this.dimensionE = dimensionE;
    this.dimensionF = dimensionF;
    this.dimensionImage1Path = dimensionImage1Path;
    this.dimensionImage2Path = dimensionImage2Path;
    this.dimensionImage3Path = dimensionImage3Path;
  }

  DoorLock.fromMap(Map<String, dynamic> map) {
    id = map[columnDoorLockId];
    name = map[columnDoorLockName];
    year = map[columnDoorLockYear];
    String createdStr = map[columnDoorLockCreated];
    created = DateTime.parse(createdStr);
    logoVisible = map[columnDoorLockLogoVisible];
    profile = map[columnDoorLockProfile];
    protection = map[columnDoorLockProtection];
    basicDepthDoor = map[columnDoorLockBasicDepthDoor];
    openingDirection = map[columnDoorLockOpeningDirection];
    leafDoor = map[columnDoorLockLeafDoor];
    bolt = map[columnDoorLockBolt];
    dinDirection = map[columnDoorLockDinDirection];
    type = map[columnDoorLockType];
    panicFunction = map[columnDoorLockPanicFunction];
    selfLocking = map[columnDoorLockSelfLocking];
    secureLatchBoltStop = map[columnDoorLockSecureLatchBoltStop];
    monitoring = map[columnDoorLockMonitoring];
    electricStrike = map[columnDoorLockElectricStrike];
    daytime = map[columnDoorLockDaytime];
    lockWithTopLocking = map[columnDoorLockLockWithTopLocking];
    shootBoltLock = map[columnDoorLockShootBoltLock];
    handleHeight = map[columnDoorLockHandleHeight];
    doorLeafHight = map[columnDoorLockDoorLeafHight];
    restrictor = map[columnDoorLockRestrictor];
    lockType = map[columnDoorLockLockType];
    facePlateType = map[columnDoorLockFacePlateType];
    facePlateFixing = map[columnDoorLockFacePlateFixing];
    multipointLocking = map[columnDoorLockMultipointLocking];
    dimensionA = map[columnDoorLockDimensionA];
    dimensionB = map[columnDoorLockDimensionB];
    dimensionC = map[columnDoorLockDimensionC];
    dimensionD = map[columnDoorLockDimensionD];
    dimensionE = map[columnDoorLockDimensionE];
    dimensionF = map[columnDoorLockDimensionF];
    dimensionImage1Path = map[columnDimensionImage1Path];
    dimensionImage3Path = map[columnDimensionImage2Path];
    dimensionImage3Path = map[columnDimensionImage3Path];
    pdfPath = map[columnDoorLockPDFPath];
  }

  // convenience method to create a Map from this Door object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDoorLockName: name,
      columnDoorLockCreated: created.toIso8601String(),
      columnDoorLockYear: year,
      columnDoorLockLogoVisible: logoVisible,
      columnDoorLockProfile: profile,
      columnDoorLockProtection: protection,
      columnDoorLockBasicDepthDoor: basicDepthDoor,
      columnDoorLockOpeningDirection: openingDirection,
      columnDoorLockLeafDoor: leafDoor,
      columnDoorLockBolt: bolt,
      columnDoorLockDinDirection: dinDirection,
      columnDoorLockType: type,
      columnDoorLockPanicFunction: panicFunction,
      columnDoorLockSelfLocking: selfLocking,
      columnDoorLockSecureLatchBoltStop: secureLatchBoltStop,
      columnDoorLockMonitoring: monitoring,
      columnDoorLockElectricStrike: electricStrike,
      columnDoorLockDaytime: daytime,
      columnDoorLockLockWithTopLocking: lockWithTopLocking,
      columnDoorLockShootBoltLock: shootBoltLock,
      columnDoorLockHandleHeight: handleHeight,
      columnDoorLockDoorLeafHight: doorLeafHight,
      columnDoorLockRestrictor: restrictor,
      columnDoorLockLockType: lockType,
      columnDoorLockFacePlateType: facePlateType,
      columnDoorLockFacePlateFixing: facePlateFixing,
      columnDoorLockMultipointLocking: multipointLocking,
      columnDoorLockDimensionA: dimensionA,
      columnDoorLockDimensionB: dimensionB,
      columnDoorLockDimensionC: dimensionC,
      columnDoorLockDimensionD: dimensionD,
      columnDoorLockDimensionE: dimensionE,
      columnDoorLockDimensionF: dimensionF,
      columnDimensionImage1Path: dimensionImage1Path,
      columnDimensionImage2Path: dimensionImage2Path,
      columnDimensionImage3Path: dimensionImage3Path,
      columnDoorLockPDFPath: pdfPath
    };
    if (id != null) {
      map[columnDoorLockId] = id;
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
//    htmlStr = htmlStr.replaceAll('#LOGO_IMAGE#', 'file://'+dbPath);
    String logoBase64Image = base64Encode(bytes);
    htmlStr = htmlStr.replaceAll('#LOGO_IMAGE#', 'data:image/png;base64, $logoBase64Image');
    htmlStr = htmlStr.replaceAll("#CREATED#", created.month.toString() + '/' + created.day.toString() + '/' + created.year.toString());
    if (Company.currentCompany != null){
      htmlStr = htmlStr.replaceAll('#COMPANYPROFILE#', Company.currentCompany.htmlLayoutPreview());
    }
    else {
      htmlStr = htmlStr.replaceAll('#COMPANYPROFILE#', '');
    }
    String lockTypeBase64 = base64Encode(File(await pathLockType()).readAsBytesSync());
    htmlStr = htmlStr.replaceAll('#lockType#', 'data:image/png;base64, $lockTypeBase64');

    String facePlateTypeBase64 = base64Encode(File(await pathFacePlateType()).readAsBytesSync());
    htmlStr = htmlStr.replaceAll('#facePlateType#', 'data:image/png;base64, $facePlateTypeBase64');

    String facePlateFixingBase64 = base64Encode(File(await pathFacePlateFixing()).readAsBytesSync());
    htmlStr = htmlStr.replaceAll('#facePlateFixing#', 'data:image/png;base64, $facePlateFixingBase64');

    if(multipointLocking != null && multipointLocking != ''){
      String imageBase64 = base64Encode(File(await pathMultipointLocking()).readAsBytesSync());
      htmlStr = htmlStr.replaceAll('#multipointLocking#', 'data:image/png;base64, $imageBase64');
    }
    else {
      htmlStr = htmlStr.replaceAll('<td style="text-align: center;"> Multi-point locking </td>', '');
      htmlStr = htmlStr.replaceAll('<td style="text-align: center;"> <img src="#multipointLocking#" style="width:100%; max-width:30px;"></td>', '');
    }
    if(dimensionImage1Path != null && dimensionImage1Path != ''){
      String imageBase64 = base64Encode(File(dimensionImage1Path).readAsBytesSync());
      htmlStr = htmlStr.replaceAll('#DIMENSIONIMAGE1#', 'data:image/png;base64, $imageBase64');
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr><td class="title"><div><img src="#DIMENSIONIMAGE1#" style="width:300%; max-width:300px;position: relative;"></div><td></tr>', '');
    }
    if(dimensionImage2Path != null && dimensionImage2Path != ''){
      String imageBase64 = base64Encode(File(dimensionImage2Path).readAsBytesSync());
      htmlStr = htmlStr.replaceAll('#DIMENSIONIMAGE2#', 'data:image/png;base64, $imageBase64');
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr><td class="title"><div><img src="#DIMENSIONIMAGE2#" style="width:300%; max-width:300px;position: relative;"></div><td></tr>', '');
    }
    if(dimensionImage3Path != null && dimensionImage3Path != ''){
      String imageBase64 = base64Encode(File(dimensionImage3Path).readAsBytesSync());
      htmlStr = htmlStr.replaceAll('#DIMENSIONIMAGE3#', 'data:image/png;base64, $imageBase64');
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr><td class="title"><div><img src="#DIMENSIONIMAGE3#" style="width:300%; max-width:300px;position: relative;"></div><td></tr>', '');
    }

    htmlStr = htmlStr.replaceAll('#logoVisible#', logoVisible);
    if(year != null && year !=''){
      htmlStr = htmlStr.replaceAll('#year#', year);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Year of manufacturing </td><td> <br></td></tr><tr class="details"><td> #year# </td></tr>', '');
    }
    htmlStr = htmlStr.replaceAll('#profile#', profile);
    htmlStr = htmlStr.replaceAll('#protection#', protection);
    if(basicDepthDoor != null && basicDepthDoor != ''){
      htmlStr = htmlStr.replaceAll('#basicDepthDoor#', basicDepthDoor);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Basic depth of door profile (mm) </td><td> <br></td></tr><tr class="details"><td> #basicDepthDoor# </td></tr>', '');
    }

    htmlStr = htmlStr.replaceAll('#openingDirection#', openingDirection);
    htmlStr = htmlStr.replaceAll('#leafDoor#', leafDoor);
    if(leafDoor == 'Double-leaf door' && bolt != null && bolt != ''){
      htmlStr = htmlStr.replaceAll('#bolt#', bolt);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Bolt </td><td> <br></td></tr><tr class="details"><td> #bolt# </td></tr>', '');
    }

    htmlStr = htmlStr.replaceAll('#dinDirection#', dinDirection);
    htmlStr = htmlStr.replaceAll('#type#', type);
    htmlStr = htmlStr.replaceAll('#panicFunction#', panicFunction);

    if(selfLocking != null && selfLocking !=''){
      htmlStr = htmlStr.replaceAll('#selfLocking#', selfLocking);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Self-Locking </td><td> <br></td></tr><tr class="details"><td> #selfLocking# </td></tr>', '');
    }
    if(secureLatchBoltStop != null && secureLatchBoltStop != ''){
      htmlStr = htmlStr.replaceAll('#secureLatchBoltStop#', secureLatchBoltStop);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Secure latch bolt stop </td><td> <br></td></tr><tr class="details"><td> #secureLatchBoltStop#</td></tr>', '');
    }
    if (monitoring != null && monitoring !=''){
      htmlStr = htmlStr.replaceAll('#monitoring#', monitoring);
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Monitoring </td><td> <br></td></tr><tr class="details"><td> #monitoring# </td>', '');
    }
    if(electricStrike != null && electricStrike != ''){
      htmlStr = htmlStr.replaceAll('#electricStrike#', electricStrike);
      if (electricStrike == 'Yes' && daytime != null && daytime != ''){
        htmlStr = htmlStr.replaceAll('#daytime#', daytime);
      }
      else{
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Daytime setting </td><td> <br></td></tr><tr class="details"><td> #daytime# </td></tr>', '');
      }
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Electric strike </td><td> <br></td></tr><tr class="details"><td> #electricStrike# </td></tr>', '');
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Daytime setting </td><td> <br></td></tr><tr class="details"><td> #daytime# </td></tr>', '');
    }
    htmlStr = htmlStr.replaceAll('#lockWithTopLocking#', lockWithTopLocking);
    if(lockWithTopLocking == 'Yes'){
      if(shootBoltLock != null && shootBoltLock !=''){
        htmlStr = htmlStr.replaceAll('#shootBoltLock#', shootBoltLock);
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Shoot bolt lock </td><td> <br></td></tr><tr class="details"><td> #shootBoltLock# </td></tr>', '');
      }
      if(handleHeight != null && handleHeight != ''){
        htmlStr = htmlStr.replaceAll('#handleHeight#', handleHeight);
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Handle height </td><td> <br></td></tr><tr class="details"><td> #handleHeight# </td></tr>', '');
      }
      if(doorLeafHight != null && doorLeafHight != ''){
        htmlStr = htmlStr.replaceAll('#doorLeafHight#', doorLeafHight);
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Door leaf height </td><td> <br></td></tr><tr class="details"><td> #doorLeafHight# </td></tr>', '');
      }
      if(restrictor != null && restrictor != ''){
        htmlStr = htmlStr.replaceAll('#$restrictor#', restrictor);
      }
      else {
        htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Restrictor </td><td> <br></td></tr><tr class="details"><td> #restrictor# </td></tr>', '');
      }
    }
    else {
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Shoot bolt lock </td><td> <br></td></tr><tr class="details"><td> #shootBoltLock# </td></tr>', '');
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Handle height </td><td> <br></td></tr><tr class="details"><td> #handleHeight# </td></tr>', '');
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Door leaf height </td><td> <br></td></tr><tr class="details"><td> #doorLeafHight# </td></tr>', '');
      htmlStr = htmlStr.replaceAll('<tr class="heading"><td> Restrictor </td><td> <br></td></tr><tr class="details"><td> #restrictor# </td></tr>', '');
    }
    return htmlStr;
  }


  Future<String> pathLockType() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "lockType${DateTime.now()}.png");
    ByteData data = await rootBundle.load("assets/lock${lockType.replaceAll('t', 'T')}.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return dbPath;
  }
  Future<String> pathFacePlateType() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "facePlateType${DateTime.now()}.png");
    ByteData data = await rootBundle.load("assets/facePlate${facePlateType.replaceAll('t', 'T')}.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return dbPath;
  }
  Future<String> pathFacePlateFixing() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "facePlateFixing${DateTime.now()}.png");
    ByteData data = await rootBundle.load("assets/facePlateFixing${facePlateFixing.replaceAll('type', '')}.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return dbPath;
  }
  Future<String> pathMultipointLocking() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "multipointLocking${DateTime.now()}.png");
    ByteData data = await rootBundle.load("assets/multipointLocking${multipointLocking.replaceAll('type', '')}.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return dbPath;
  }
}