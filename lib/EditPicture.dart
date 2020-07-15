import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

//import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_ui.dart';
import 'package:repairservices/ui/marker_component/glass_data.dart';
import 'package:repairservices/ui/marker_component/items/item_angle.dart';
import 'package:repairservices/ui/marker_component/items/item_line.dart';
import 'package:repairservices/ui/marker_component/items_data.dart';
import 'package:repairservices/ui/marker_component/painters/drawer_canvas_painter.dart';
import 'package:repairservices/ui/marker_component/painters/magnifying_glass_painter.dart';
import 'package:repairservices/ui/marker_component/utils/take_screenshoot.dart';
//import 'package:webview_flutter/webview_flutter.dart';
//import 'package:repairservices/Utils/Arrow.dart';
import 'package:repairservices/res/R.dart';

class EditPicture extends StatefulWidget {
  final File selectedImage;
  final bool sendByEmail;

  EditPicture(this.selectedImage, this.sendByEmail);

  @override
  State<StatefulWidget> createState() => _EditPictureState();
}

class _EditPictureState extends StateWithBloC<EditPicture, DrawerToolBloc> with TickerProviderStateMixin{
  MeasurementObject _measurementObj;

  bool drawing = false;

  TextEditingController titleCtr = TextEditingController();

  AnimationController _controllerOptionBar;
  AnimationController _controllerDimensionsBar;
  Animation<Offset> _offsetDimensionBar;
  Animation<Offset> _offsetOptionBar;

  GlobalKey _keyImage = GlobalKey();

