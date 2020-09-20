import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/ArticleWebPreview.dart';
import 'package:repairservices/DoorHingeDimension.dart';
import 'package:repairservices/DoorHingeDimensionBarrel.dart';
import 'package:repairservices/DoorHingeSurfaceDetails.dart';
import 'package:repairservices/DoorLockData.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_hinge.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';
import 'package:repairservices/res/R.dart';
import 'dart:io';

class DoorHingeGeneralData extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DoorHingeGeneralDataState();
  }
}

class DoorHingeGeneralDataState extends State<DoorHingeGeneralData> {
  DoorHinge doorHinge;

  final yearCtr = TextEditingController();
  final basicDepthDoorCtr = TextEditingController();
  final hingeSystemCtr = TextEditingController();
  final materialCtr = TextEditingController();
  final thermallyCtr = TextEditingController();
  final doorOpeningCtr = TextEditingController();
  final fittedCtr = TextEditingController();
  final hingeTypeCtr = TextEditingController();
  final coverCapsCtr = TextEditingController();
  final doorLeafCtr = TextEditingController();
  final systemDoorLeafCtr = TextEditingController();
  final doorFrameCtr = TextEditingController();
  final systemDoorFrameCtr = TextEditingController();

  FocusNode yearNode,
      basicDepthDoorNode,
      hingeSystemNode,
      materialNode,
      doorOpeningNode,
      fittedNode,
      hingeTypeNode,
      coverCapsNode,
      doorLeafNode,
      systemLeadNode,
      doorFrameNode,
      systemFrameNode;
  DatabaseHelper helper = DatabaseHelper.instance;
  bool filled = false;
  String surfaceMountedDetailsImPath = '';
  String barrelDimensionImPath = '';

  @override
  void initState() {
    super.initState();
    yearNode = FocusNode();
    basicDepthDoorNode = FocusNode();
    hingeSystemNode = FocusNode();
    materialNode = FocusNode();
    doorOpeningNode = FocusNode();
    fittedNode = FocusNode();
    hingeTypeNode = FocusNode();
    coverCapsNode = FocusNode();
    doorLeafNode = FocusNode();
    systemLeadNode = FocusNode();
    doorFrameNode = FocusNode();
    systemFrameNode = FocusNode();
    doorHinge = DoorHinge();
  }

  @override
  void dispose() {
    yearNode.dispose();
    basicDepthDoorNode.dispose();
    hingeSystemNode.dispose();
    materialNode.dispose();
    doorOpeningNode.dispose();
    fittedNode.dispose();
    hingeTypeNode.dispose();
    coverCapsNode.dispose();
    doorLeafNode.dispose();
    systemLeadNode.dispose();
    doorFrameNode.dispose();
    systemFrameNode.dispose();
    super.dispose();
  }

  _yearChange() {
    if (yearCtr.text.length == 1) {
      final s = yearCtr.text;
      if (s == "0" ||
          s == "3" ||
          s == "4" ||
          s == "5" ||
          s == "6" ||
          s == "7" ||
          s == "8" ||
          s == "9") {
        setState(() {
          yearCtr.text = '';
        });
      }
    } else if (yearCtr.text.length > 4) {
      setState(() {
        yearCtr.text = yearCtr.text.substring(0, yearCtr.text.length - 1);
      });
    } else {
      setState(() {});
    }
  }

  Widget _checkImage() {
    debugPrint('checking image');
    if (yearCtr.text != "" &&
        basicDepthDoorCtr.text != "" &&
        //hingeSystemCtr.text != "" &&
        materialCtr.text != "" &&
        thermallyCtr.text != "" &&
        doorOpeningCtr.text != "" &&
        //fittedCtr.text != "" &&
        hingeTypeCtr.text != "") {
      if (hingeTypeCtr.text ==
          R.string.surfaceMountedDoorHinge) {
        if (coverCapsCtr.text != '' &&
            this.doorHinge.doorHingeDetailsIm != null &&
            this.doorHinge.doorHingeDetailsIm != '') {
          filled = true;
          return Image.asset(
            'assets/checkGreen.png',
            height: 25,
          );
        } else {
          filled = false;
          return Image.asset(
            'assets/checkGrey.png',
            height: 25,
          );
        }
      } else if (hingeTypeCtr.text ==
          R.string.barrelHinge) {
        if (//doorLeafCtr.text != '' &&
            doorFrameCtr.text != '' &&
            doorHinge.dimensionBarrelIm != null &&
            doorHinge.dimensionBarrelIm != '') {
          filled = true;
          return Image.asset(
            'assets/checkGreen.png',
            height: 25,
          );
        } else {
          filled = false;
          return Image.asset(
            'assets/checkGrey.png',
            height: 25,
          );
        }
      } else {
        filled = true;
        return Image.asset(
          'assets/checkGreen.png',
          height: 25,
        );
      }
    } else {
      filled = false;
      return Image.asset(
        'assets/checkGrey.png',
        height: 25,
      );
    }
  }

