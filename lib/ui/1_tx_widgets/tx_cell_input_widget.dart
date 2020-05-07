import 'package:flutter/material.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class TXCellInputWidget extends StatelessWidget {
  final String title;
  final String hint;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final ValueChanged<String> onChanged;

  const TXCellInputWidget(
      {Key key,
      this.textInputAction,
      this.textInputType,
      this.title,
      this.hint,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TXTextWidget(
          text: title,
        ),
        TextFormField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0)))
      ],
    );
  }
}
