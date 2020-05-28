import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/article_resources/audio/audio_bloc.dart';
import 'package:audio_recorder/audio_recorder.dart';

class AudioPage extends StatefulWidget {
  final MemoAudioModel model;

  const AudioPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AudioState();
}

class _AudioState extends StateWithBloC<AudioPage, AudioBloC> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  String _savedFilePath;
  String _textViewDuration;
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration _playDuration = new Duration();
  Duration _position = new Duration();

  Stopwatch _watch = Stopwatch();
  Timer _timer;

  bool _isPlaying = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    bloc.init(widget.model);
    _requestPermission();
  }

  @override
  void dispose() {
    bloc.disposeAudioView();
//    audioPlayer.dispose();
//    AudioRecorder.stop();
    super.dispose();
  }

  void _navBack() {
    NavigationUtils.pop(context, result: bloc.model);
  }

  _requestPermission() async {
    !(await Permission.speech.request().isGranted &&
            await Permission.storage.request().isGranted)
        ? _navBack()
        // ignore: unnecessary_statements
        : '';
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
          StreamBuilder<MediaActions>(
              stream: bloc.audioActionResult,
              initialData: MediaActions.NEW,
              builder: (ctx, actionSnapshot) {
                final act = actionSnapshot.data;
                return TXMainBarWidget(
                  title: FlutterI18n.translate(context, 'Audio 1'),
                  onLeadingTap: () {
                    _navBack();
                  },
                  actions: <Widget>[
                    TXIconButtonWidget(
                      icon: Image.asset(act == MediaActions.NEW ||
                              act == MediaActions.RECORDING
                          ? R.image.checkGrey
                          : R.image.checkGreen),
                      onPressed: act == MediaActions.NEW ||
                          act == MediaActions.RECORDING ? null : () async {
                        _navBack();
                      },
                    )
                  ],
                  body: Container(
                    height: double.infinity,
                    color: R.color.gray_light,
                    child: Column(children: <Widget>[
                      TXDividerWidget(),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 60,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: act == MediaActions.RECORDING ||
                                      act == MediaActions.PLAYING
                                  ? Colors.red
                                  : Colors.white,
                              child: InkWell(
                                child: Image.asset(
                                  act == MediaActions.NEW
                                      ? R.image.noteAudioWhite
                                      : (act == MediaActions.RECORDING ||
                                              act == MediaActions.PLAYING
                                          ? R.image.noteAudioStopWhite
                                          : R.image.noteAudioPlayWhite),
                                  color: act == MediaActions.NEW
                                      ? R.color.gray
                                      : (act == MediaActions.RECORDED
                                          ? R.color.primary_color
                                          : Colors.white),
                                  width: 25,
                                  height: 25,
                                ),
                                onTap: () {
                                  if (act == MediaActions.NEW) {
                                    bloc.startRecord();
                                  } else if (act == MediaActions.RECORDING) {
                                    bloc.stopRecord();
                                  } else if (act == MediaActions.RECORDED) {
                                    bloc.playAudio();
                                  } else if (act == MediaActions.PLAYING) {
                                    bloc.stopAudio();
                                  } else {
                                    Fluttertoast.showToast(msg: "Play");
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            StreamBuilder<String>(
                              stream: bloc.timerResult,
                              initialData: "00:00:00",
                              builder: (ctx, timerSnapshot) {
                                return TXTextWidget(
                                  text: timerSnapshot.data,
                                );
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXButtonWidget(
                              title: FlutterI18n.translate(
                                  context, 'Delete record'),
                              textColor: Colors.white,
                              mainColor: (act == MediaActions.NEW ||
                                      act == MediaActions.RECORDING)
                                  ? R.color.gray
                                  : Colors.red,
                              onPressed: (act == MediaActions.NEW ||
                                      act == MediaActions.RECORDING)
                                  ? null
                                  : () async {
                                      await bloc.deleteAudio();
                                      _navBack();
                                    },
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
