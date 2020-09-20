import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:screenshot/screenshot.dart';
import 'package:swipedetector/swipedetector.dart';

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
  ScreenshotController _sc1 = ScreenshotController();
  ScreenshotController _sc2 = ScreenshotController();
  ScreenshotController _sc3 = ScreenshotController();
  String imagePath1, imagePath2, imagePath3;

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
//    Future.delayed(Duration(seconds: 0), () async {
//      await takeScreenShoot(_sc1, 1);
//    });
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

//  void _changeFocus(
//      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
//    currentNode.unfocus();
//    FocusScope.of(context).requestFocus(nextNode);
//  }

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
                    onPressed: () async {
                      Navigator.pop(context);
                      if (dimensionCtr.text != "" &&
                          int.parse(dimensionCtr.text) != 0) {
                        switch (dimension) {
                          case 'A':
                            aCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimA(dim: aCtr.text);
                            setState(() {});
                            //await takeScreenShoot(_sc1, 1);
                            break;
                          case 'B':
                            bCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimB(dim: bCtr.text);
                            setState(() {});
                            //await takeScreenShoot(_sc1, 1);
                            break;
                          case 'C':
                            cCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimC(dim: cCtr.text);
                            setState(() {});
                            //await takeScreenShoot(_sc1, 1);
                            break;
                          case 'D':
                            dCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimD(dim: dCtr.text);
                            setState(() {});
                            //await takeScreenShoot(_sc2, 2);
                            break;
                          case 'E':
                            eCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimE(dim: eCtr.text);
                            setState(() {});
                            //await takeScreenShoot(_sc2, 2);
                            break;
                          default:
                            fCtr.text = int.parse(dimensionCtr.text).toString();
                            bloc.dimF(dim: fCtr.text);
                            setState(() {});
                            //await takeScreenShoot(_sc3, 3);
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

  Future<void> takeScreenShoot(ScreenshotController controller, int dimensionImage) async {
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();

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

    await controller.capture(
        path: '$directory/$fileName.png',
        delay: Duration(milliseconds: 10)).then((File image) {
      String path = image.path;
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
    }).catchError((onError) {
      print(onError);
    });
  }

  _saveArticle() async {
    doorLock.pdfPath = await PDFManagerDoorLock.getPDFPath(doorLock);
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
      SwipeDetector(
        onSwipeLeft: () {
          takeScreenShoot(_sc1, 1).then((value) {
            pageController.animateToPage(1,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Screenshot(
                        controller: _sc1,
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
                        padding: EdgeInsets.only(left: 16),
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
                          onChanged: (value) async {
                            bloc.dimA(dim: value);
                            //await takeScreenShoot(_sc1, 1);
                          },
                          focusNode: aNode,
                          textAlign: TextAlign.left,
                          expands: false,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          controller: aCtr,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
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
                          onChanged: (value) async {
                            bloc.dimB(dim: value);
                            //await takeScreenShoot(_sc1, 1);
                          },
                          focusNode: bNode,
                          textAlign: TextAlign.left,
                          expands: false,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          controller: bCtr,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
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
                          onChanged: (value) async {
                            bloc.dimC(dim: value);
                            //await takeScreenShoot(_sc1, 1);
                          },
                          focusNode: cNode,
                          textAlign: TextAlign.left,
                          expands: false,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          controller: cCtr,
                          keyboardType: TextInputType.number,
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
      ),

      //Second Page
      SwipeDetector(
        onSwipeRight: () {
          takeScreenShoot(_sc2, 2).then((value) {
            pageController.animateToPage(0,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
        onSwipeLeft: () {
          takeScreenShoot(_sc2, 2).then((value) {
            pageController.animateToPage(2,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Screenshot(
                        controller: _sc2,
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
                          onChanged: (value) async {
                            bloc.dimD(dim: value);
                            //await takeScreenShoot(_sc2, 2);
                          },
                          focusNode: dNode,
                          textAlign: TextAlign.left,
                          expands: false,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          controller: dCtr,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
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
                            bloc.dimE(dim: value);
                            //await takeScreenShoot(_sc2, 2);
                          },
                          focusNode: eNode,
                          textAlign: TextAlign.left,
                          expands: false,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          controller: eCtr,
                          keyboardType: TextInputType.number,
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
      ),

      //Thirst Page
      SwipeDetector(
        onSwipeRight: () {
          takeScreenShoot(_sc3, 3).then((value) {
            pageController.animateToPage(1,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Screenshot(
                        controller: _sc3,
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
                          onChanged: (value) async {
                            bloc.dimF(dim: value);
                            //await takeScreenShoot(_sc3, 3);
                          },
                          focusNode: fNode,
                          textAlign: TextAlign.left,
                          expands: false,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          controller: fCtr,
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
      ),
    ];

    void _navBack(){
      if(imagePath1 != null && imagePath1.isNotEmpty && imagePath1.endsWith('png')){
        File f = File(imagePath1);
        if(f.existsSync()) f.deleteSync();
      }
      if(imagePath2 != null && imagePath2.isNotEmpty && imagePath2.endsWith('png')){
        File f = File(imagePath2);
        if(f.existsSync()) f.deleteSync();
      }
      if(imagePath3 != null && imagePath3.isNotEmpty && imagePath3.endsWith('png')){
        File f = File(imagePath3);
        if(f.existsSync()) f.deleteSync();
      }
      NavigationUtils.pop(context);
    }

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
              _navBack();
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
                  onTap: snapshot.data ? () async {


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

                    switch(bloc.currentPage){
                      case 0:
                        takeScreenShoot(_sc1, 1).then((value) {
                          doorLock.dimensionImage1Path = imagePath1;
                          doorLock.dimensionImage2Path = imagePath2;
                          doorLock.dimensionImage3Path = imagePath3;
                          _saveArticle();
                        });
                        break;
                      case 1:
                        takeScreenShoot(_sc2, 2).then((value) {
                          doorLock.dimensionImage1Path = imagePath1;
                          doorLock.dimensionImage2Path = imagePath2;
                          doorLock.dimensionImage3Path = imagePath3;
                          _saveArticle();
                        });
                        break;
                      default:
                        takeScreenShoot(_sc3, 3).then((value) {
                          doorLock.dimensionImage1Path = imagePath1;
                          doorLock.dimensionImage2Path = imagePath2;
                          doorLock.dimensionImage3Path = imagePath3;
                          _saveArticle();
                        });
                        break;
                    }

                  } : () {},
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) async {
                  bloc.pageIndex(index);
                  debugPrint("page: $index");
                  if (index == pages.length - 1){
                    bloc.pagesVisited(true);
                  }
//                  if (index == 1 && imagePath2 == null) {
//                    await takeScreenShoot(_sc2, 2);
//                  } else if (index == 2 && imagePath3 == null) {
//                    await takeScreenShoot(_sc3, 3);
//                  }
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

