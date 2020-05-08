import 'package:flutter/cupertino.dart';
import 'package:repairservices/res/R.dart';

class TXDividerWidget extends StatelessWidget {
  final Color color;
  final double height;

  const TXDividerWidget({Key key, this.color, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color ?? R.color.gray_darkest,
      height: height ?? .5,
    );
  }
}
