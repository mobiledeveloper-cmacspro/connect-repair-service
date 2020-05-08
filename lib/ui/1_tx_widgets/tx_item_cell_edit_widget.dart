import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_textfield_widget.dart';

enum CellEditMode { input, selector, detail, none }

class TXItemCellEditWidget extends StatefulWidget {
  final String title;
  final bool isMandatory;
  final String placeholder;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool multiLine;
  final bool blockedMode;
  final String value;
  final CellEditMode cellEditMode;

  const TXItemCellEditWidget(
      {Key key,
      this.placeholder,
      this.controller,
      this.textInputAction,
      this.keyboardType,
      this.onChanged,
      this.title,
      this.isMandatory,
      this.onSubmitted,
      this.multiLine,
      this.value = "",
      this.blockedMode,
      this.cellEditMode = CellEditMode.detail})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXItemCellEditState();
}

class _TXItemCellEditState extends State<TXItemCellEditWidget> {
  var focusNode = new FocusNode();
  final double smallText = 12;
  final double bigText = 16;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.cellEditMode == CellEditMode.detail ||
              widget.cellEditMode == CellEditMode.none)
          ? null
          : () {
              widget.cellEditMode == CellEditMode.selector
                  ? widget.onSubmitted(widget.value)
                  : FocusScope.of(context).requestFocus(focusNode);
            },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TXTextWidget(
                    text: widget.title,
                    size: widget.cellEditMode == CellEditMode.detail
                        ? smallText
                        : bigText,
                    maxLines: 1,
                    color: widget.cellEditMode == CellEditMode.detail
                        ? R.color.gray
                        : Colors.black,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  (widget.cellEditMode == CellEditMode.detail ||
                          widget.cellEditMode == CellEditMode.selector)
                      ? TXTextWidget(
                          text: widget.value.isEmpty
                              ? widget.placeholder
                              : widget.value,
                          color: widget.cellEditMode == CellEditMode.detail
                              ? Colors.black
                              : (widget.value.isEmpty
                                  ? R.color.gray
                                  : Colors.black),
                          size: widget.cellEditMode == CellEditMode.detail
                              ? bigText
                              : smallText,
                        )
                      : TXTextFieldWidget(
                          controller: widget.controller,
                          placeholder: widget.placeholder,
                          focusNode: focusNode,
                          keyboardType: widget.keyboardType,
                          multiLine: widget.multiLine,
                          onSubmitted: widget.onSubmitted,
                          fontSize: smallText,
                          onChanged: widget.onChanged,
                        ),
                ],
              ),
            ),
            widget.cellEditMode == CellEditMode.selector
                ? Icon(
                    Icons.keyboard_arrow_right,
                    color: R.color.gray,
                    size: 25,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
