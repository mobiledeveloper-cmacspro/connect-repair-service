import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';
import 'package:repairservices/Utils/extensions.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_hinge.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_lock.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_sliding.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
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
    _deleteController.sinkAddSafe(true);
  }

  @override
  void dispose() {
    _deleteController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
