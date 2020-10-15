
import 'package:flutter/cupertino.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/utils/ISClient.dart';
import 'package:rxdart/rxdart.dart';

class QRScanPageBloc extends BaseBloC {
  BehaviorSubject<Product> _scanResultController = new BehaviorSubject();
  Stream<Product> get scanResultStream => _scanResultController.stream;

  BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject();
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  BehaviorSubject<bool> _showCameraController = BehaviorSubject();
  Stream<bool> get showCameraResult => _showCameraController.stream;

  void initCamera() {
    _showCameraController.sink.add(true);
  }

  void _setLoading() {
    _isLoadingSubject.sink.add(true);
  }

  void _unsetLoading() {
    _isLoadingSubject.sink.add(false);
  }

  Future<void> getArticleDetails(String number) async {
    _showCameraController.sink.add(false);
    _setLoading();
    try {
      Product product =
          await ISClientO.instance.getProductDetails(number, null);
      if (product != null) {
        _unsetLoading();
        _scanResultController.sink.add(product);
      }
    } catch (e) {
      _unsetLoading();
      print('Exception details:\n $e');
      _scanResultController.sink.add(null);
    }
  }

  @override
  void dispose() {
    _scanResultController?.close();
    _isLoadingSubject?.close();
    _showCameraController?.close();
  }
}
