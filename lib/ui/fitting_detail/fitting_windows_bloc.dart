import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';
import 'package:repairservices/Utils/extensions.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_hinge.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_lock.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_sliding.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:rxdart/subjects.dart';

class FittingWindowsBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<bool> _deleteController = new BehaviorSubject();

  Stream<bool> get deleteResult => _deleteController.stream;

  void delete(Fitting model) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    if (model is Windows) {
      await helper.deleteWindows(model.id);
      await PDFManagerWindow.removePDF(model);
    } else if (model is Sliding) {
      await helper.deleteSliding(model.id);
      await PDFManagerSliding.removePDF(model);
    } else if (model is DoorLock) {
      await helper.deleteDoorLock(model.id);
      await PDFManagerDoorLock.removePDF(model);
    } else if (model is DoorHinge) {
      await helper.deleteDoorHinge(model.id);
      await PDFManagerDoorHinge.removePDF(model);
    }

    _deleteImages(model);
    _deleteController.sinkAddSafe(true);
  }

  Future<void> _deleteImages(Fitting model) async {
    if(model is DoorHinge) {
      List<String> files = [
        model.dimensionSurfaceIm,
        model.dimensionBarrelIm,
      ];
      files.forEach((element) {
        File f = File(element ?? '');
        if(f.existsSync()) {
          f.deleteSync();
        }
      });
    } else if(model is DoorLock) {
      List<String> files = [
        model.dimensionImage1Path,
        model.dimensionImage2Path,
        model.dimensionImage3Path
      ];
      files.forEach((element) {
        File f = File(element ?? '');
        if(f.existsSync()) {
          f.deleteSync();
        }
      });
    }
  }

  String getDirectionOpening(String type) {
    String res = '';
    if (type.contains("1"))
      res = R.image.slidingDirectionOpening1;
    else if (type.contains("2"))
      res = R.image.slidingDirectionOpening2;
    else if (type.contains("3"))
      res = R.image.slidingDirectionOpening3;
    else if (type.contains("4")) res = R.image.slidingDirectionOpening4;
    return res;
  }

  String getLockType(String type) {
    String res = '';
    if (type.contains("1"))
      res = R.image.lockType1;
    else if (type.contains("2"))
      res = R.image.lockType2;
    else if (type.contains("3"))
      res = R.image.lockType3;
    else if (type.contains("4")) res = R.image.lockType4;
    return res;
  }

  String getFacePlateType(String type) {
    String res = '';
    if (type.contains("1"))
      res = R.image.facePlateType1;
    else if (type.contains("2"))
      res = R.image.facePlateType2;
    else if (type.contains("3"))
      res = R.image.facePlateType3;
    else if (type.contains("4")) res = R.image.facePlateType4;
    return res;
  }

  String getFacePlateMixing(String type) {
    String res = '';
    if (type.contains("1"))
      res = R.image.facePlateFixing1;
    else if (type.contains("2"))
      res = R.image.facePlateFixing2;
    return res;
  }

  String getSurfaceType(String type){
    String res = '';
    if (type.contains("1"))
      res = R.image.surfaceType1;
    else if (type.contains("2"))
      res = R.image.surfaceType2;
    else if (type.contains("3"))
      res = R.image.surfaceType3;
    else if (type.contains("4"))
      res = R.image.surfaceType4;
    else if (type.contains("5"))
      res = R.image.surfaceType5;
    return res;
  }



  @override
  void dispose() {
    _deleteController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
