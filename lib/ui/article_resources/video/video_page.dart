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
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/article_resources/video/video_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final MemoVideoModel model;

  const VideoPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoState();
}

class _VideoState extends StateWithBloC<VideoPage, VideoBloC> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  void _navBack() {
    NavigationUtils.pop(context, result: widget.model);
  }

  void _onVideoControllerUpdate() {
    final bool isPlaying = _controller.value.isPlaying;
    if (isPlaying != _isPlaying) {
      _controller.initialize();
      setState(() {
        _isPlaying = isPlaying;
      });
    }
  }

  void _takeVideo(ImageSource source) async {
    final file = await ImagePicker.pickVideo(source: source);
    if (file != null && mounted) {
      final newFile = await bloc.saveVideo(file, widget.model.id);
      _controller = VideoPlayerController.file(newFile);

      _controller.addListener(_onVideoControllerUpdate);

      _initializeVideoPlayerFuture = _controller.initialize();

//        ..setVolume(1.0)
//        ..initialize()
//        ..play();
      widget.model.filePath = newFile.path;
      setState(() {
        _isPlaying = false;
      });
    }
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
    super.initState();

    _isPlaying = false;
    _controller = VideoPlayerController.file(File(widget.model.filePath));
    _controller.addListener(_onVideoControllerUpdate);

    _initializeVideoPlayerFuture = _controller.initialize();
    //
    //if (widget.model.filePath.isEmpty) {
    //  _takeVideo(ImageSource.camera);
    //} else {
    //  _initializeVideoPlayerFuture = _controller.initialize();
    //}
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
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
            title: R.string.video1,
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
            body: Stack(
              children: <Widget>[
                Column(children: <Widget>[
                  TXDividerWidget(),
                  Expanded(
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: TXButtonWidget(
                      mainColor: R.color.primary_color,
                      textColor: Colors.white,
                      title: R.string.takeNewVideo,
                      onPressed: () async {
                        await bloc.deleteVideo(widget.model.filePath);
                        _takeVideo(ImageSource.camera);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: TXButtonWidget(
                      mainColor: Colors.red,
                      textColor: Colors.white,
                      title: R.string.deleteVideo,
                      onPressed: () async {
                        await bloc.deleteVideo(widget.model.filePath);
                        widget.model.filePath = "";
                        _navBack();
//                    _controller.removeListener(() {
//                      _onVideoControllerUpdate();
//                    });
//                    _controller.initialize();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
//              (savedFilePath != null)
//                  ? TXButtonWidget(
//                      mainColor: R.color.primary_color,
//                      textColor: Colors.white,
//                      title: R.string.playVideo,
//                      onPressed: () {
//                        _controller.play();
//                      },
//                    )
//                  : Container(),
//              SizedBox(
//                height: 10,
//              ),
//              (savedFilePath != null)
//                  ? TXButtonWidget(
//                      mainColor: Colors.red,
//                      textColor: Colors.white,
//                      title: R.string.stopVideo,
//                      onPressed: () {
//                        _controller.pause();
//                      },
//                    )
//                  : Container()
                ]),
                !_isPlaying
                    ? Center(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _isPlaying = true;
                                });
                                await _controller.play();
                              },
                              child: Image.asset(
                                R.image.noteAudioPlayWhite,
                                color: R.color.primary_color,
                                width: 25,
                                height: 25,
                              )),
                        ),
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
