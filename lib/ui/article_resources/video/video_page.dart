import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/article_resources/video/video_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key key, this.filePath}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoState();
}

class _VideoState extends StateWithBloC<VideoPage, VideoBloC> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  String savedFilePath;

  void _navBack() {
    NavigationUtils.pop(context);
  }

  void _onVideoControllerUpdate() {
    setState(() {});
  }

  void _takeVideo(ImageSource source) async {
    ImagePicker.pickVideo(source: source).then((File file) {
      if (file != null && mounted) {
        bloc.saveVideo(file).then((value) => setState(() {
              bloc.deleteVideo(file.path);
              _controller = VideoPlayerController.file(value)
                ..addListener(_onVideoControllerUpdate)
                ..setVolume(1.0)
                ..initialize()
                ..setLooping(true)
                ..play();
              savedFilePath = value.path;
            }));
      }
    });
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.removeListener(_onVideoControllerUpdate);
    }
    super.deactivate();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.filePath));
    _initializeVideoPlayerFuture = _controller.initialize();

    if (widget.filePath.isEmpty) {
      _takeVideo(ImageSource.camera);
    }

    super.initState();
  }

  @override
  void dispose() {
    if(_controller!= null) _controller.dispose();
    super.dispose();
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
            title: FlutterI18n.translate(context, 'Video 1'),
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
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the VideoPlayer.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TXButtonWidget(
                mainColor: R.color.primary_color,
                textColor: Colors.white,
                title: FlutterI18n.translate(context, 'Take new video'),
                onPressed: () {
                  bloc.deleteVideo(savedFilePath);
                  _takeVideo(ImageSource.camera);
                },
              ),
              SizedBox(
                height: 10,
              ),
              (savedFilePath != null)
                  ? TXButtonWidget(
                      mainColor: Colors.red,
                      textColor: Colors.white,
                      title: FlutterI18n.translate(context, 'Delete video'),
                      onPressed: () {
                        bloc.deleteVideo(savedFilePath);
                        setState(() { savedFilePath = null;});
                        _controller.removeListener(() {_onVideoControllerUpdate();});
                        _controller.initialize();
                      },
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              (savedFilePath != null)
                  ? TXButtonWidget(
                      mainColor: R.color.primary_color,
                      textColor: Colors.white,
                      title: FlutterI18n.translate(context, 'Play video'),
                      onPressed: () {
                        _controller.play();
                      },
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              (savedFilePath != null)
                  ? TXButtonWidget(
                      mainColor: Colors.red,
                      textColor: Colors.white,
                      title: FlutterI18n.translate(context, 'Stop video'),
                      onPressed: () {
                        _controller.pause();
                      },
                    )
                  : Container()
            ]),
          )
        ],
      ),
    );
  }
}
