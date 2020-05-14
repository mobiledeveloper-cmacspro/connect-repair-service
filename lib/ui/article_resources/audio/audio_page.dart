import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/article_resources/audio/audio_bloc.dart';

class AudioPage extends StatefulWidget {
  final String filePath;

  const AudioPage({Key key, this.filePath}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AudioState();
}

class _AudioState extends StateWithBloC<AudioPage, AudioBloC> {
  void _navBack() {
    NavigationUtils.pop(context);
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
            title: "Audio 1",
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
            body: Column(children: <Widget>[
              TXDividerWidget(),
              Container(
                width: double.infinity,
                height: 300,
                child: Column(
                  children: <Widget>[
                    TXIconButtonWidget(
                      icon: Image.asset(R.image.noteAudio),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text: "00:00:00",
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TXButtonWidget(
                      title: "Delete record",
                      onPressed: () {},
                      textColor: Colors.white,
                      mainColor: Colors.red,
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
