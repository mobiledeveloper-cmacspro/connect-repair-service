import 'package:flutter/material.dart';

class TXGestureHideKeyBoard extends StatelessWidget {
  final Widget child;

  const TXGestureHideKeyBoard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: child);
  }
}
