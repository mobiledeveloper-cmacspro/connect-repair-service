import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/DoorLockGeneralData.dart';
import 'package:repairservices/LockDimensionsBlock.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:flutter/rendering.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_lock.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

import 'database_helpers.dart';

class LockDimensions extends StatefulWidget {
  final DoorLock doorLock;

  const LockDimensions(this.doorLock);

  @override
  State<StatefulWidget> createState() {
    return LockDimensionsState(this.doorLock);
  }
}

class LockDimensionsState extends StateWithBloC<LockDimensions,LockDimensionsBloc> {
  DoorLock doorLock;

  LockDimensionsState(this.doorLock);

//  bool filled = false;
  PageController pageController;
  FocusNode aNode, bNode, cNode, dNode, eNode, fNode;
  final aCtr = TextEditingController();
  final bCtr = TextEditingController();
  final cCtr = TextEditingController();
  final dCtr = TextEditingController();
  final eCtr = TextEditingController();
  final fCtr = TextEditingController();
  final dimensionCtr = TextEditingController();
  var imageKey1 = new GlobalKey();
  var imageKey2 = new GlobalKey();
  var imageKey3 = new GlobalKey();
  String imagePath1, imagePath2, imagePath3;
  File dimensionImage1, dimensionImage2, dimensionImage3;

  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    aNode = FocusNode();
    bNode = FocusNode();
    cNode = FocusNode();
    dNode = FocusNode();
    eNode = FocusNode();
    fNode = FocusNode();
    Future.delayed(Duration(seconds: 1), () async {
      await takeScreenShoot(imageKey1, 1);
    });
  }

  @override
  void dispose() {
    aNode.dispose();
    bNode.dispose();
    cNode.dispose();
    dNode.dispose();
    eNode.dispose();
    fNode.dispose();
    super.dispose();
  }

  void _changeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  _changeDimension(BuildContext context, String dimension) {
    dimensionCtr.text = "";
    showAlertDialogDimension(context, dimension);
  }

  void showAlertDialog(BuildContext context, String title, String textButton) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(
                title,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: new Text(textButton,
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: new Text(R.string.cancel),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  void showAlertDialogDimension(BuildContext context, String dimension) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(
                  R.string.dimension + ' $dimension'),
              content: new Container(
                  margin: EdgeInsets.only(top: 16),
                  child: new CupertinoTextField(
                    textAlign: TextAlign.left,
                    expands: false,
                    style: Theme.of(context).textTheme.bodyText2,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    controller: dimensionCtr,
                    placeholder: 'mm',
                  )),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: new Text('OK',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      if (dimensionCtr.text != "" &&
                          int.parse(dimensionCtr.text) != 0) {
                        switch (dimension) {
                          case 'A':
                            aCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimA(aCtr.text);
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () async {
                              await takeScreenShoot(imageKey1, 1);
                            });
                            break;
                          case 'B':
                            bCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimB(bCtr.text);
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () async {
                              await takeScreenShoot(imageKey1, 1);
                            });
                            break;
                          case 'C':
                            cCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimC(cCtr.text);
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () async {
                              await takeScreenShoot(imageKey1, 1);
                            });
                            break;
                          case 'D':
                            dCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimD(dCtr.text);
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () async {
                              await takeScreenShoot(imageKey2, 2);
                            });
                            break;
                          case 'E':
                            eCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimE(eCtr.text);
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () async {
                              await takeScreenShoot(imageKey2, 2);
                            });
                            break;
                          default:
                            fCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimF(fCtr.text);
                            setState(() {});
                            Future.delayed(Duration(seconds: 1), () async {
                              await takeScreenShoot(imageKey3, 3);
                            });
                        }
                      } else {
//                    Navigator.pop(context);
                        showAlertDialog(context, R.string.zeroNotValueForDimension, "OK");
                      }
                    }),
                CupertinoDialogAction(
                  child: new Text(R.string.cancel),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Future<void> takeScreenShoot(GlobalKey key, int dimensionImage) async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData.buffer;
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds(withTempPrefix: true);
    final path = '$directory/$fileName.png';

    File(path).writeAsBytesSync(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    ///Removing previous screen shoot if exist
    final String previousPath = dimensionImage == 1
        ? imagePath1
        : (dimensionImage == 2 ? imagePath2 : imagePath3);
    if (previousPath?.isNotEmpty == true &&
        previousPath?.endsWith('.png') == true) {
      File preFile = File(previousPath);
      if (await preFile.exists()) {
        await preFile.delete();
      }
    }

    switch (dimensionImage) {
      case 1:
        imagePath1 = path;
        break;
      case 2:
        imagePath2 = path;
        break;
      default:
        imagePath3 = path;
        break;
    }
  }

  _saveArticle() async {
    doorLock.pdfPath = await PDFManagerDoorLock.getPDFPath(doorLock);
    debugPrint(doorLock.pdfPath);
    int id = await helper.insertDoorLock(doorLock);
    print('inserted row: $id');
    if (id != null) {
      NavigationUtils.pushCupertino(context, FittingPDFViewerPage(model: doorLock,));
//      Navigator.push(
//          context,
//          CupertinoPageRoute(
//              builder: (context) => ArticleWebPreview(doorLock)));
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    List<Widget> pages = [
      //First Page
      Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    RepaintBoundary(
                      key: imageKey1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 320,
                            height: 344,
                            margin: EdgeInsets.only(top: 16, bottom: 8),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Image.asset(
                                        'assets/lockDimensionPage1.png'),
                                  ),
                                ),
                                Positioned(
                                  right: 87,
                                  top: 47,
                                  child: Container(
                                    width: 22,
                                    height: 41,
                                    child: InkWell(
                                      onTap: () =>
                                          _changeDimension(context, 'A'),
                                      child: FittedBox(
                                        child: StreamBuilder<String>(
                                          stream: bloc.dimAStream,
                                          initialData: "",
                                          builder: (context, snapshot){
                                            return Text(
                                                snapshot.data != "" ? snapshot.data : "A",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 55,
                                  top: 94,
                                  child: Container(
                                    width: 24,
                                    height: 61,
                                    child: InkWell(
                                      onTap: () =>
                                          _changeDimension(context, 'B'),
                                      child: FittedBox(
                                        child: StreamBuilder<String>(
                                          stream: bloc.dimBStream,
                                          initialData: "",
                                          builder: (context, snapshot) {
                                            return Text(
                                                snapshot.data != "" ? snapshot.data : "B",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 86,
                                  top: 149,
                                  child: Container(
                                    width: 22,
                                    height: 41,
                                    child: InkWell(
                                        onTap: () =>
                                            _changeDimension(context, 'C'),
                                        child: FittedBox(
                                          child: StreamBuilder<String>(
                                            stream: bloc.dimCStream,
                                            initialData: "",
                                            builder: (context, snapshot){
                                              return Text(
                                                  snapshot.data != "" ? snapshot.data : "C",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1);
                                            },
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: StreamBuilder<String>(
                        stream: bloc.dimAStream,
                        initialData: "",
                        builder: (context, snapshot){
                          return Text('A',
                              style: snapshot.data == ""
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left);
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: new TextField(
                        onChanged: (value) {
                          bloc.dimA(value);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey1, 1);
                          });
                        },
                        focusNode: aNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: aCtr,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (next) {
                          bloc.dimA(aCtr.text);
                          _changeFocus(context, aNode, bNode);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey1, 1);
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: StreamBuilder<String>(
                        stream: bloc.dimBStream,
                        initialData: "",
                        builder: (context, snapshot){
                          return Text('B',
                              style: snapshot.data == ""
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left);
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                      child: new TextField(
                        onChanged: (value) {
                          bloc.dimB(value);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey1, 1);
                          });
                        },
                        focusNode: bNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: bCtr,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (next) {
                          bloc.dimB(bCtr.text);
                          _changeFocus(context, bNode, cNode);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey1, 1);
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: StreamBuilder<String>(
                        stream: bloc.dimCStream,
                        initialData: "",
                        builder: (context, snapshot){
                          return Text('C',
                              style: snapshot.data == ""
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left);
                        }
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                      child: new TextField(
                        onChanged: (value) {
                          bloc.dimC(value);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey1, 1);
                          });
                        },
                        focusNode: cNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: cCtr,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) {
                          bloc.dimC(cCtr.text);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey1, 1);
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              )
            ],
          )),

      //Second Page
      Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    RepaintBoundary(
                      key: imageKey2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 320,
                            height: 344,
                            margin: EdgeInsets.only(top: 16, bottom: 8),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Image.asset(
                                        'assets/lockDimensionPage2.png'),
                                  ),
                                ),
                                Positioned(
                                  left: 82,
                                  top: 93,
                                  child: Container(
                                    width: 22,
                                    height: 60,
                                    child: InkWell(
                                        onTap: () =>
                                            _changeDimension(context, 'D'),
                                        child: FittedBox(
                                          child: StreamBuilder<String>(
                                            stream: bloc.dimDStream,
                                            initialData: "",
                                            builder: (context, snapshot) {
                                              return Text(
                                                  snapshot.data != "" ? snapshot.data : "D",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1);
                                            },
                                          ),
                                        )),
                                  ),
                                ),
                                Positioned(
                                  right: 56,
                                  bottom: 2,
                                  child: Container(
                                    width: 54,
                                    height: 31,
                                    child: InkWell(
                                        onTap: () =>
                                            _changeDimension(context, 'E'),
                                        child: FittedBox(
                                          child: StreamBuilder<String>(
                                            stream: bloc.dimEStream,
                                            initialData: "",
                                           builder: (context, snapshot) {
                                              return Text(
                                                  snapshot.data != "" ? snapshot.data : "E",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1);
                                           }
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: StreamBuilder<String>(
                        stream: bloc.dimDStream,
                        initialData: "",
                        builder: (context, snapshot) {
                          return Text('D',
                              style: snapshot.data == ""
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left);
                        }
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: new TextField(
                        onChanged: (value) {
                          bloc.dimD(value);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey2, 2);
                          });
                        },
                        focusNode: dNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: dCtr,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (next) {
                          bloc.dimD(dCtr.text);
                          _changeFocus(context, dNode, eNode);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey2, 2);
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: StreamBuilder<String>(
                        stream: bloc.dimEStream,
                        initialData: "",
                        builder: (context, snapshot){
                          return Text('E',
                              style: snapshot.data == ""
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left);
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                      child: new TextField(
                        onChanged: (value) async {
                          bloc.dimE(value);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey2, 2);
                          });
                        },
                        focusNode: eNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: eCtr,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) {
                          bloc.dimE(eCtr.text);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey2, 2);
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              )
            ],
          )),

      //Thirst Page
      Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    RepaintBoundary(
                      key: imageKey3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 320,
                            height: 344,
                            margin: EdgeInsets.only(top: 16, bottom: 8),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Image.asset(
                                        'assets/lockDimensionPage3.png'),
                                  ),
                                ),
                                Positioned(
                                  left: 36,
                                  bottom: 92,
                                  child: Container(
                                    width: 80,
                                    height: 41,
                                    child: InkWell(
                                        onTap: () =>
                                            _changeDimension(context, 'F'),
                                        child: FittedBox(
                                          child: StreamBuilder<String>(
                                            stream: bloc.dimFStream,
                                            initialData: "",
                                            builder: (context, snapshot) {
                                              return Text(
                                                  snapshot.data != "" ? snapshot.data : "F",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body1);
                                            },
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: StreamBuilder<String>(
                        stream: bloc.dimFStream,
                        initialData: "",
                        builder: (context, snapshot) {
                          return Text('F',
                              style: snapshot.data == ""
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left);
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                      child: new TextField(
                        onChanged: (value) {
                          bloc.dimF(value);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey3, 3);
                          });
                        },
                        focusNode: fNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        controller: fCtr,
                        onSubmitted: (_) {
                          bloc.dimF(fCtr.text);
                          Future.delayed(Duration(seconds: 1), () async {
                            await takeScreenShoot(imageKey3, 3);
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              )
            ],
          ))
    ];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(R.string.lockDimensions,
              style: Theme.of(context).textTheme.bodyText2),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
          ),
          actions: <Widget>[
            StreamBuilder<bool>(
              stream: bloc.pagesVisitedStream,
              initialData: false,
              builder: (context, snapshot) {
                return InkWell(
                  child: Image.asset(
                    snapshot.data ? 'assets/checkGreen.png' : 'assets/checkGrey.png',
                    height: 25,
                  ),
                  onTap: snapshot.data ? () {
                    /* final doorLock = DoorLock.withData(
                    R.string.doorLockFitting,
                    DateTime.now(),
                    aCtr.text,
                    bCtr.text,
                    cCtr.text,
                    dCtr.text,
                    eCtr.text,
                    fCtr.text,
                    imagePath1,
                    imagePath2,
                    imagePath3);*/
                    doorLock.name = R.string.doorLockFitting;
                    doorLock.created = DateTime.now();
                    doorLock.dimensionA = aCtr.text;
                    doorLock.dimensionB = bCtr.text;
                    doorLock.dimensionC = cCtr.text;
                    doorLock.dimensionD = dCtr.text;
                    doorLock.dimensionE = eCtr.text;
                    doorLock.dimensionF = fCtr.text;
                    doorLock.dimensionImage1Path = imagePath1;
                    doorLock.dimensionImage2Path = imagePath2;
                    doorLock.dimensionImage3Path = imagePath3;

                    //Navigator.push(context, CupertinoPageRoute(builder: (context) => DoorLockGeneralData(doorLock)));

                    _saveArticle();
                  } : null,
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  if (index == pages.length - 1){
                    bloc.pagesVisited(true);
                  }
                  if (index == 1 && imagePath2 == null) {
                    Future.delayed(Duration(seconds: 1), () async {
                      await takeScreenShoot(imageKey2, 2);
                    });
                  } else if (index == 2 && imagePath3 == null) {
                    Future.delayed(Duration(seconds: 1), () async {
                      await takeScreenShoot(imageKey3, 3);
                    });
                  }
                  bloc.pageIndex(index);
                },
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            ),
            Container(
              color: Colors.white,
              height: 40,
              child: Center(
 //                 child: Indicator(
 //               controller: pageController,
 //               itemCount: pages.length,
 //               dotSizeBorder: 1,
 //               normalColor: Colors.white,
 //               selectedColor: Theme.of(context).primaryColor,
 //             )
                 child: _createIndicator(pages.length, Colors.white, Theme.of(context).primaryColor, 1),
              ),
            )
          ],
        ));
  }

  Widget _buildIndicator(
      int index, int pageCount, double dotSize, double size, double spacing, double dotSizeBorder, Color normalColor, Color selectedColor) {
    // Is the current page selected?
    //bool isCurrentPageSelected = index == (widget.controller.page != null ? widget.controller.page.round() % pageCount : 0);

    return new Container(
      height: size,
      width: size + (2 * spacing),
      child: new Center(
        child: StreamBuilder<int>(
          stream: bloc.pageIndexStream,
          initialData: 0,
          builder: (context, snapshot) {
            return Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                  border: Border.all(color: selectedColor, width: dotSizeBorder),
                  color: snapshot.data == index ? selectedColor : normalColor,
                  borderRadius: BorderRadius.circular(dotSize / 2)),
            );
          },
        ),
      ),
    );
  }

  Widget _createIndicator(int itemCount, Color normalColor, Color selectedColor, double dotSizeBorder) {
    /// Size of points
    final double size = 8.0;

    /// Spacing of points
    final double spacing = 4.0;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, size, spacing, dotSizeBorder, normalColor, selectedColor);
      }),
    );
  }

}