  Widget _getMandatory(bool mandatory) {
    if (mandatory) {
      return Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text('*', style: TextStyle(color: Colors.red, fontSize: 17)));
    } else
      return Container();
  }

  Widget _constructGenericOption(String title, bool mandatory,
      List<String> options, TextEditingController controller, String hintText) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, right: 4),
                  child: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(title,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.left),
                      _getMandatory(mandatory)
                    ],
                  )),
              new Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
                child: new TextField(
                  focusNode: AlwaysDisabledFocusNode(),
                  enableInteractiveSelection: false,
                  enabled: false,
                  textAlign: TextAlign.left,
                  expands: false,
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 1,
                  controller: controller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
              ),
            ],
          )),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          )
        ],
      ),
      onTap: () {
        Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => GenericSelection(title, options)))
            .then((selectedOption) {
          setState(() {
            controller.text = selectedOption;
          });
        });
      },
    );
  }

  _goNextData() async {

    doorHinge.year = yearCtr.text;
    doorHinge.basicDepthOfDoorLeaf = basicDepthDoorCtr.text;
    doorHinge.systemHinge = hingeSystemCtr.text;
    doorHinge.material = materialCtr.text;
    doorHinge.thermally = thermallyCtr.text;
    doorHinge.doorOpening = doorOpeningCtr.text;
    doorHinge.fitted = fittedCtr.text;
    doorHinge.hingeType = hingeTypeCtr.text;
    doorHinge.coverCaps = coverCapsCtr.text;
    doorHinge.doorLeafBarrel = doorLeafCtr.text;
    doorHinge.systemDoorLeaf = systemDoorLeafCtr.text;
    doorHinge.doorFrame = doorFrameCtr.text;
    doorHinge.systemDoorFrame = systemDoorFrameCtr.text;


    int type = 0;
    if (doorHinge.hingeType == R.string.barrelHinge) {
      type = 1;
    } else if (doorHinge.hingeType ==
        R.string.surfaceMountedDoorHinge) {
      type = 2;
    }
    doorHinge.intType = type;

    if(type == 2) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => DoorHingeDimension(doorHinge)));
    }else{
      doorHinge.name = R.string.doorHingeFitting;
      doorHinge.created = DateTime.now();

      debugPrint('Saving Door Hinge');

      doorHinge.pdfPath =
          await PDFManagerDoorHinge.getPDFPath(doorHinge, type: doorHinge.intType);

      int id = await helper.insertDoorHinge(doorHinge);
      if(id != null) {
        print('inserted row: $id');
        NavigationUtils.pushCupertino(
          context,
          FittingPDFViewerPage(
            model: doorHinge,
          ),
        );
      }
    }

  }

  Widget _getSurface() {
    return Column(
      children: <Widget>[
        InkWell(
          child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  Text(
                      R.string.surfaceMountedDoorHingeDetails,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left),
                  Expanded(
                    child: _getMandatory(true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 20),
                  )
                ],
              )),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => DoorHingeSurfaceDetails(
                        this.doorHinge.doorHingeDetailsIm != null
                            ? this.doorHinge.doorHingeDetailsIm
                            : ''))).then((imageStr) {
              setState(() {
                this.doorHinge.doorHingeDetailsIm = imageStr;
                debugPrint('Surface details: ${doorHinge.doorHingeDetailsIm}');
              });
            });
          },
        ),
        Divider(height: 1),
        _constructGenericOption(
            R.string.coverCapsDoorHinge,
            true,
            [
              R.string.circularGeneration,
              R.string.ovalGeneration
            ],
            coverCapsCtr,
            R.string.circularGeneration,
        ),
        Divider(height: 1),
      ],
    );
  }

  Widget _getBarrel() {
    if (hingeTypeCtr.text == R.string.barrelHinge) {
      return Column(
        children: <Widget>[
//          Padding(
//              padding: EdgeInsets.only(left: 16, top: 8),
//              child: Row(
//                children: <Widget>[
//                  Text(R.string.doorLeafMM,
//                      style: Theme.of(context).textTheme.bodyText2,
//                      textAlign: TextAlign.left),
//                  _getMandatory(true)
//                ],
//              )),
//          Padding(
//            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
//            child: new TextField(
//              onChanged: (value) {
//                setState(() {});
//              },
//              focusNode: doorLeafNode,
//              textAlign: TextAlign.left,
//              expands: false,
//              style: Theme.of(context).textTheme.bodyText2,
//              maxLines: 1,
//              controller: doorLeafCtr,
//              keyboardType: TextInputType.number,
//              decoration: InputDecoration.collapsed(
//                  border: InputBorder.none,
//                  hintText: 'mm',
//                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
//            ),
//          ),
//          Divider(height: 1),
//          _constructGenericOption(
//              'System',
//              false,
//              [
//                'Schüco AWS 50',
//                'Schüco AWS 50.NI',
//                'Schüco AWS 50 SL',
//                'Schüco AWS 50 RL',
//                'Schüco AWS 60',
//                'Schüco AWS 60 SL',
//                'Schüco AWS 60 RL',
//                'Schüco AWS 60.HI',
//                'Schüco AWS 60 SL.HI',
//                'Schüco AWS 60 BS',
//                'Schüco AWS 65',
//                'Schüco AWS 65 SL',
//                'Schüco AWS 65 RL',
//                'Schüco AWS 65 BS',
//                'Schüco AWS 65 WF',
//                'Schüco AWS 70.HI',
//                'Schüco AWS 70 SL.HI',
//                'Schüco AWS 70 RL.HI',
//                'Schüco AWS 70 ST.HI',
//                'Schüco AWS 70 BS.HI',
//                'Schüco AWS 70 WF.HI',
//                'Schüco AWS 75.SI+',
//                'Schüco AWS 75 SL.SI+',
//                'Schüco AWS 75 RL.SI+',
//                'Schüco AWS 75 BS.HI+',
//                'Schüco AWS 75 BS.SI+',
//                'Schüco AWS 75 WF.SI+',
//                'Schüco AWS 90.SI+',
//                'Schüco AWS 90.SI+ Green',
//                'Schüco AWS 90 BS.SI+'
//              ],
//              systemDoorLeafCtr,
//              'Schüco AWS 50.NI'),
//          Divider(height: 1),
          Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: <Widget>[
                  Text(R.string.basicDepthDoorFrameMM,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left),
                  _getMandatory(true)
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              onChanged: (value) {
                setState(() {});
              },
              focusNode: doorFrameNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: doorFrameCtr,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'mm',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
//          Divider(height: 1),
//          _constructGenericOption(
//              'System',
//              false,
//              [
//                'Schüco AWS 50',
//                'Schüco AWS 50.NI',
//                'Schüco AWS 50 SL',
//                'Schüco AWS 50 RL',
//                'Schüco AWS 60',
//                'Schüco AWS 60 SL',
//                'Schüco AWS 60 RL',
//                'Schüco AWS 60.HI',
//                'Schüco AWS 60 SL.HI',
//                'Schüco AWS 60 BS',
//                'Schüco AWS 65',
//                'Schüco AWS 65 SL',
//                'Schüco AWS 65 RL',
//                'Schüco AWS 65 BS',
//                'Schüco AWS 65 WF',
//                'Schüco AWS 70.HI',
//                'Schüco AWS 70 SL.HI',
//                'Schüco AWS 70 RL.HI',
//                'Schüco AWS 70 ST.HI',
//                'Schüco AWS 70 BS.HI',
//                'Schüco AWS 70 WF.HI',
//                'Schüco AWS 75.SI+',
//                'Schüco AWS 75 SL.SI+',
//                'Schüco AWS 75 RL.SI+',
//                'Schüco AWS 75 BS.HI+',
//                'Schüco AWS 75 BS.SI+',
//                'Schüco AWS 75 WF.SI+',
//                'Schüco AWS 90.SI+',
//                'Schüco AWS 90.SI+ Green',
//                'Schüco AWS 90 BS.SI+'
//              ],
//              systemDoorFrameCtr,
//              'Schüco AWS 50.NI'),
          Divider(height: 1),
          InkWell(
            child: Container(
                height: 50,
                margin: EdgeInsets.only(left: 16),
                child: Row(
                  children: <Widget>[
                    Text(R.string.dimension,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left),
                    Expanded(
                      child: _getMandatory(true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 20),
                    )
                  ],
                )),
            onTap: () {
              Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              DoorHingeDimensionBarrel(this.doorHinge)))
                  .then((doorHinge) {
                this.doorHinge = doorHinge;
                setState(() {});
              });
            },
          ),
          Divider(height: 1),
        ],
      );
    } else
      return Container();
  }

  void _navBack() {
    if(doorHinge.dimensionBarrelIm != null && doorHinge.dimensionBarrelIm.isNotEmpty && doorHinge.dimensionBarrelIm.endsWith('png')){
      File f = File(doorHinge.dimensionBarrelIm);
      if(f.existsSync()) f.deleteSync();
    }
    NavigationUtils.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.generalData,
            style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            _navBack();
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                yearNode.unfocus();
                basicDepthDoorNode.unfocus();
                hingeSystemNode.unfocus();
                doorLeafNode.unfocus();
                doorFrameNode.unfocus();
                if (filled) {
                  _goNextData();
                }
              },
              child: _checkImage()),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: <Widget>[
                  Text(R.string.yearConstruction,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left),
                  _getMandatory(true)
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: yearNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: yearCtr,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'YYYY',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              onChanged: (value) => _yearChange(),
            ),
          ),
          Divider(height: 1),
          Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: <Widget>[
                  Text(
                      R.string.basicDepthDoorLeafMM,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left),
                  _getMandatory(true)
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              onChanged: (value) {
                setState(() {});
              },
              focusNode: basicDepthDoorNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: basicDepthDoorCtr,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'mm',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
          Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: <Widget>[
                  Text('Schüco system',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left),
                  _getMandatory(false)
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              onChanged: (value) {
                setState(() {});
              },
              focusNode: hingeSystemNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: hingeSystemCtr,
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'system',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.material,
              true,
              [
                R.string.aluminium,
                R.string.pvcU,
                R.string.steel
              ],
              materialCtr,
              R.string.aluminium
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.thermally,
              true,
              [
                R.string.thermallyBrokenDoor,
                R.string.thermallyNonBrokenDoor,
                R.string.fireProtectionDoor,
                R.string.smokeProtectionDoor
              ],
              thermallyCtr,
                R.string.thermallyBrokenDoor
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.doorOpening,
              true,
              [
                R.string.inward,
                R.string.outward
              ],
              doorOpeningCtr,
              R.string.inward),
          Divider(height: 1),
          _constructGenericOption(
              R.string.fitted,
              false,
              [
              R.string.flushFitted,
                R.string.faceFitted
              ],
              fittedCtr,
              R.string.flushFitted),
          Divider(height: 1),
          _constructGenericOption(
              R.string.hingeType,
              true,
              [
                R.string.surfaceMountedDoorHinge,
                R.string.barrelHinge,
                R.string.weldOnHinge,
                R.string.concealedHinge100,
                R.string.concealedHinge180,
                R.string.part2,
                R.string.part3
              ],
              hingeTypeCtr,
              R.string.surfaceMountedDoorHinge),
          Divider(height: 1),
          if(hingeTypeCtr.text == R.string.surfaceMountedDoorHinge)
            _getSurface(),
          if (hingeTypeCtr.text ==
              R.string.barrelHinge)
            _getBarrel()
        ],
      ),
    );
  }
}
