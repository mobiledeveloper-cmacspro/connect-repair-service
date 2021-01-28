import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';
import 'package:repairservices/utils/extensions.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:rxdart/subjects.dart';

class AudioBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<MediaActions> _audioActionController = new BehaviorSubject();

  Stream<MediaActions> get audioActionResult => _audioActionController.stream;

  BehaviorSubject<String> _timerController = new BehaviorSubject();

  Stream<String> get timerResult => _timerController.stream;

  static Future<String> getRootFiles() async =>
      await FileUtils.getRootFilesDir();

  final AudioPlayer audioPlayer = new AudioPlayer();
//  final Stopwatch _watchTimer = Stopwatch();
  Timer _timer;

  MemoAudioModel model;
  FlutterAudioRecorder recorder;

  void init(MemoAudioModel model) async {
    this.model = model;
    if (model.filePath.isNotEmpty && File(model.filePath).existsSync()) {
      await audioPlayer.setUrl(model.filePath, isLocal: true);
      initAudioPlayListeners();
      _audioActionController.sinkAddSafe(MediaActions.RECORDED);
    } else {
      final appRootFiles = await getRootFiles();
      this.model.filePath = "$appRootFiles/${model.id}";
      _audioActionController.sinkAddSafe(MediaActions.NEW);
    }

    recorder = FlutterAudioRecorder(this.model.filePath);
    await recorder.initialized;
  }

  void disposeAudioView() async {
    if (await audioActionResult.first == MediaActions.RECORDING) {
      await deleteAudio();
    }

    if (await audioActionResult.first == MediaActions.PLAYING) {
      await audioPlayer.release();
    }
  }

  void startRecord() async {
//    await AudioRecorder.start(path: this.model.filePath);
    await recorder.start();
    _audioActionController.sinkAddSafe(MediaActions.RECORDING);
    initRecorderListeners();
  }

  void stopRecord() async {
    var result = await recorder.stop();
//    Recording recording = await AudioRecorder.stop();
    this.model.filePath = result.path;
//    _watchTimer.stop();
    _timer.cancel();
    await audioPlayer.setUrl(model.filePath, isLocal: true);
    initAudioPlayListeners();
    _audioActionController.sinkAddSafe(MediaActions.RECORDED);
//    transformMilliSeconds(_watchTimer.elapsedMilliseconds);
//    _watchTimer.reset();
  }

  void initAudioPlayListeners() {
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      transformMilliSeconds(d.inMilliseconds);
    });

    audioPlayer.onDurationChanged.listen((Duration d) {
      transformMilliSeconds(d.inMilliseconds);
    });

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.PLAYING) {
        _audioActionController.sinkAddSafe(MediaActions.PLAYING);
      } else {
        _audioActionController.sinkAddSafe(MediaActions.RECORDED);
      }
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      _audioActionController.sinkAddSafe(MediaActions.RECORDED);
    });
  }

  void initRecorderListeners() {
    int millis = 0;
//    _watchTimer.start();
    _timer = Timer.periodic(Duration(milliseconds: 100),(timer){
      millis += 100;
      transformMilliSeconds(millis);
    });
  }

  void playAudio() async {
    await audioPlayer.play(this.model.filePath, isLocal: true);
    _audioActionController.sinkAddSafe(MediaActions.PLAYING);
  }

  void stopAudio() async {
    await audioPlayer.stop();
    _audioActionController.sinkAddSafe(MediaActions.RECORDED);
  }

  Future<String> audioPath() async {
    final appRootFiles = await getRootFiles();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    String newFilePath = "$appRootFiles/$fileName";
    return newFilePath;
  }

  Future<void> deleteAudio() async {
    File file = File(this.model.filePath);
    file.deleteSync();
    this.model.filePath = "";
  }

  void transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    _timerController.sinkAddSafe("$hoursStr:$minutesStr:$secondsStr");
  }

  @override
  void dispose() {
    _audioActionController.close();
    _timerController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
