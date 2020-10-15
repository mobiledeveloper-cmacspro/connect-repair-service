import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class QRScanWidgetBloC extends BaseBloC{

  BehaviorSubject<bool> _flashlightController = BehaviorSubject();

  Stream<bool> get flashlightStatus => _flashlightController.stream;

  void switchFlashlight(bool finalStatus) {
    _flashlightController.sink.add(finalStatus);
    print("Flashlight: $finalStatus");
  }

  @override
  void dispose() {
    _flashlightController.close();
  }
}