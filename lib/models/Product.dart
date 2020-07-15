//import 'package:repairservices/generated/i18n.dart';

//import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:repairservices/res/R.dart';

final String tableProduct = 'product';
final String tableProductInCart = 'productInCart';
final String columnProductId = '_id';
final String columnShortText = 'shortText';
final String columnProductNumber = 'number';
final String columnProductUrl = 'url';
final String columnProductQuantity = 'quantity';

class Product {
  int id;
  TupleData number,
      url,
      shortText,
      isoUnit,
      unitShort,
      avability,
      currency,
      quantity,
      listPrice,
      discount,
      netPrice,
      totalAmount,
      unitText;
  bool selected = false;

  Product(
      {this.id,
      this.number,
      this.url,
      this.shortText,
      this.isoUnit,
      this.unitShort,
      this.avability,
      this.currency,
      this.quantity,
      this.listPrice,
      this.discount,
      this.netPrice,
      this.totalAmount,
      this.unitText,
      this.selected});

  Product.fromMap(Map<String, dynamic> map) {
    id = map[columnProductId];
    shortText =
        TupleData(en: 'shorText', de: 'Kurztext', value: map[columnShortText]);
    number = TupleData(
        en: 'articelNr', de: 'Materialnummer', value: map[columnProductNumber]);
    url = TupleData(en: 'url', de: 'url', value: map[columnProductUrl]);
    quantity = TupleData(
        en: 'quantity', de: 'Anzahl', value: map[columnProductQuantity]);
  }

  Map<String, dynamic> toMap() {
    debugPrint(
        'Product to map: ${shortText.value}, ${number.value}, ${url.value}, ${quantity.value}');
    var map = <String, dynamic>{
      columnShortText: shortText.value,
      columnProductNumber: number.value,
      columnProductUrl: url.value,
      columnProductQuantity: quantity == null ? "1" : quantity.value
    };
    if (id != null) {
      map[columnProductId] = id;
    }
    return map;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final fullString = json['products'].toString().replaceAll(";", "");
    final List<String> arrayValues = fullString.split(",");
    var product = Product();
    for (String values in arrayValues) {
      if (values.split(":")[0] == "articelNr") {
        final tupla = values.split(":");
        product.number = TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "url") {
        final tupla = values.split(":");
        product.url = TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "shortText") {
        final tupla = values.split(":");
        product.shortText =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "unitShort") {
        final tupla = values.split(":");
        product.unitShort =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "ISOUnit") {
        final tupla = values.split(":");
        product.isoUnit =
            TupleData(en: "Sales unit", de: "Verkaufsmengeneinheit", value: tupla[2]);
      } else if (values.split(":")[0] == "unitText") {
        final tupla = values.split(":");
        product.unitText =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "avability") {
        final tupla = values.split(":");
        product.avability =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "currency") {
        final tupla = values.split(":");
        product.currency =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "quantity") {
        final tupla = values.split(":");
        product.quantity =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "listPrice") {
        final tupla = values.split(":");
        product.listPrice =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "discount") {
        final tupla = values.split(":");
        product.discount =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "netPrice") {
        final tupla = values.split(":");
        product.netPrice =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      } else if (values.split(":")[0] == "totalAmount") {
        final tupla = values.split(":");
        product.totalAmount =
            TupleData(en: tupla[0], de: tupla[1], value: tupla[2]);
      }
    }
    return product;
  }
}

class TupleData {
  String en;
  String de;
  String value;

  TupleData({this.en, this.de, this.value});
}
