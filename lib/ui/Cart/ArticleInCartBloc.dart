

import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class ArticleInCartBloc extends BaseBloC{

  static BehaviorSubject<int> _inCart = new BehaviorSubject();
  Stream<int> get inCartStream => _inCart.stream;

  static void setInCart(int cantProd) {
    _inCart.sink.add(cantProd);
  }

  @override
  void dispose() async {
    await _inCart.drain();
    _inCart.close();
  }

}