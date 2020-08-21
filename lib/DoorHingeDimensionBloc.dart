import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class DoorHingeDimensionBloc extends BaseBloC{

  BehaviorSubject<String> _dimACtr = BehaviorSubject();
  Stream<String> get dimAStream => _dimACtr.stream;

  BehaviorSubject<String> _dimBCtr = BehaviorSubject();
  Stream<String> get dimBStream => _dimBCtr.stream;

  BehaviorSubject<String> _dimCCtr = BehaviorSubject();
  Stream<String> get dimCStream => _dimCCtr.stream;


  void dimA(String value) {
    _dimACtr.sink.add(value);
  }

  void dimB(String value) {
    _dimBCtr.sink.add(value);
  }

  void dimC(String value) {
    _dimCCtr.sink.add(value);
  }

  @override
  void dispose() {
    _dimACtr.close();
    _dimBCtr.close();
    _dimCCtr.close();
  }

}