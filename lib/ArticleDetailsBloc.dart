import 'package:flutter/cupertino.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/utils/ISClient.dart';
import 'package:rxdart/rxdart.dart';

import 'NetworkImageSSL.dart';
import 'models/Product.dart';

class ArticleDetailsBloc extends BaseBloC{

  BehaviorSubject<bool> _loadingController = new BehaviorSubject();
  Stream<bool> get loadingStream => _loadingController.stream;

  BehaviorSubject<Image> _imageController = new BehaviorSubject();
  Stream<Image> get imageStream => _imageController.stream;

  BehaviorSubject<Product> _productController = new BehaviorSubject();
  Stream<Product> get productStream => _productController.stream;

  BehaviorSubject<List<TupleData>> _tupleDataController = new BehaviorSubject();
  Stream<List<TupleData>> get tupleDataStream => _tupleDataController.stream;

  static BehaviorSubject<bool> _needReloadController = new BehaviorSubject();
  Stream<bool> get needReloadStream => _needReloadController.stream;

  Product product;

  static void setNeedToReload(bool value) {
    _needReloadController.sink.add(value);
  }

  void setLoading(){
    _loadingController.sink.add(true);
  }

  void unsetLoading() {
    _loadingController.sink.add(false);
  }

  void loadProduct(Product p) {
    this.product = p;
    _productController.sink.add(p);
  }

  Future<void> loadImage() async {
    debugPrint('getting Image');
    Image i = Image.asset('assets/productImage.png');
    if (product?.url?.value != null && product?.url?.value != "") {
      final baseUrl = await ISClientO.instance.baseUrl;
      i = Image(
          image: NetworkImageSSL(baseUrl + product.url.value), height: 100);
    }
    _imageController.sink.add(i);
  }

  void loadTupleData(bool seePrices, String lang) {
    List<TupleData> sourceProduct = new List<TupleData>();
//    if(product.avability != null) {
//      sourceProduct.add(product.avability);
//    }

    if (product.currency != null && product.currency.value != "" && seePrices) {
      sourceProduct.add(product.currency);
    }
//    if(product.quantity != null) {
//      sourceProduct.add(TupleData(en: "Quantity:", de: "Menge:",value: product.quantity.value));
//    }
    if (product.unitText != null && product.unitText.value != "") {
      sourceProduct.add(TupleData(
          en: "sales unit",
          de: "Einheit",
          value: _translateUnitText(product.unitText.value, lang)));
    }
    if (product.listPrice != null &&
        product.listPrice.value != "" &&
        seePrices) {
      sourceProduct.add(TupleData(
          en: "list price",
          de: "Listenpreis/VKME",
          value: product.listPrice.value.replaceAll(",", ",")));
    }
    if (product.netPrice != null && product.netPrice.value != "" && seePrices) {
      sourceProduct.add(TupleData(
          en: "net price",
          de: product.netPrice.de,
          value: product.netPrice.value.replaceAll(".", ",")));
    }
    if (product.discount != null && product.discount.value != "" && seePrices) {
      sourceProduct.add(TupleData(
          en: product.discount.en,
          de: product.discount.de,
          value: double.parse(product.discount.value)
              .toStringAsFixed(2)
              .replaceAll(((".")), ",") +
              " %"));
    }
    _tupleDataController.sink.add(sourceProduct);
  }

  String _translateUnitText(String value, String lang) {
    switch (value) {
      case 'piece':
        return lang == 'de' ? 'Stück' : 'Piece';
      case 'Pair':
        return lang == 'de' ? 'Paar' : 'Pair';
      default:
        return 'Pack';
    }
  }

  @override
  void dispose() async {
    await _loadingController.drain();
    _loadingController.close();
    await _imageController.drain();
    _imageController.close();
    await _productController.drain();
    _productController.close();
    await _tupleDataController.drain();
    _tupleDataController.close();
    await _needReloadController.drain();
    _needReloadController.close();
  }


}