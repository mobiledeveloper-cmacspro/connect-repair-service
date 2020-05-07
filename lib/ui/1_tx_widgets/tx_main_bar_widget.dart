import 'dart:io';

import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class TXMainBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final TXIconButtonWidget leading;
  final List<Widget> actions;

  const TXMainBarWidget(
      {Key key, @required this.body, this.title, this.leading, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS,
        iconTheme: IconThemeData(color: R.color.primary_color),
        actionsIconTheme: IconThemeData(color: R.color.primary_color),
        leading: leading ??
            TXIconButtonWidget(
              icon: Image.asset(R.image.logo),
            ),
        title: TXTextWidget(
          text: title,
          color: Colors.black,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          size: 18,
        ),
        actions: actions,
      ),
      body: body,
    );
  }
}
