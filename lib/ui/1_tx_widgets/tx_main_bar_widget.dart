import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

enum LeadingType { cancel, back }

class TXMainBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final LeadingType leadingType;
  final Function onLeadingTap;
  final List<Widget> actions;

  const TXMainBarWidget(
      {Key key,
      @required this.body,
      this.title,
      this.actions,
      this.leadingType = LeadingType.back,
      this.onLeadingTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS,
        iconTheme: IconThemeData(color: R.color.primary_color),
        actionsIconTheme: IconThemeData(color: R.color.primary_color),
        leading: leadingType == LeadingType.cancel
            ? InkWell(
                onTap: onLeadingTap,
                child: Container(
                  alignment: Alignment.center,
                  child: TXTextWidget(
                    text: R.string.cancel,
                  ),
                ),
              )
            : TXIconButtonWidget(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: R.color.primary_color,
                  size: 35,
                ),
                onPressed: onLeadingTap,
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
