

import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class LoginIconBloc extends BaseBloC{

  static BehaviorSubject<bool> _loggedIn = new BehaviorSubject();
  static Stream<bool> get loggedInStream => _loggedIn.stream;

  static void changeLoggedInStatus(bool status){
    _loggedIn.sink.add(status);
  }

  @override
  void dispose() async {
    await _loggedIn.drain();
    _loggedIn.close();
  }

}