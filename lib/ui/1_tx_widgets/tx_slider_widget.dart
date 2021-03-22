import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';

class TXSliderWidget extends StatefulWidget {
  final bool hasDivisions;
  final ValueChanged<double> onChanged;
  final double value;

  const TXSliderWidget({Key key, this.hasDivisions, this.onChanged, this.value})
      : super(key: key);

  @override
  _TXSliderWidgetState createState() => _TXSliderWidgetState();
}

class _TXSliderWidgetState extends State<TXSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Slider(

      value: widget.value,
      activeColor: R.color.primary_color,
      inactiveColor: R.color.gray_light,
      onChanged: widget.onChanged,
      divisions: widget.hasDivisions ? 2 : null,
      min: widget.hasDivisions ? -1 : -50,
      max: widget.hasDivisions ? 1 : 50,
    );
  }
}
