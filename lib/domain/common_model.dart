import 'package:repairservices/models/Windows.dart';

class SelectionModel {
  String key;
  String title;
  String value;
  bool isSelected;

  SelectionModel({this.key, this.title, this.value, this.isSelected});
}

class PdfCellModel {
  String title;
  String value;
  String image;

  PdfCellModel({this.title, this.value, this.image});

  static List<PdfCellModel> getListFromFitting(Fitting fitting){

  }
}
