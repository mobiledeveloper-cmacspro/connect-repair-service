import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_textfield_widget.dart';
import 'package:repairservices/ui/article_resources/note/note_bloc.dart';

class NotePage extends StatefulWidget {
  final String note;

  const NotePage({Key key, this.note}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoteState();
}

class _NoteState extends StateWithBloC<NotePage, NoteBloC> {
  final TextEditingController _noteController = TextEditingController();

  void _navBack() {
    NavigationUtils.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.note ?? '';
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXMainBarWidget(
            title: FlutterI18n.translate(context, 'Note 1'),
            onLeadingTap: () {
              _navBack();
            },
            actions: <Widget>[
              TXIconButtonWidget(
                icon: Image.asset(R.image.checkGreen),
                onPressed: () {
                  _navBack();
                },
              )
            ],
            body: Column(
              children: <Widget>[
                TXDividerWidget(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        TXTextFieldWidget(
                          controller: _noteController,
                          multiLine: true,
                          onSubmitted: (value) {},
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TXButtonWidget(
                          mainColor: Colors.red,
                          textColor: Colors.white,
                          title: FlutterI18n.translate(context, 'Delete note'),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
