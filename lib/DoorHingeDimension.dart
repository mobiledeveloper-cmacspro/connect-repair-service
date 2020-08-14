import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/DoorHingeGeneralData.dart';
import 'package:repairservices/DoorLockData.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_hinge.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

import 'database_helpers.dart';

class DoorHingeDimension extends StatefulWidget {
  final DoorHinge doorHinge;

  const DoorHingeDimension(this.doorHinge);

  @override
  State<StatefulWidget> createState() {
    return DoorHingeDimensionState(doorHinge);
  }
}

class DoorHingeDimensionState extends State<DoorHingeDimension>{
  DoorHinge doorHinge;
  FocusNode aNode,bNode,cNode;
  final aCtr = TextEditingController();
  final bCtr = TextEditingController();
  final cCtr = TextEditingController();
  final dCtr = TextEditingController();
  final dimensionCtr = TextEditingController();
  var imageKey1 = new GlobalKey();
  String imagePath1;
  File dimensionImage1;
  DatabaseHelper helper = DatabaseHelper.instance;

  DoorHingeDimensionState(this.doorHinge);

  @override
  void initState() {
    super.initState();
    aNode = FocusNode();
    bNode = FocusNode();
    cNode = FocusNode();
  }

  @override
  void dispose() {
    aNode.dispose();
    bNode.dispose();
    cNode.dispose();
    super.dispose();
  }

