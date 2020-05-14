import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';

class TXButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color mainColor;
  final Color splashColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;

  const TXButtonWidget({
    @required this.onPressed,
    @required this.title,
    this.mainColor,
    this.splashColor,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.white,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: mainColor ?? R.color.primary_color,
      splashColor: splashColor,
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
      disabledColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
    );
  }
}
