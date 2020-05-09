import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

enum CellCheckMode { check, selector }

class TXCellCheckWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isChecked;
  final Widget leading;
  final Function onTap;
  final Function onLongPress;
  final CellCheckMode checkMode;
  final showNotCheckedIcon;

  const TXCellCheckWidget({
    Key key,
    this.title,
    this.isChecked,
    this.leading,
    this.onTap,
    this.subtitle,
    this.onLongPress,
    this.checkMode = CellCheckMode.check,
    this.showNotCheckedIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double leadingW = (leading != null) ? 50 : 0;
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            top: 5, bottom: 5, left: leadingW > 0 ? 0 : 15, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: leadingW,
              child: leading,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title?.isNotEmpty == true?
                  Column(
                    children: <Widget>[
                      TXTextWidget(
                        text: title,
                        size: R.dim.bigText,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ): Container(),
                  TXTextWidget(
                    text: subtitle,
                    size: title?.isNotEmpty == true ? R.dim.smallText : R.dim.bigText,
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: checkMode == CellCheckMode.selector
                  ? Icon(
                      Icons.keyboard_arrow_right,
                      color: R.color.gray,
                      size: 25,
                    )
                  : isChecked
                      ? Image.asset(
                          R.image.checkGreen,
                          width: 25,
                          height: 25,
                        )
                      : (showNotCheckedIcon
                          ? Image.asset(
                              R.image.checkGrey,
                              width: 25,
                              height: 25,
                            )
                          : Container(
                              width: 25,
                            )),
            )
          ],
        ),
      ),
    );
  }
}
