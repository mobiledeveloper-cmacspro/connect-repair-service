import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/article_resources/audio/audio_bloc.dart';
import 'package:audio_recorder/audio_recorder.dart';

class AudioPage extends StatefulWidget {
  final String filePath;

  const AudioPage({Key key, this.filePath}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AudioState();
}

class _AudioState extends StateWithBloC<AudioPage, AudioBloC> {
  Recording _recording = new Recording();
  bool _isRecording = false; 
  String _savedFilePath;

  void _navBack() {
    NavigationUtils.pop(context);
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        print("Start recording");
        bloc.audioPath().then((value) async => {
          await AudioRecorder.start(path: value).then((value) async =>
          await AudioRecorder.isRecording.then((value) => setState(() {
            _recording = new Recording(duration: new Duration());
            _isRecording = value;
          })))
        });
      } else {
        print("You must accept permissions");
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = File(recording.path);
    print("  File length: ${await file.length()} ");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
      _savedFilePath = file.path;
    });
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
            title: FlutterI18n.translate(context, 'Audio 1'),
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
                height: 350,
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
                      height: 10,
                    ),
                    TXButtonWidget(
                      title: FlutterI18n.translate(context, 'Start recording'),
                      textColor: Colors.white,
                      mainColor: Colors.green,
                      onPressed: _isRecording ? null : _start,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXButtonWidget(
                      title: FlutterI18n.translate(context, 'Stop recording'),
                      textColor: Colors.white,
                      mainColor: Colors.orangeAccent,
                      onPressed: _isRecording ? _stop : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXButtonWidget(
                      title: FlutterI18n.translate(context, 'Delete record'),
                      textColor: Colors.white,
                      mainColor: Colors.red,
                      onPressed: () {  bloc.deleteAudio(_savedFilePath);},
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
