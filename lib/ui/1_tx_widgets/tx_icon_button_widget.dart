import 'package:flutter/material.dart';

class TXIconButtonWidget extends StatelessWidget {
  final Widget icon;
  final Function onPressed;
  final double iconSize;
  final Color backgroundColor;

  const TXIconButtonWidget(
      {Key key, this.icon, this.onPressed, this.iconSize, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      iconSize: iconSize ?? 20,
      color: Colors.white,
    );
  }
}
