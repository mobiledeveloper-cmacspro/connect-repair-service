import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_textfield_widget.dart';

class TXSearchBarWidget extends StatefulWidget {
  final bool defaultModel;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final Function onQRScanTap;
  final Function onSearchTap;
  final Function onCancelTap;

  const TXSearchBarWidget(
      {Key key,
      this.defaultModel = true,
      this.onSubmitted,
      this.onChanged,
      this.onQRScanTap,
      this.onSearchTap,
      this.onCancelTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXSearchBarState();
}

class _TXSearchBarState extends State<TXSearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: widget.defaultModel
              ? _getViewInDefaultMode()
              : _getViewInEditMode()),
    );
  }

  Widget _getViewInEditMode() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: R.color.gray_light,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: TXTextFieldWidget(
              contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 6),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: R.color.gray_darkest,
              ),
              autofocus: true,
              placeholder: "${R.string.search}...",
              onSubmitted: widget.onSubmitted,
              fontSize: 18,
              onChanged: widget.onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: widget.onCancelTap,
          child: TXTextWidget(
            text: R.string.cancel,
            color: R.color.primary_color,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _getViewInDefaultMode() {
    return InkWell(
      onTap: widget.onSearchTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)
            .copyWith(right: 10),
        decoration: BoxDecoration(
            color: R.color.gray_light,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          children: <Widget>[
            Icon(
              CupertinoIcons.search,
              color: R.color.gray_darkest,
            ),
            Expanded(
              child: TXTextWidget(
                text: R.string.search,
                size: 18,
                color: R.color.gray,
              ),
            ),
            InkWell(
              child: Image.asset(
                R.image.qrCodeGrey,
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
              onTap: widget.onQRScanTap,
            )
          ],
        ),
      ),
    );
  }
}
