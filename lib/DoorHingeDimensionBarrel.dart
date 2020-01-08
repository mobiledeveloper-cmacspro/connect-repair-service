import 'dart:io';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/models/DoorHinge.dart';

class DoorHingeDimensionBarrel extends StatefulWidget {
  final DoorHinge doorHinge;
  DoorHingeDimensionBarrel(this.doorHinge);
  @override
  State<StatefulWidget> createState() {
    return DoorHingeDimensionBarrelState(this.doorHinge);
  }
}

class DoorHingeDimensionBarrelState extends State<DoorHingeDimensionBarrel> {
  DoorHinge doorHinge;
  DoorHingeDimensionBarrelState(this.doorHinge);
  FocusNode aNode,bNode;
  final aCtr = TextEditingController();
  final bCtr = TextEditingController();
  final dimensionCtr = TextEditingController();
  var imageKey1 = new GlobalKey();
  String imagePath1;
  File dimensionImage1;

  @override
  void initState() {
    super.initState();
    aNode = FocusNode();
    bNode = FocusNode();
    if (doorHinge != null){
      if (doorHinge.dimensionsBarrelA != null){
        aCtr.text = doorHinge.dimensionsBarrelA;
      }
      if (doorHinge.dimensionsBarrelB != null){
        bCtr.text = doorHinge.dimensionsBarrelB;
      }
    }
    else {
      debugPrint('doorHinge null');
    }
  }

  @override
  void dispose() {
    aNode.dispose();
    bNode.dispose();
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
          title: new Text(title, style: Theme.of(context).textTheme.body1),
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
              child: new Text(FlutterI18n.translate(context, 'Cancel')),
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
          title: new Text(FlutterI18n.translate(context, 'Dimension') + ' $dimension'),
          content: new Container(
              margin: EdgeInsets.only(top: 16),
              child: new CupertinoTextField(
                textAlign: TextAlign.left,
                expands: false,
                style: Theme.of(context).textTheme.body1,
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
                        aCtr.text = int.parse(dimensionCtr.text).toString();
                        takeScreenShoot();
                        break;
                      default:
                        bCtr.text = int.parse(dimensionCtr.text).toString();
                        takeScreenShoot();
                    }
                  }
                  else {
                    Navigator.pop(context);
                    showAlertDialog(context, FlutterI18n.translate(context, '0 is not valid value for this dimension'), "OK");
                  }
                }
            ),
            CupertinoDialogAction(
              child: new Text(FlutterI18n.translate(context, 'Cancel')),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }
  _getDimensionImage(){
    if (doorHinge.dimensionBarrelIm != null && doorHinge.dimensionBarrelIm != '') {
      Image.file(File(doorHinge.dimensionBarrelIm));
    }
    else {
      return Image.asset('assets/hingeDimensionBarril.png');
    }
  }
  takeScreenShoot() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1),()async{
      debugPrint('Taking screenshot');
      RenderRepaintBoundary boundary = imageKey1.currentContext.findRenderObject();
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: prefix0.ImageByteFormat.png);
      final buffer = byteData.buffer;
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${DateTime.now().toUtc().toIso8601String()}.png';

      File(path).writeAsBytesSync(buffer.asUint8List(byteData.offsetInBytes,byteData.lengthInBytes));
      imagePath1 = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Hinge dimensions'),style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context,this.doorHinge);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          InkWell(
            child: Image.asset(
              'assets/checkGreen.png',
              height: 25,
            ),
            onTap: (){
              doorHinge.dimensionsBarrelA = aCtr.text;
              doorHinge.dimensionsBarrelB = bCtr.text;
              aNode.unfocus();
              bNode.unfocus();
              takeScreenShoot();
              if (imagePath1 != '') {
                doorHinge.dimensionBarrelIm = imagePath1;
              }
              Navigator.pop(context,doorHinge);
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
                                    child: _getDimensionImage(),
                                  ),
                                ),
                                Positioned(
                                  top: 141,
                                  left: 60,
                                  child: Container(
//                                    color: Colors.redAccent,
                                    width: 14,
                                    height: 33,
                                    child: InkWell(
                                      onTap: () => _changeDimension(context,'A'),
                                      child: FittedBox(
                                        child: Text(aCtr.text != "" ? aCtr.text : "A",style: Theme.of(context).textTheme.body1),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 140,
                                  bottom: 11,
                                  child: Container(
//                                    color: Colors.red,
                                    width: 34,
                                    height: 17,
                                    child: InkWell(
                                      onTap: () => _changeDimension(context,'B'),
                                      child: FittedBox(
                                        child: Text(bCtr.text != "" ? bCtr.text : "B",style: Theme.of(context).textTheme.body1),
                                      ),
                                    ),
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
                      padding: EdgeInsets.only(left: 16,top: 8),
                      child: Text('A',style: aCtr.text == "" ? Theme.of(context).textTheme.body1 : Theme.of(context).textTheme.subtitle, textAlign: TextAlign.left),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16,right: 16),
                      child: new TextField(
                        focusNode: aNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 1,
                        controller: aCtr,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSubmitted: (next){
                          _changeFocus(context, aNode, bNode);
                          takeScreenShoot();
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
                      child: Text('B',style: bCtr.text == "" ? Theme.of(context).textTheme.body1 : Theme.of(context).textTheme.subtitle, textAlign: TextAlign.left),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,top: 0),
                      child: new TextField(
                        focusNode: bNode,
                        textAlign: TextAlign.left,
                        expands: false,
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 1,
                        controller: bCtr,
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_){

                        },
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: 'mm',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 14)
                        ),
                      ),
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