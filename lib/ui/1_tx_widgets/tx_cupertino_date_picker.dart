import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';

class TXCupertinoDatePicker extends StatelessWidget {
  final DateTime initDate;
  final ValueChanged<DateTime> onDateChange;
  final Function onOK;
  final CupertinoDatePickerMode mode;

  const TXCupertinoDatePicker({Key key, this.initDate, this.onDateChange, this.onOK, this.mode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                onOK();
                NavigationUtils.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Image.asset(
                      R.image.checkGreen,
                      width: 25,
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
            TXDividerWidget(),
            Expanded(
              child: CupertinoDatePicker(
                  mode: mode?? CupertinoDatePickerMode.time,
                  initialDateTime: initDate ?? DateTime.now(),
                  onDateTimeChanged: (date) {
                    if (onDateChange != null) onDateChange(date);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
