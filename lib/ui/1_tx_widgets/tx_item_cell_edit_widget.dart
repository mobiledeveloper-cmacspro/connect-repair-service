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
  final Widget leading;

  const TXItemCellEditWidget(
      {Key key,
      this.placeholder,
      this.controller,
      this.textInputAction,
      this.keyboardType,
      this.onChanged,
      this.title = '',
      this.isMandatory,
      this.onSubmitted,
      this.multiLine,
      this.value = "",
      this.blockedMode,
      this.cellEditMode = CellEditMode.detail,
      this.leading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXItemCellEditState();
}

class _TXItemCellEditState extends State<TXItemCellEditWidget> {
  var focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final double leadingW =
        (widget.leading != null && widget.cellEditMode == CellEditMode.selector)
            ? 50
            : 0;
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
        padding: EdgeInsets.only(
            top: 5, bottom: 5, left: leadingW > 0 ? 0 : 15, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: leadingW,
              child: widget.leading,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.title.isNotEmpty
                      ? TXTextWidget(
                          text: widget.title,
                          size: widget.cellEditMode == CellEditMode.detail
                              ? R.dim.smallText
                              : R.dim.bigText,
                          maxLines: 1,
                          color: widget.cellEditMode == CellEditMode.detail
                              ? R.color.gray
                              : Colors.black,
                          textOverflow: TextOverflow.ellipsis,
                        )
                      : Container(),
                  (widget.cellEditMode == CellEditMode.detail ||
                          widget.cellEditMode == CellEditMode.selector)
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.title.isEmpty ? 8 : 0),
                          child: TXTextWidget(
                            text: widget.value.isEmpty
                                ? widget.placeholder
                                : widget.value,
                            color: widget.cellEditMode == CellEditMode.detail
                                ? Colors.black
                                : (widget.value.isEmpty
                                    ? R.color.gray
                                    : Colors.black),
                            size: widget.title.isEmpty ||
                                    widget.cellEditMode == CellEditMode.detail
                                ? R.dim.bigText
                                : R.dim.smallText,
                          ),
                        )
                      : TXTextFieldWidget(
                          controller: widget.controller,
                          placeholder: widget.placeholder,
                          focusNode: focusNode,
                          keyboardType: widget.keyboardType,
                          multiLine: widget.multiLine,
                          onSubmitted: widget.onSubmitted,
                          fontSize: R.dim.smallText,
                          onChanged: widget.onChanged,
                        ),
                ],
              ),
            ),
            Container(
              width: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (widget.isMandatory ?? false) ? TXTextWidget(text: "*", color: Colors.red,) : Container(),
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
          ],
        ),
      ),
    );
  }
}
