import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/models/Company.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableWindows (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnYear TEXT,
                $columnCreated TEXT,
                $columnNumber INTEGER,
                $columnSystemDepth TEXT,
                $columnProfileSystem TEXT,
                $columnDescription TEXT,
                $columnFilePath TEXT,
                $columnIsImage TEXT,
                $columnWindowsPDFPath TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableCompany (
                $columnCompanyId INTEGER PRIMARY KEY,
                $columnCompanyName TEXT NOT NULL,
                $columnAdditionalInf TEXT,
                $columnPhone TEXT,
                $columnEmail TEXT,
                $columnFax TEXT,
                $columnWebsite TEXT,
                $columnLogoPath TEXT,
                $columnStreet TEXT,
                $columnHouseNumber INTEGER,
                $columnExtraAddressLine TEXT,
                $columnPostCode INTEGER,
                $columnLat DOUBLE,
                $columnLng DOUBLE,
                $columnTextExportEmail TEXT,
                $columnDefaultC INTEGER not null,
                $columnLocation TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableProduct (
                $columnProductId INTEGER PRIMARY KEY,
                $columnShortText TEXT NOT NULL,
                $columnProductNumber TEXT NOT NULL,
                $columnProductUrl TEXT NOT NULL,
                $columnProductQuantity TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableProductInCart (
                $columnProductId INTEGER PRIMARY KEY,
                $columnShortText TEXT NOT NULL,
                $columnProductNumber TEXT NOT NULL,
                $columnProductUrl TEXT NOT NULL,
                $columnProductQuantity TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableDoorLock (
                $columnDoorLockId INTEGER PRIMARY KEY,
                $columnDoorLockName TEXT NOT NULL,
                $columnDoorLockYear TEXT,
                $columnDoorLockCreated TEXT,
                $columnDoorLockLogoVisible TEXT NOT NULL,
                $columnDoorLockProfile TEXT NOT NULL,
                $columnDoorLockProtection TEXT NOT NULL,
                $columnDoorLockBasicDepthDoor TEXT,
                $columnDoorLockOpeningDirection TEXT NOT NULL,
                $columnDoorLockLeafDoor TEXT NOT NULL,
                $columnDoorLockBolt TEXT,
                $columnDoorLockDinDirection TEXT NOT NULL,
                $columnDoorLockType TEXT NOT NULL,
                $columnDoorLockPanicFunction TEXT NOT NULL,
                $columnDoorLockSelfLocking TEXT,
                $columnDoorLockSecureLatchBoltStop TEXT,
                $columnDoorLockMonitoring TEXT,
                $columnDoorLockElectricStrike TEXT,
                $columnDoorLockDaytime TEXT,
                $columnDoorLockLockWithTopLocking TEXT NOT NULL,
                $columnDoorLockShootBoltLock TEXT,
                $columnDoorLockHandleHeight TEXT,
                $columnDoorLockDoorLeafHight TEXT,
                $columnDoorLockRestrictor TEXT,
                $columnDoorLockDimensionA TEXT,
                $columnDoorLockDimensionB TEXT,
                $columnDoorLockDimensionC TEXT,
                $columnDoorLockDimensionD TEXT,
                $columnDoorLockDimensionE TEXT,
                $columnDoorLockDimensionF TEXT,
                $columnDoorLockLockType TEXT NOT NULL,
                $columnDoorLockFacePlateType TEXT NOT NULL,
                $columnDoorLockFacePlateFixing TEXT NOT NULL,
                $columnDoorLockMultipointLocking TEXT,
                $columnDimensionImage1Path TEXT,
                $columnDimensionImage2Path TEXT,
                $columnDimensionImage3Path TEXT,
                $columnDoorLockPDFPath TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableDoorHinge (
                $columnDoorHingeId INTEGER PRIMARY KEY,
                $columnDoorHingeName TEXT NOT NULL,
                $columnDoorHingeYear TEXT,
                $columnDoorHingeCreated TEXT,
                $columnDoorHingeBasicDepthOfDoor TEXT NOT NUll,
                $columnDoorHingeSystemHinge TEXT NOT NULL,
                $columnDoorHingeMaterial TEXT NOT NULL,
                $columnDoorHingeThermally TEXT NOT NULL,
                $columnDoorHingeDoorOpening TEXT NOT NULL,
                $columnDoorHingeFitted TEXT NOT NULL,
                $columnDoorHingeHingeType TEXT NOT NULL,
                $columnDoorHingeDoorHingeDetailsIm TEXT,
                $columnDoorHingeCoverCaps TEXT,
                $columnDoorHingeDoorLeafBarrel TEXT,
                $columnDoorHingeSystemDoorLeaf TEXT,
                $columnDoorHingeDoorFrame TEXT,
                $columnDoorHingeSystemDoorFrames TEXT,
                $columnDoorHingeDimensionsSurfaceA TEXT,
                $columnDoorHingeDimensionsSurfaceB TEXT,
                $columnDoorHingeDimensionsSurfaceC TEXT,
                $columnDoorHingeDimensionsSurfaceD TEXT,
                $columnDoorHingeDimensionSurfaceIm TEXT,
                $columnDoorHingeDimensionsBarrelA TEXT,
                $columnDoorHingeDimensionsBarrelB TEXT,
                $columnDoorHingeDimensionBarrelIm TEXT,
                $columnDoorHingePDFPath TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableSliding (
                $columnSlidingId INTEGER PRIMARY KEY,
                $columnSlidingName TEXT NOT NULL,
                $columnSlidingYear TEXT,
                $columnSlidingCreated TEXT,
                $columnSlidingManufacturer TEXT,
                $columnSlidingDirectionOpening TEXT NOT NULL,
                $columnSlidingMaterial TEXT NOT NULL,
                $columnSlidingSystem TEXT,
                $columnSlidingVentOverlap TEXT NOT NULL,
                $columnSlidingTiltSlide TEXT NOT NULL,
                $columnSlidingComponents TEXT,
                $columnSlidingDimensionA TEXT,
                $columnSlidingDimensionB TEXT,
                $columnSlidingDimensionC TEXT,
                $columnSlidingDimensionD TEXT,
                $columnSlidingDimensionImagePath1 TEXT,
                $columnSlidingPDFPath TEXT
              )
              ''');
  }

  // Database helper methods:

  // Insert Article Windows
  Future<int> insert(Windows windows) async {
    Database db = await database;
    int id = await db.insert(tableWindows, windows.toMap());
    return id;
  }
  // Get Article Windows by Id
  Future<Windows> queryWindows(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableWindows,
        columns: [columnId, columnName, columnCreated, columnNumber, columnSystemDepth, columnProfileSystem, columnDescription],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Windows.fromMap(maps.first);
    }
    return null;
  }
  //Get All Article Windows
  Future<List<Windows>> queryAllWindows() async {
    Database db = await database;
    List<Map> result = await db.query(tableWindows);
    // print the results
    List<Windows> list = new List();

    for(final row in result){
      list.add(Windows.fromMap(row));
    }
    return list;
  }
  //Update Windows Fitting
  Future<int> updateWindows(Windows windows) async {
    Database db = await database;
    return await db.update(tableWindows, windows.toMap(),
        where: '$columnId = ?', whereArgs: [windows.id]);
  }

  //Delete Windows
  Future<int> deleteWindows(int id) async {
    Database db = await database;
    return await db.delete(tableWindows, where: '$columnId = ?', whereArgs: [id]);
  }


  // Insert Company Profile
  Future<int> insertCompany(Company company) async {
    Database db = await database;
    int id = await db.insert(tableCompany, company.toMap());
    return id;
  }

  // Get Company by Id
  Future<Company> queryCompany(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCompany,
        columns: [columnCompanyName, columnAdditionalInf, columnPhone, columnEmail, columnFax, columnWebsite, columnLogoPath, columnStreet, columnHouseNumber, columnExtraAddressLine, columnPostCode, columnLat, columnLng, columnTextExportEmail, columnDefaultC],
        where: '$columnCompanyId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Company.fromMap(maps.first);
    }
    return null;
  }
  //Get All Companys
  Future<List<Company>> queryAllCompany() async {
    Database db = await database;
    List<Map> result = await db.query(tableCompany);
    // print the results
    List<Company> list = new List();

    for(final row in result){
      list.add(Company.fromMap(row));
    }
    return list;
  }
  //Update Company
  Future<int> updateCompany(Company company) async {
    Database db = await database;
    return await db.update(tableCompany, company.toMap(),
        where: '$columnCompanyId = ?', whereArgs: [company.id]);
  }
  //Delete Company
  Future<int> deleteCompany(int id) async {
    Database db = await database;
    return await db.delete(tableCompany, where: '$columnCompanyId = ?', whereArgs: [id]);
  }

  // Insert Product
  Future<int> insertProduct(Product product, bool existInCart) async {
    debugPrint('inserting Product with name: ${product.shortText.value}');
    Database db = await database;
    int id = await db.insert(!existInCart ? tableProduct : tableProductInCart, product.toMap());
    return id;
  }

  //Get All Article Products
  Future<List<Product>> queryAllProducts(bool existInCart) async {
    Database db = await database;
    List<Map> result = await db.query(!existInCart ? tableProduct : tableProductInCart);
    // print the results
    List<Product> list = new List();

    for(final row in result){
      list.add(Product.fromMap(row));
    }
    return list;
  }

  //Delete Product
  Future<int> deleteProduct(int id, bool existInCart) async {
    Database db = await database;
    return await db.delete(!existInCart ? tableProduct : tableProductInCart, where: '$columnProductId = ?', whereArgs: [id]);
  }
  //Update products
  Future<int> updateProduct(Product product, bool existInCart) async {
    debugPrint('updating product in Cart');
    Database db = await database;
    return await db.update(!existInCart ? tableProduct : tableProductInCart, product.toMap(),
        where: '$columnProductId = ?', whereArgs: [product.id]);
  }

  // Insert Article DoorLock
  Future<int> insertDoorLock(DoorLock doorLock) async {
    Database db = await database;
    int id = await db.insert(tableDoorLock, doorLock.toMap());
    return id;
  }
  // Get Article DoorLock by Id
  Future<DoorLock> queryDoorLock(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableDoorLock,
        columns: [columnId, columnDoorLockName,columnDoorLockCreated,columnDoorLockYear, columnDoorLockLogoVisible, columnDoorLockProfile,
          columnDoorLockProtection, columnDoorLockBasicDepthDoor, columnDoorLockOpeningDirection, columnDoorLockLeafDoor, columnDoorLockBolt,
          columnDoorLockDinDirection, columnDoorLockType, columnDoorLockPanicFunction, columnDoorLockSelfLocking,
          columnDoorLockSecureLatchBoltStop, columnDoorLockMonitoring, columnDoorLockElectricStrike, columnDoorLockDaytime,
          columnDoorLockLockWithTopLocking, columnDoorLockShootBoltLock, columnDoorLockHandleHeight, columnDoorLockDoorLeafHight,
          columnDoorLockRestrictor, columnDoorLockLockType, columnDoorLockFacePlateType, columnDoorLockFacePlateFixing, columnDoorLockMultipointLocking,
          columnDoorLockDimensionA, columnDoorLockDimensionB, columnDoorLockDimensionC, columnDoorLockDimensionD, columnDoorLockDimensionE,
          columnDoorLockDimensionF, columnDimensionImage1Path, columnDimensionImage2Path, columnDimensionImage3Path],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return DoorLock.fromMap(maps.first);
    }
    return null;
  }
  //Get All Article DoorLock
  Future<List<DoorLock>> queryAllDoorLock() async {
    Database db = await database;
    List<Map> result = await db.query(tableDoorLock);
    // print the results
    List<DoorLock> list = new List();

    for(final row in result){
      list.add(DoorLock.fromMap(row));
    }
    return list;
  }
  //Update DoorLock Fitting
  Future<int> updateDoorLock(DoorLock doorLock) async {
    Database db = await database;
    return await db.update(tableDoorLock, doorLock.toMap(),
        where: '$columnId = ?', whereArgs: [doorLock.id]);
  }

  //Delete DoorLock
  Future<int> deleteDoorLock(int id) async {
    Database db = await database;
    return await db.delete(tableDoorLock, where: '$columnId = ?', whereArgs: [id]);
  }
  //-----------------------------------------------
  // Insert Article DoorHinge
  Future<int> insertDoorHinge(DoorHinge doorHinge) async {
    Database db = await database;
    int id = await db.insert(tableDoorHinge, doorHinge.toMap());
    return id;
  }
  // Get Article DoorHinge by Id
  Future<DoorHinge> queryDoorHinge(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableDoorHinge,
        columns: [columnDoorHingeId, columnDoorHingeName, columnDoorHingeYear, columnDoorHingeCreated, columnDoorHingeBasicDepthOfDoor,
          columnDoorHingeSystemHinge, columnDoorHingeMaterial, columnDoorHingeThermally, columnDoorHingeDoorOpening, columnDoorHingeFitted,
          columnDoorHingeHingeType, columnDoorHingeDoorHingeDetailsIm, columnDoorHingeCoverCaps, columnDoorHingeDoorLeafBarrel,
          columnDoorHingeSystemDoorLeaf, columnDoorHingeDoorFrame, columnDoorHingeSystemDoorFrames, columnDoorHingeDimensionsSurfaceA,
          columnDoorHingeDimensionsSurfaceB, columnDoorHingeDimensionsSurfaceC, columnDoorHingeDimensionsSurfaceD, columnDoorHingeDimensionSurfaceIm,
          columnDoorHingeDimensionsBarrelA , columnDoorHingeDimensionsBarrelB , columnDoorHingeDimensionBarrelIm],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return DoorHinge.fromMap(maps.first);
    }
    return null;
  }
  //Get All Article DoorHinge
  Future<List<DoorHinge>> queryAllDoorHinge() async {
    Database db = await database;
    List<Map> result = await db.query(tableDoorHinge);
    // print the results
    List<DoorHinge> list = new List();

    for(final row in result){
      list.add(DoorHinge.fromMap(row));
    }
    return list;
  }
  //Update DoorHinge Fitting
  Future<int> updateDoorHinge(DoorHinge doorHinge) async {
    Database db = await database;
    return await db.update(tableDoorHinge, doorHinge.toMap(),
        where: '$columnId = ?', whereArgs: [doorHinge.id]);
  }

  //Delete DoorLock
  Future<int> deleteDoorHinge(int id) async {
    Database db = await database;
    return await db.delete(tableDoorHinge, where: '$columnId = ?', whereArgs: [id]);
  }
  //-----------------------------------------------
  // Insert Article Sliding
  Future<int> insertSliding(Sliding sliding) async {
    Database db = await database;
    int id = await db.insert(tableSliding, sliding.toMap());
    return id;
  }
  // Get Article Sliding by Id
  Future<Sliding> querySliding(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableSliding,
        columns: [columnSlidingId, columnSlidingName, columnSlidingYear, columnSlidingCreated,columnSlidingManufacturer,
          columnSlidingDirectionOpening,columnSlidingMaterial,columnSlidingSystem,columnSlidingVentOverlap,columnSlidingTiltSlide,
          columnSlidingComponents,columnSlidingDimensionA ,columnSlidingDimensionB ,columnSlidingDimensionC,columnSlidingDimensionD,
          columnSlidingDimensionImagePath1],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Sliding.fromMap(maps.first);
    }
    return null;
  }
  //Get All Article Sliding
  Future<List<Sliding>> queryAllSliding() async {
    Database db = await database;
    List<Map> result = await db.query(tableSliding);
    // print the results
    List<Sliding> list = new List();

    for(final row in result){
      list.add(Sliding.fromMap(row));
    }
    return list;
  }
  //Update Sliding Fitting
  Future<int> updateSliding(Sliding sliding) async {
    Database db = await database;
    return await db.update(tableSliding, sliding.toMap(),
        where: '$columnId = ?', whereArgs: [sliding.id]);
  }

  //Delete Sliding
  Future<int> deleteSliding(int id) async {
    Database db = await database;
    return await db.delete(tableSliding, where: '$columnId = ?', whereArgs: [id]);
  }
}