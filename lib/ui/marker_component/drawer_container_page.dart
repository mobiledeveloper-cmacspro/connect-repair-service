import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:repairservices/di/injector.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_dialog_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_page.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/article_resources/audio/audio_page.dart';
import 'package:repairservices/ui/article_resources/note/note_page.dart';
import 'package:repairservices/ui/article_resources/video/video_page.dart';
import 'package:repairservices/ui/marker_component/drawer_container_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_ui.dart';
import 'package:repairservices/ui/marker_component/items/item_angle.dart';
import 'package:repairservices/ui/marker_component/items/item_line.dart';
import 'package:repairservices/ui/marker_component/utils/take_screenshoot.dart';
import 'package:repairservices/utils/calendar_utils.dart';

import '../../utils/file_utils.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawerContainerPage extends StatefulWidget {
  final String imagePath;
  final bool isForMail;
  final bool autoSave;

  const DrawerContainerPage(
      {Key key, @required this.imagePath, this.isForMail = false, this.autoSave = true})
      : super(key: key);

  @override
  _DrawerContainerPageState createState() => _DrawerContainerPageState();
}

class _DrawerContainerPageState
    extends StateWithBloC<DrawerContainerPage, DrawerToolBloc> {
  GlobalKey previewContainer = GlobalKey();
  TextEditingController titleCtr = TextEditingController();

//  DrawerToolBloc get blocTool => Injector.instance.getNewBloc();

  @override
  void initState() {
    super.initState();
    bloc.initArticleModel(widget.imagePath);
    titleCtr.text = bloc.articleModel.displayName;
    initMemoListener();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainBarWidget(
      title: R.string.editPicture,
      onLeadingTap: () {
        NavigationUtils.pop(context);
      },
      actions: getActions(context),
      body: Column(
        children: [
          TXDividerWidget(),
          Text(titleCtr.text,
              style: TextStyle(
                  fontSize: 17, color: Theme.of(context).primaryColor)),
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<File>(
                  stream: bloc.selectedImageStream,
                  builder: (c, snap) {
                    return StreamBuilder<List<MemoModel>>(
                        stream: bloc.memoListResult,
                        initialData: [],
                        builder: (ctx, snapshotMemos) {
                          return DrawerToolUI(
                            selectedImage: snap.data,
                            previewContainer: previewContainer,
                            backgroundColor: Colors.white,
                            memos: _getMemos(snapshotMemos.data),
                          );
                        });
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      bloc.addingMemo
                          ? getBottomMemoBar()
                          : getSecondLayerMenu(),
                      Container(
                        height: 1,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          getCurrentMenu(),
        ],
      ),
    );
  }

//  loadImage() async {
//    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    bloc.selectedImage = image;
//  }

  List<Widget> getActions(BuildContext context) => [
        StreamBuilder<bool>(
          stream: bloc.savingScreenShotStream,
          builder: (c, snapshot) {
            return InkWell(
              onTap: () {
                if (!snapshot.data) saveScreenshot(context);
              },
              child: Image.asset(
                'assets/checkGreen.png',
                height: 25,
              ),
            );
          },
        )
      ];

  Widget getBlueContainer({
    Widget child,
    Color color = Colors.teal,
  }) =>
      Container(
        width: double.infinity,
        height: 50,
        color: color,
        child: child,
      );

  Widget getModeColorsMenu() {
    return getBlueContainer(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                bloc.updateColor(Theme.of(context).primaryColor);
              },
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                bloc.updateColor(Colors.redAccent);
              },
              child: Container(
                color: Colors.redAccent,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                bloc.updateColor(Colors.yellowAccent);
              },
              child: Container(
                color: Colors.yellowAccent,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                bloc.updateColor(Colors.blueAccent);
              },
              child: Container(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getModeAddMenu() {
    return getBlueContainer(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getActionItem(
            icon: MdiIcons.arrowRightBoldOutline,
            text: R.string.arrow1,
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.addLine(
                ItemLine(
                  color: Colors.green,
                  creatingText: R.string.drawTheLine,
                  startArrow: false,
                  endArrow: true,
                ),
              );
            },
          ),
          getActionItem(
            icon: MdiIcons.arrowLeftRightBoldOutline,
            text: R.string.arrow2,
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.addLine(
                ItemLine(
                  color: Colors.green,
                  creatingText: R.string.drawTheLine,
                  startArrow: true,
                  endArrow: true,
                ),
              );
            },
          ),
          getActionItem(
            icon: MdiIcons.angleAcute,
            text: R.string.angle,
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.addLine(
                ItemAngle(
                  color: Colors.green,
                  creatingText: R.string.drawTheLine,
                ),
              );
            },
          ),
          getActionItem(
            icon: MdiIcons.noteOutline,
            text: R.string.memo,
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.currentDrawerMode = DrawerMode.nothing();
              setState(() {
                bloc.addingMemo = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget getSecondLayerMenu() => StreamBuilder<ViewMode>(
        stream: bloc.viewModeStream,
        initialData: ViewMode.NOTHING,
        builder: (c, snapshot) {
          switch (snapshot.data) {
            case ViewMode.NOTHING:
              return Container();
            case ViewMode.ADD:
              return getModeAddMenu();
            case ViewMode.COLOR:
              return getModeColorsMenu();
          }
          return Container();
        },
      );

  Widget getCurrentMenu() => StreamBuilder<DrawerMode>(
        stream: bloc.currentDrawerModeStream,
        builder: (c, snapshot) {
          switch (snapshot.data?.modeType) {
            case ModeType.NOTHING:
              return getBasicMenu();
            case ModeType.SELECT:
              return getSelectedMenu();
            case ModeType.ADD:
              return getInfoContainer(
                snapshot.data?.item?.creatingText ?? '',
              );
          }
          return Container();
        },
      );

  Widget getInfoContainer(String text) => getBlueContainer(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Widget getBasicMenu() => getBlueContainer(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 0.0),
              child: getActionItem(
                icon: Icons.add,
                text: R.string.add,
                onTap: () {
                  bloc.viewMode = bloc.viewMode == ViewMode.ADD
                      ? ViewMode.NOTHING
                      : ViewMode.ADD;
                  setState(() {
                    bloc.addingMemo = false;
                  });
                },
              ),
            ),
          ],
        ),
      );

  Widget getSelectedMenu() => getBlueContainer(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getActionItem(
                icon: Icons.delete,
                text: R.string.delete,
                onTap: () {
                  bloc.deleteCurrentItem();
                }),
            getActionItem(
                icon: Icons.color_lens,
                text: R.string.color,
                onTap: () {
                  bloc.viewMode = ViewMode.COLOR;
                }),
            getActionItem(
                icon: Icons.text_fields,
                text: R.string.text,
                onTap: () {
                  showTextDialog(bloc.itemsToDraw.selectedItem?.text);
                }),
            getActionItem(
                icon: Icons.done,
                text: R.string.done,
                onTap: () {
                  bloc.viewMode = ViewMode.NOTHING;
                  bloc.currentDrawerMode = DrawerMode.nothing();
                }),
          ],
        ),
      );

  Widget getActionItem({
    IconData icon,
    String text,
    Color color = Colors.white,
    Function onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
              ),
              Text(
                text,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      );

  saveScreenshot(BuildContext context) async {
    final fileName = '${CalendarUtils.getTimeIdBasedSeconds()}.png';
    final directory = await FileUtils.getRootFilesDir();
    File imgFile = File('$directory/$fileName');
    bloc.savingScreenShot = true;

    bloc.articleModel.screenShootFilePath = imgFile.path;
    bloc.articleModel.createdOnScreenShoot =
        CalendarUtils.getDateTimeFromString(fileName);
    await takeScreenShot(
        context: context,
        previewContainer: previewContainer,
        pixelRatio: 2,
        file: imgFile);

    if(!widget.autoSave ?? true)
      NavigationUtils.pop(context, result: imgFile.path);
    else{
      await bloc.saveScreeShoot();

//    bloc.screenShotFile = screenShotFileName;
      bloc.savingScreenShot = false;

      NavigationUtils.pushCupertino(
        context,
        ArticleLocalDetailPage(
          articleLocalModel: bloc.articleModel,
          isForMail: widget.isForMail,
        ),
      );
    }
  }

//  saveAndShare(BuildContext context) async {
//    await saveScreenshot(context);
//    if (bloc.screenShotFile != null)
//      await EsysFlutterShare.shareFile(bloc.screenShotFile, 'Share image');
//  }

  showTextDialog(String value) {
    TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(R.string.changeText),
          content: TextField(
            controller: controller,
          ),
          actions: [
            FlatButton(
              child: Text(R.string.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(R.string.ok),
              onPressed: () {
                bloc.updateText(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Positioned> _getMemos(List<MemoModel> memosList) {
    List<Positioned> list = [];
    memosList.forEach((element) {
      final w = Positioned(
        left: element.xPos,
        top: element.yPos,
        child: InkWell(
          onTap: () async {
            _navigateToMemo(element);
          },
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            padding: EdgeInsets.all(5),
            child: Image.asset(element is MemoNoteModel
                ? R.image.noteText
                : (element is MemoAudioModel
                    ? R.image.noteAudio
                    : R.image.noteVideo)),
          ),
        ),
      );
      list.add(w);
    });
    return list;
  }

  void initMemoListener() {
    bloc.memoResult.listen((offset) async {
      bloc.viewMode = ViewMode.NOTHING;
      bloc.currentDrawerMode = DrawerMode.nothing();
      setState(() {
        bloc.addingMemo = false;
      });
      MemoModel model = bloc.currentMemoType == MemoType.Note
          ? MemoNoteModel()
          : (bloc.currentMemoType == MemoType.Audio
              ? MemoAudioModel()
              : MemoVideoModel());
      model.id = CalendarUtils.getTimeIdBasedSeconds();
      model.yPos = offset.dy;
      model.xPos = offset.dx;

      _navigateToMemo(model);
    });
  }

  void _navigateToMemo(MemoModel model) async {
    if (model is MemoNoteModel) {
      final res = await NavigationUtils.push(
          context,
          NotePage(
            model: model,
          ));
      bloc.syncMemo(res);
    } else if (model is MemoAudioModel) {
      final res = await NavigationUtils.push(
          context,
          AudioPage(
            model: model,
          ));
      bloc.syncMemo(res);
    } else if (model is MemoVideoModel) {
//      _showDialogVideoPicker(option: (opt) async {
//
//      });

      if(model.filePath.isEmpty){
        model.filePath = (await ImagePicker.pickVideo(source: ImageSource.camera)).path;
      }
      if (model.filePath.isNotEmpty){
        final res = await NavigationUtils.push(
            context,
            VideoPage(
              model: model,
            ));
        bloc.syncMemo(res);
      }

    }
  }

  Widget getBottomMemoBar() {
    return Container(
      width: double.infinity,
      color: R.color.gray_light,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: TXIconButtonWidget(
                icon: Image.asset(R.image.noteTextWhite,
                    color: R.color.primary_color),
                onPressed: () async {
                  bloc.currentMemoType = MemoType.Note;
                  _showDialogInfo(
                      content: R.string.tapImageAddText);
                },
              )),
          Expanded(
              flex: 1,
              child: TXIconButtonWidget(
                icon: Image.asset(R.image.noteAudioWhite,
                    color: R.color.primary_color),
                onPressed: () async {
                  bloc.currentMemoType = MemoType.Audio;
                  _showDialogInfo(
                      content: R.string.tapImageAddRecord);
                },
              )),
          Expanded(
              flex: 1,
              child: TXIconButtonWidget(
                icon: Image.asset(
                  R.image.noteVideoWhite,
                  color: R.color.primary_color,
                ),
                onPressed: () async {
                  bloc.currentMemoType = MemoType.Video;
                  _showDialogInfo(
                      content: R.string.tapImageAddVideo);
                },
              )),
        ],
      ),
    );
  }

  void _showDialogInfo({String content}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.addMemo,
        content: content,
        onOK: () {
          NavigationUtils.pop(context);
        },
      ),
    );
  }

  void _showDialogVideoPicker({ValueChanged<int> option}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: CupertinoDialogAction(
          child: Container(
            child: TXTextWidget(
              text: R.string.chooseFromGallery,
            ),
          ),
          onPressed: () {
            NavigationUtils.pop(context);
//            option(1);
          },
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: TXTextWidget(
                text: R.string.takeVideo,
              ),
            ),
            onPressed: () {
              NavigationUtils.pop(context);
//              option(2);
            },
          )
        ],
      ),
    );
  }
}
