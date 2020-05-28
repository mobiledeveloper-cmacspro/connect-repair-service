import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';

class TXTextFieldWidget extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool multiLine;
  final FocusNode focusNode;
  final double fontSize;
  final Widget prefixIcon;
  final EdgeInsets contentPadding;
  final bool autofocus;
  final BoxDecoration boxDecoration;

  const TXTextFieldWidget(
      {Key key,
      this.placeholder,
      this.controller,
      this.textInputAction,
      this.keyboardType,
      this.onChanged,
      this.multiLine,
      this.focusNode,
      this.onSubmitted,
      this.fontSize = 12,
      this.prefixIcon,
      this.contentPadding,
      this.autofocus = false, this.boxDecoration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXTextFieldWidgetState();
}

class _TXTextFieldWidgetState extends State<TXTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      autofocus: widget.autofocus ?? false,
      controller: widget.controller,
      maxLines: (widget.multiLine ?? false) ? 10 : 1,
      minLines: 1,
      prefix: widget.prefixIcon,
      padding: widget.contentPadding ?? EdgeInsets.all(0),
      decoration: widget.boxDecoration,
      placeholder: widget.placeholder,
      style: TextStyle(
          fontSize: widget.fontSize, color: Colors.black, letterSpacing: .05),
      placeholderStyle: TextStyle(
          fontSize: widget.fontSize, color: R.color.gray, letterSpacing: .05),
      focusNode: widget.focusNode,
      cursorColor: R.color.gray,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