  void _changeFocus(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  _changeDimension(BuildContext context,String dimension) {
    showAlertDialogDimension(context,dimension);
  }

  void showAlertDialog(BuildContext context, String title, String textButton) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context ) => CupertinoAlertDialog(
          title: new Text(title, style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            CupertinoDialogAction(
              child: new Text(textButton, style: TextStyle(color: Theme.of(context).primaryColor)),
              isDefaultAction: true,
              onPressed: (){
                Navigator.pop(context);
                setState(() {});
              },
            ),
            CupertinoDialogAction(
              child: new Text(R.string.cancel),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }

  void showAlertDialogDimension(BuildContext context, String dimension) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context ) => CupertinoAlertDialog(
          title: new Text(R.string.dimension + ' $dimension'),
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
              )
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                child: new Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (dimensionCtr.text != "" && int.parse(dimensionCtr.text) != 0){
                    switch(dimension){
                      case 'A':
                        setState(() {
                          aCtr.text = int.parse(dimensionCtr.text).toString();
                        });
//                        takeScreenShoot();
                        break;
                      case 'B':
                        setState(() {
                          bCtr.text = int.parse(dimensionCtr.text).toString();
                        });
//                        takeScreenShoot();
                        break;
                      default:
                        setState(() {
                          cCtr.text = int.parse(dimensionCtr.text).toString();
                        });
//                        takeScreenShoot();
                    }
                  }
                  else {
                    Navigator.pop(context);
                    showAlertDialog(context, R.string.zeroNotValueForDimension, "OK");
                  }
                }
            ),
            CupertinoDialogAction(
              child: new Text(R.string.cancel),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }

  Future<void> takeScreenShoot1() async {
//    setState(() {});
    debugPrint('taking screenshot');
    RenderRepaintBoundary boundary = imageKey1.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData.buffer;
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds(withTempPrefix: true);
    final path = '$directory/$fileName.png';

    File(path).writeAsBytesSync(buffer.asUint8List(byteData.offsetInBytes,byteData.lengthInBytes));

    ///Removing previous screen shoot if exist
    if (imagePath1?.isNotEmpty == true &&
        imagePath1?.endsWith('.png') == true) {
      File preFile = File(imagePath1);
      if (await preFile.exists()) {
        await preFile.delete();
      }
    }

    imagePath1 = path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.hingeDimensions,style: Theme.of(context).textTheme.bodyText2),
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
            onTap: () async{
              await takeScreenShoot1();
              doorHinge.name = R.string.doorHingeFitting;
              doorHinge.created = DateTime.now();
              doorHinge.dimensionsSurfaceA = aCtr.text;
              doorHinge.dimensionsSurfaceB = bCtr.text;
              doorHinge.dimensionsSurfaceC = cCtr.text;
              doorHinge.dimensionsSurfaceD = dCtr.text;
              doorHinge.dimensionSurfaceIm = imagePath1;

              //doorHinge = DoorHinge.withData(R.string.doorHingeFitting, DateTime.now(), aCtr.text, bCtr.text, cCtr.text, dCtr.text, imagePath1);

              debugPrint('Saving Door Hinge');
              int type = 0;
              if (doorHinge.hingeType == R.string.barrelHinge) {
                type = 1;
              } else if (doorHinge.hingeType ==
                  R.string.surfaceMountedDoorHinge) {
                type = 2;
              }
              doorHinge.pdfPath =
              await PDFManagerDoorHinge.getPDFPath(doorHinge, type: type);

              int id = await helper.insertDoorHinge(doorHinge);
              print('inserted row: $id');
              if (id != null) {
                NavigationUtils.pushCupertino(
                  context,
                  FittingPDFViewerPage(
                    model: doorHinge,
                  ),
                );

//      Navigator.push(context, CupertinoPageRoute(builder: (context) => ArticleWebPreview(doorHinge)));
              }


              //Navigator.push(context, CupertinoPageRoute(builder: (context) => DoorHingeGeneralData(doorHinge)));
            },
          )
        ],
      ),
      body: Container(
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
                            margin: EdgeInsets.only(top: 16,bottom: 8),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Image.asset('assets/hingeDimension.png'),
                                  ),
                                ),
                                Positioned(
                                  bottom: 127,
                                  left: 102,
                                  child: Container(
                                    width: 30,
                                    height: 25,
                                    child: InkWell(
                                      onTap: () => _changeDimension(context,'A'),
                                      child: FittedBox(
                                        child: Text(aCtr.text != "" ? aCtr.text : "A",style: Theme.of(context).textTheme.bodyText2),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 117,
                                  bottom: 127,
                                  child: Container(
                                    width: 39,
                                    height: 25,
                                    child: InkWell(
                                      onTap: () => _changeDimension(context,'B'),
                                      child: FittedBox(
                                        child: Text(bCtr.text != "" ? bCtr.text : "B",style: Theme.of(context).textTheme.bodyText2),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 137,
                                  bottom: 102,
                                  child: Container(
                                    width: 38,
                                    height: 25,
                                    child: InkWell(
                                        onTap: () => _changeDimension(context,'C'),
                                        child: FittedBox(
                                          child: Text(cCtr.text != "" ? cCtr.text : "C",style: Theme.of(context).textTheme.bodyText2),
                                        )
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 27,
                                  top: 130,
                                  child: Container(
//                                    color: Colors.redAccent,
                                    width: 21,
                                    height: 44,
                                    child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, CupertinoPageRoute(builder: (context) => GenericSelection(R.string.dimension + ' D', ['22','36']))).then((selectedOption){
                                            setState(() {
                                              dCtr.text = selectedOption;
//                                              takeScreenShoot();
                                            });
                                          });
                                        },
                                        child: FittedBox(
                                          child: Text(dCtr.text != "" ? dCtr.text : "D",style: Theme.of(context).textTheme.bodyText2),
                                        )
                                    ),
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
                      padding: EdgeInsets.only(left: 16,top: 8),
                      child: Text('A',style: aCtr.text == "" ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.left),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16,right: 16),
                      child: new TextField(
                        focusNode: aNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: aCtr,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (next){
                          _changeFocus(context, aNode, bNode);
                          setState(() {

                          });
//                          takeScreenShoot();
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('B',style: bCtr.text == "" ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.left),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,top: 0),
                      child: new TextField(
                        focusNode: bNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: bCtr,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (next){
                          _changeFocus(context, bNode, cNode);
//                          takeScreenShoot();
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('C',style: cCtr.text == "" ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.left),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,top: 0),
                      child: new TextField(
                        focusNode: cNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        controller: cCtr,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_){
//                          setState(() {});
//                          takeScreenShoot();
                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    InkWell(
                      child: Row(

                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text('D',style: dCtr.text == "" ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.left),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16,top: 0),
                                  child: new TextField(
                                    focusNode: AlwaysDisabledFocusNode(),
                                    textAlign: TextAlign.left,
                                    expands: false,
                                    style: Theme.of(context).textTheme.bodyText2,
                                    maxLines: 1,
                                    controller: dCtr,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration.collapsed(
                                        border: InputBorder.none,
                                        hintText: 'mm',
                                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
                          )
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => GenericSelection(R.string.dimension + ' D', ['22','36']))).then((selectedOption){
                          setState(() {
                            dCtr.text = selectedOption;
//                            takeScreenShoot();
                          });
                        });
                      },
                    ),
                    Divider(height: 1),
                  ],
                ),
              )
            ],

          )
      ),
    );
  }
}