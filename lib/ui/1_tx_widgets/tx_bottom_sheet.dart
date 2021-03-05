import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showTXModalBottomSheet({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  showCupertinoModalPopup(
    semanticsDismissible: false,
    context: context,
    builder: (b) => Container(
      color: Colors.white,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 100),
      child: Material(child: builder(context)),
    ),
  );
}