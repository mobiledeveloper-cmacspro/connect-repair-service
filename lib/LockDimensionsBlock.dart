

import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class LockDimensionsBloc extends BaseBloC {

  BehaviorSubject<String> _dimACtr = BehaviorSubject();
  Stream<String> get dimAStream => _dimACtr.stream;

  BehaviorSubject<String> _dimBCtr = BehaviorSubject();
  Stream<String> get dimBStream => _dimBCtr.stream;

  BehaviorSubject<String> _dimCCtr = BehaviorSubject();
  Stream<String> get dimCStream => _dimCCtr.stream;

  BehaviorSubject<String> _dimDCtr = BehaviorSubject();
  Stream<String> get dimDStream => _dimDCtr.stream;

  BehaviorSubject<String> _dimECtr = BehaviorSubject();
  Stream<String> get dimEStream => _dimECtr.stream;

  BehaviorSubject<String> _dimFCtr = BehaviorSubject();
  Stream<String> get dimFStream => _dimFCtr.stream;

  BehaviorSubject<int> _pageIndexCtr = BehaviorSubject();
  Stream<int> get pageIndexStream => _pageIndexCtr.stream;

  BehaviorSubject<bool> _pagesVisitedCtr = BehaviorSubject();
  Stream<bool> get pagesVisitedStream => _pagesVisitedCtr.stream;

  void pagesVisited(bool value) {
    _pagesVisitedCtr.sink.add(value);
  }

  void pageIndex(int idx) {
    _pageIndexCtr.sink.add(idx);
  }

  void dimA({String dim = ''}){
    _dimACtr.sink.add(dim);
  }

  void dimB({String dim = ''}){
    _dimBCtr.sink.add(dim);
  }

  void dimC({String dim = ''}){
    _dimCCtr.sink.add(dim);
  }

  void dimD({String dim = ''}){
    _dimDCtr.sink.add(dim);
  }

  void dimE({String dim = ''}){
    _dimECtr.sink.add(dim);
  }

  void dimF({String dim = ''}){
    _dimFCtr.sink.add(dim);
  }


  @override
  void dispose() {
    _dimACtr.close();
    _dimBCtr.close();
    _dimCCtr.close();
    _dimDCtr.close();
    _dimECtr.close();
    _dimFCtr.close();
    _pageIndexCtr.close();
    _pagesVisitedCtr.close();
  }

}