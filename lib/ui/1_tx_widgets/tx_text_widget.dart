
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TXTextWidget extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final int maxLines;
  final TextOverflow textOverflow;
  final TextAlign textAlign;

  TXTextWidget(
      {@required this.text,
        this.size,
        this.color,
        this.fontWeight,
        this.maxLines,
        this.textOverflow,
        this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
      maxLines: maxLines,
      overflow: textOverflow ?? TextOverflow.visible,
    );
  }
}