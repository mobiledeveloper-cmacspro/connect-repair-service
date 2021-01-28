import 'package:repairservices/models/Product.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/utils/ISClient.dart';
import 'package:rxdart/rxdart.dart';

class QRResultPageBloc extends BaseBloC {
  BehaviorSubject<Product> _scanResultController = new BehaviorSubject();

  Stream<Product> get productStream => _scanResultController.stream;

  BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject();

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  void _setLoading() {
    _isLoadingSubject.sink.add(true);
  }

  void _unsetLoading() {
    _isLoadingSubject.sink.add(false);
  }

  Future<void> getArticleDetails(String url) async {
    _setLoading();
    try {
      final number = await parseUrl(url: url);
      if (number != null) {
        Product product =
            await ISClientO.instance.getProductDetails(number, null);
        if (product != null) {
          _unsetLoading();
          _scanResultController.sink.add(product);
        }
      } else {
        _unsetLoading();
        _scanResultController.sink.add(null);
      }
    } catch (e) {
      _unsetLoading();
      print('Exception details:\n $e');
      _scanResultController.sink.add(null);
    }
  }

  Future<String> parseUrl({String url}) async {
    try {
      String articleNumber;
      if (url.contains('dc.schueco.com')) {
        List<String> result = url.split('\/');
        if (result.length > 3) articleNumber = result[2];
      }
      print("Article number -> $articleNumber");
      return articleNumber;
    } catch (e) {
      print('Exception details:\n $e');
      return null;
    }
  }

  @override
  void dispose() {
    _scanResultController?.close();
    _isLoadingSubject?.close();
  }
}
