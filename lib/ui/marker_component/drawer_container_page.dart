import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/di/injector.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_page.dart';
import 'package:repairservices/ui/marker_component/drawer_container_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_ui.dart';
import 'package:repairservices/ui/marker_component/items/item_angle.dart';
import 'package:repairservices/ui/marker_component/items/item_line.dart';
import 'package:repairservices/ui/marker_component/utils/take_screenshoot.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawerContainerPage extends StatefulWidget {
  final String imagePath;

  const DrawerContainerPage({Key key, @required this.imagePath})
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
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text("Edit Picture", style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: getActions(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Text(titleCtr.text,
                    style: TextStyle(
                        fontSize: 17, color: Theme.of(context).primaryColor)),
                StreamBuilder<File>(
                  stream: bloc.selectedImageStream,
                  builder: (c, snap) {
                    return DrawerToolUI(
                      selectedImage: snap.data,
                      previewContainer: previewContainer,
                      backgroundColor: Colors.white,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      getSecondLayerMenu(),
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
            text: '1 Arrow',
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.addLine(
                ItemLine(
                  color: Colors.green,
                  creatingText: 'Draw the line',
                  startArrow: false,
                  endArrow: true,
                ),
              );
            },
          ),
          getActionItem(
            icon: MdiIcons.arrowLeftRightBoldOutline,
            text: '2 Arrows',
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.addLine(
                ItemLine(
                  color: Colors.green,
                  creatingText: 'Draw the line',
                  startArrow: true,
                  endArrow: true,
                ),
              );
            },
          ),
          getActionItem(
            icon: MdiIcons.angleAcute,
            text: 'Angle',
            onTap: () {
              bloc.viewMode = ViewMode.NOTHING;
              bloc.addLine(
                ItemAngle(
                  color: Colors.green,
                  creatingText: 'Draw the line',
                ),
              );
            },
          ),
          getActionItem(
            icon: MdiIcons.noteOutline,
            text: 'Memo',
            onTap: () {},
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
            getActionItem(
              icon: Icons.add,
              text: 'Add',
              onTap: () {
                bloc.viewMode = ViewMode.ADD;
              },
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
                text: 'Delete',
                onTap: () {
                  bloc.deleteCurrentItem();
                }),
            getActionItem(
                icon: Icons.color_lens,
                text: 'Color',
                onTap: () {
                  bloc.viewMode = ViewMode.COLOR;
                }),
            getActionItem(
                icon: Icons.text_fields,
                text: 'Text',
                onTap: () {
                  showTextDialog(bloc.itemsToDraw.selectedItem?.text);
                }),
            getActionItem(
                icon: Icons.done,
                text: 'Done',
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
          width: 80,
          height: 50,
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
    bloc.savingScreenShot = true;
    final screenShotFileName = await takeScreenShot(
      context: context,
      previewContainer: previewContainer,
      pixelRatio: 2,
      fileName: fileName
    );

    bloc.saveScreeShoot(screenShotFileName);

    bloc.screenShotFile = screenShotFileName;
    bloc.savingScreenShot = false;

    NavigationUtils.push(context, ArticleLocalDetailPage(filePath: screenShotFileName,));
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
          title: Text('Change Text'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
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
}
