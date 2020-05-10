import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';

class TXPageIndicatorWidget extends StatelessWidget {
  final int currentSelected;

  const TXPageIndicatorWidget({Key key, this.currentSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getIndicator(currentSelected == 1),
          SizedBox(
            width: 7,
          ),
          _getIndicator(currentSelected == 2),
          SizedBox(
            width: 7,
          ),
          _getIndicator(currentSelected == 3),
        ],
      ),
    );
  }

  Widget _getIndicator(bool isActive) {
    final w = Container(
      height: 7,
      width: 7,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: R.color.primary_color, width: .5),
          color: isActive
              ? R.color.primary_color
              : Colors.white),
    );
    return w;
  }
}