  @override
  initState() {
    super.initState();

    titleCtr.text = 'Picture 1';
    _controllerOptionBar =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controllerDimensionsBar = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _offsetOptionBar =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 2.0))
            .animate(_controllerOptionBar);

    _offsetDimensionBar =
        Tween<Offset>(begin: Offset(0.0, 2.0), end: Offset.zero)
            .animate(_controllerDimensionsBar);
  }

  Widget _optionBar() {
    return SlideTransition(
      position: _offsetOptionBar,
      child: Container(
        margin: EdgeInsets.only(left: 0, top: 0),
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new InkWell(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: new Image.asset('assets/lettersWhite.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: new Text(
                      R.string.photoTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.5),
                    ),
                  )
                ],
              ),
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: new Text(R.string.changeArticleName,
                              style: Theme.of(context).textTheme.subtitle1),
                          content: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: new CupertinoTextField(
                                textAlign: TextAlign.left,
                                expands: false,
                                style: Theme.of(context).textTheme.bodyText2,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                controller: titleCtr,
                                placeholder: R.string.articleImage,
                              )),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: new Text(R.string.cancel,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: new Text(R.string.ok,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                          ],
                        ));
              },
            ),
            new InkWell(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: new Image.asset('assets/drawingWhite.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: new Text(
                      R.string.dimensions,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.5),
                    ),
                  )
                ],
              ),
              onTap: () {
                switch (_controllerDimensionsBar.status) {
                  case AnimationStatus.completed:
                    _controllerDimensionsBar.reverse();
                    break;
                  case AnimationStatus.dismissed:
                    _controllerDimensionsBar.forward();
                    break;
                  default:
                }
              },
            ),
            new InkWell(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: new Image.asset('assets/notebookWhite.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: new Text(
                      'Memo',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.5),
                    ),
                  )
                ],
              ),
              onTap: () {},
            ),
            new InkWell(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 7),
                    child: new Image.asset('assets/folderWhite.png'),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: new Text(
                        'Folders',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            letterSpacing: 0.5),
                      ))
                ],
              ),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget _dimensionBar() {
    return SlideTransition(
        position: _offsetDimensionBar,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(139, 138, 141, 1),
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new InkWell(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: new Image.asset('assets/arrowWhite.png'),
                    ),
                    new Text(
                      R.string.headArrow1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.5),
                    )
                  ],
                ),
                onTap: () {
                  _measurementObj = MeasurementObject.arrow1Head;
                  _controllerDimensionsBar.reverse();
                  debugPrint('arrow 1 head');
                  bloc.addLine(ItemLine(
                    color: Colors.green,
                    creatingText: R.string.drawTheLine,
                    startArrow: false,
                    endArrow: true,
                  ));
//                canvas.add(getNewCanvas());
                  setState(() {});
                },
              ),
              new InkWell(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: new Image.asset('assets/doubleArrowWhite.png'),
                    ),
                    new Text(
                      R.string.headArrow2,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.5),
                    )
                  ],
                ),
                onTap: () {
                  _measurementObj = MeasurementObject.arrow2Head;
                  _controllerDimensionsBar.reverse();
                  bloc.addLine(ItemLine(
                    color: Colors.green,
                    creatingText: R.string.drawTheLine,
                    startArrow: false,
                    endArrow: true,
                  ));
                },
              ),
              new InkWell(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: new Image.asset('assets/protractorGreyBlock.png'),
                    ),
                    new Text(
                      R.string.angle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.5),
                    )
                  ],
                ),
                onTap: () {
                  _measurementObj = MeasurementObject.angle;
                  _controllerDimensionsBar.reverse();
                  bloc.addLine(ItemAngle(
                    color: Colors.green,
                    creatingText: R.string.drawTheLine,
                  ));
                },
              ),
            ],
          ),
        ));
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.editPicture, style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          InkWell(
            child: Image.asset(
              'assets/checkGreen.png',
              height: 25,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(titleCtr.text,
                      style: TextStyle(
                          fontSize: 17, color: Theme.of(context).primaryColor)))
            ],
          ),
          Expanded(
              child: Container(
            color: Colors.black,
            child: getImageContent(context),
          )),
          Container(
            height: 120,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                _dimensionBar(),
                _optionBar(),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget getImageContent(BuildContext context){
    return Container(
      child: GestureDetector(
        onPanStart: (d) {
          onTouchUpdate(context, d.globalPosition, EventType.START);
        },
        onPanUpdate: (d) {
          onTouchUpdate(context, d.globalPosition, EventType.UPDATE);
        },
        onPanCancel: () {
          onTouchUpdate(context, null, EventType.END);
        },
        onPanEnd: (d) {
          onTouchUpdate(context, null, EventType.END);
        },
        child: Stack(
          children: [
            RepaintBoundary(
                key: _keyImage,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      getImageView(),
                      getPainter(context),
                    ],
                  ),
                )),
            getMagnifierGlass(context),
          ],
        ),
      ),
    );
  }

  onTouchUpdate(
      BuildContext context, Offset touchedPosition, EventType eventType) async {

    await bloc.onTouchUpdate(
      touchedPosition?.translate(0, -70),
      eventType,
    );

    bloc.glassData = GlassData(
      circlePosition: touchedPosition,
      previewImage: await getBitmap(
        context: context,
        previewContainer: _keyImage,
      ),
    );
  }

  Widget getImageView() => widget.selectedImage != null
      ? Image.file(
    widget.selectedImage,
    height: double.infinity,
    width: double.infinity,
    fit: BoxFit.contain,
  )
      : Container();

  Widget getPainter(BuildContext context) => StreamBuilder<ItemsData>(
    initialData: ItemsData.empty(),
    builder: (c, snapshot) {
      return CustomPaint(
        painter: DrawerCanvasPainter(
          items: snapshot.data.items,
          selectedItem: snapshot.data.selectedItem,
        ),
      );
    },
  );

  Widget getMagnifierGlass(BuildContext context) => StreamBuilder<GlassData>(
    builder: (c, snapshot) {
      return snapshot.data?.circlePosition != null &&
          snapshot.data?.previewImage != null
          ? CustomPaint(
        painter: MagnifyingGlassPainter(
          position:
          snapshot.data?.circlePosition?.translate(0, -70),
          image: snapshot.data?.previewImage,
          maxPosition: MediaQuery.of(context).size.bottomRight(
            Offset(0, 0).translate(0, -70),
          ),
        ),
      )
          : Container();
    },
  );
}

enum MeasurementObject { arrow1Head, arrow2Head, angle }
