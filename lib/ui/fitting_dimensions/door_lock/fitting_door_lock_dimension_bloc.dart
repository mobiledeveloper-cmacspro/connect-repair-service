import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:repairservices/Utils/extensions.dart';

class FittingDoorLockDimensionBloC extends BaseBloC {
  BehaviorSubject<int> _pageIndicatorController = new BehaviorSubject();

  Stream<int> get pageIndicatorResult => _pageIndicatorController.stream;

  int currentPage = 1;
  double get heightArea => 400;
  double get widthArea => 300;

  set setIndicatorPage(int page) {
    currentPage = page;
    _pageIndicatorController.sinkAddSafe(page);
  }


  @override
  void dispose() {
    _pageIndicatorController.close();
  }
}
