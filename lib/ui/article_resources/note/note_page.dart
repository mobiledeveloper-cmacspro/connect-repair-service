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
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/article_resources/note/note_bloc.dart';

class NotePage extends StatefulWidget {
  final MemoNoteModel model;

  const NotePage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoteState();
}

class _NoteState extends StateWithBloC<NotePage, NoteBloC> {
  final TextEditingController _noteController = TextEditingController();

  void _navBack() {
    NavigationUtils.pop(context, result: bloc.model);
  }

  @override
  void initState() {
    super.initState();
    bloc.model = widget.model;
    _noteController.text = widget.model.description ?? '';
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
            title: R.string.note1,
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
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      height: double.infinity,
                      color: R.color.gray_light,
                      child: Column(
                        children: <Widget>[
                          TXTextFieldWidget(
                            boxDecoration: BoxDecoration(
                                border: Border.all(color: R.color.gray),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white),
                            controller: _noteController,
                            multiLine: true,
                            contentPadding: EdgeInsets.all(6.0),
                            onSubmitted: (value) {
                              bloc.model.description = value;
                            },
                            onChanged: (value) {
                              bloc.model.description = value;
                            },
                            placeholder: "Add text",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: TXButtonWidget(
                              mainColor: Colors.red,
                              textColor: Colors.white,
                              title:
                                  R.string.deleteNote,
                              onPressed: () {
                                bloc.model.description = "";
                                _navBack();
                              },
                            ),
                          )
                        ],
                      ),
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
