import 'dart:io';

import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_bloc.dart';
import 'package:rxdart/subjects.dart';

class DrawerContainerBloC extends BaseBloC {

  String screenShotFile;

  //File
  BehaviorSubject<File> _selectedImageController = BehaviorSubject();
  File get selectedImage => _selectedImageController.value;
  Stream<File> get selectedImageStream => _selectedImageController.stream;
  set selectedImage(File image){
    _selectedImageController.sink.add(image);
  }


  //ScreenShot
  BehaviorSubject<bool> _savingScreenShotController =
      BehaviorSubject.seeded(false);
  bool get savingScreenShot => _savingScreenShotController.value;
  Stream<bool> get savingScreenShotStream => _savingScreenShotController.stream;
  set savingScreenShot(bool savingScreenShot){
    _savingScreenShotController.sink.add(savingScreenShot);
  }

  //ViewMode
  BehaviorSubject<ViewMode> _viewModeController = BehaviorSubject.seeded(ViewMode.NOTHING);
  ViewMode get viewMode => _viewModeController.value;
  Stream<ViewMode> get viewModeStream => _viewModeController.stream;
  set viewMode(ViewMode vm){
    _viewModeController.sink.add(vm);
  }


  @override
  void dispose() {
    _savingScreenShotController.close();
    _viewModeController.close();
    _selectedImageController.close();
  }
}

//enum ViewMode {
//  NOTHING,
//  ADD,
//  COLOR,
//}
