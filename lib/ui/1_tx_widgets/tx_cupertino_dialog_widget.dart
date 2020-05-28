import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class TXCupertinoDialogWidget extends StatelessWidget {
  final Function onOK;
  final Function onCancel;
  final String title;
  final String content;

  const TXCupertinoDialogWidget(
      {Key key, this.onOK, this.onCancel, this.title, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: TXTextWidget(
        text: title,
        fontWeight: FontWeight.bold,
      ),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        child: TXTextWidget(
          text: content,
        ),
      ),
      actions: <Widget>[
        if (onCancel != null)
          CupertinoDialogAction(
            child: TXTextWidget(
              text: "Cancel",
            ),
            onPressed: onCancel,
          ),
        CupertinoDialogAction(
          child: TXTextWidget(
            text: "OK",
          ),
          onPressed: onOK,
        ),
      ],
    );
  }
}
