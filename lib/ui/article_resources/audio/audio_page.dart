import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
    _requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    AudioRecorder.stop();
  }

  void _navBack() {
    NavigationUtils.pop(context);
  }

  _requestPermission() async {
    !(await Permission.speech.request().isGranted &&
            await Permission.storage.request().isGranted)
        ? _navBack()
        // ignore: unnecessary_statements
        : '';
  }

  _updateTime(Timer timer) {
    if (_watch.isRunning) {
      setState(() {
        _textViewDuration =
            bloc.transformMilliSeconds(_watch.elapsedMilliseconds);
      });
    }
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
                        _watch.start();
                        _timer = Timer.periodic(
                            Duration(milliseconds: 100), _updateTime);
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
    _watch.stop();
    _timer.cancel();
    bool isRecording = await AudioRecorder.isRecording;
    File file = File(recording.path);
    print("  File length: ${await file.length()} ");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
      _savedFilePath = file.path;
      _textViewDuration =
          bloc.transformMilliSeconds(_watch.elapsedMilliseconds);
      _watch.reset();
    });
  }

  _deleteRecord() async {
    bloc.deleteAudio(_savedFilePath);
    setState(() {
      _savedFilePath = null;
      _textViewDuration = null;
    });
  }

  _playPauseAudio() async {
    if (!_isPlaying) {
      int response = await audioPlayer.play(_savedFilePath, isLocal: true);
      !(response == 1)
          ? print('Some error occured in playing from storage!')
          : "";
      setState(() {
        _isPlaying = true;
      });
    } else if (_isPaused & _isPlaying) {
      int response = await audioPlayer.resume();
      !(response == 1) ? print('Some error occured resuming!') : "";
      setState(() {
        _isPaused = false;
      });
    } else {
      int response = await audioPlayer.pause();
      !(response == 1) ? print('Some error occured pausing!') : "";
      setState(() {
        _isPaused = true;
      });
    }
  }

  _stopAudio() async {
    audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _isPaused = false;
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
                      text: (_textViewDuration != null)
                          ? _textViewDuration
                          : "00:00:00",
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
                      onPressed: () {
                        _deleteRecord();
                      },
                    )
                  ],
                ),
              ),
              (_savedFilePath != null)
                  ? Container(
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          TXButtonWidget(
                            title:
                                (!_isPlaying || _isPaused) ? 'Play' : 'Pause',
                            textColor: Colors.white,
                            mainColor: Colors.blueAccent,
                            onPressed: () {
                              _playPauseAudio();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TXButtonWidget(
                            title: 'Stop',
                            textColor: Colors.white,
                            mainColor: Colors.redAccent,
                            onPressed: () {
                              _stopAudio();
                            },
                          )
                        ],
                      ),
                    )
                  : Container(), 
            ]),
          ),
        ],
      ),
    );
  }
}
