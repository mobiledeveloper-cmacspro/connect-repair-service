import 'package:repairservices/models/Windows.dart';

class SelectionModel {
  String key;
  String title;
  String value;
  bool isMandatory;
  bool isSelected;
  bool isMultiSelect;

  SelectionModel(
      {this.key,
      this.title,
      this.value,
      this.isMandatory,
      this.isSelected = false,
      this.isMultiSelect = false});
}

class PdfCellModel {
  String title;
  String value;
  String image;

  PdfCellModel({this.title, this.value, this.image});
}
