import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class TXFittingDimensionTextWidget extends StatelessWidget {
  final double top;
  final double left;
  final bool isRotated;
  final String value;
  final Function onTap;

  const TXFittingDimensionTextWidget(
      {Key key, this.top, this.left, this.isRotated, this.value, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: TXTextWidget(),
        ),
      ),
    );
  }
}
