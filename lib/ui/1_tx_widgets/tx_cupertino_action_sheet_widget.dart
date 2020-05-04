import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class TXCupertinoActionSheetWidget extends StatelessWidget {
  final List<ActionSheetModel> actions;
  final ValueChanged<ActionSheetModel> onActionTap;

  const TXCupertinoActionSheetWidget(
      {Key key, this.actions = const [], this.onActionTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: CupertinoActionSheet(
        actions: _getActions(context),
        cancelButton: Container(
          alignment: Alignment.center,
          child: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: (){
              NavigationUtils.pop(context);
            },
            child: TXTextWidget(
                text: FlutterI18n.translate(context, 'Cancel'),
                size: 18,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  List<Widget> _getActions(BuildContext context) {
    List<Widget> list = [];
    actions.forEach((a) {
      final action = CupertinoActionSheetAction(
        onPressed: (){
          onActionTap(a);
          NavigationUtils.pop(context);
        },
        child: TXTextWidget(
          size: 18,
          text: a.title,
          color: a.color,
        ),
      );
      list.add(action);
    });
    return list;
  }
}

class ActionSheetModel {
  String key;
  String title;
  Color color;

  ActionSheetModel({this.key, this.title, this.color});
}
