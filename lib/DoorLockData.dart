import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/ArticleWebPreview.dart';
import 'package:repairservices/DoorLockFacePlateFixingImage.dart';
import 'package:repairservices/DoorLockFacePlateTypeImage.dart';
import 'package:repairservices/DoorLockMultipointLocking.dart';
import 'package:repairservices/DoorLockTypeImage.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_lock.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

class DoorLockData extends StatefulWidget {
  final DoorLock doorLock;

  DoorLockData(this.doorLock);

  @override
  State<StatefulWidget> createState() {
    return DoorLockDataState(this.doorLock);
  }
}

class DoorLockDataState extends State<DoorLockData> {
  DoorLock doorLock;

  DoorLockDataState(this.doorLock);

  final dinDirectionCtr = TextEditingController();
  final typeCtr = TextEditingController();
  final panicFuncCtr = TextEditingController();
  final selfLockingCtr = TextEditingController();
  final secureLatchCtr = TextEditingController();
  final monitoringCtr = TextEditingController();
  final electricStrikeCtr = TextEditingController();
  final daytimeCtr = TextEditingController();
  final lockWithTopLockingCtr = TextEditingController();
  final shootBoltLockCtr = TextEditingController();
  final handleHeightCtr = TextEditingController();
  final doorLeafHeightCtr = TextEditingController();
  final restrictorCtr = TextEditingController();

  DatabaseHelper helper = DatabaseHelper.instance;
  bool filled = false;

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
                          style: Theme.of(context).textTheme.body1,
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
                  style: Theme.of(context).textTheme.body1,
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

  Widget _getDaytime() {
    if (electricStrikeCtr.text == 'Yes') {
      return Column(
        children: <Widget>[
          _constructGenericOption(
              FlutterI18n.translate(context, 'Daytime setting'),
              false,
              ['Yes', 'No'],
              daytimeCtr,
              'Yes'),
          Divider(height: 1),
        ],
      );
    } else
      return Container();
  }

  Widget _getLockWithTopLockingOptions() {
    if (lockWithTopLockingCtr.text == 'Yes') {
      return Column(
        children: <Widget>[
          _constructGenericOption(
              FlutterI18n.translate(context, 'Shoot bolt lock'),
              false,
              ['DIN EN 1125 push bar', 'DIN EN 179 handle'],
              shootBoltLockCtr,
              'DIN EN 179 handle'),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Handle height'),
              false,
              ['Standard 1050 mm', '850 mm', '1500'],
              handleHeightCtr,
              'Standard 1050 mm'),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Door leaf height'),
              false,
              ['Under 2500 mm', 'Over 2500 mm'],
              doorLeafHeightCtr,
              'Under 2500 mm'),
          Divider(height: 1),
          _constructGenericOption(FlutterI18n.translate(context, 'Restrictor'),
              false, ['Yes', 'No'], restrictorCtr, 'Yes'),
          Divider(height: 1),
        ],
      );
    } else
      return Container();
  }

  Widget _checkImage() {
    if (dinDirectionCtr.text != "" &&
        typeCtr.text != "" &&
        panicFuncCtr.text != "" &&
        lockWithTopLockingCtr.text != '' &&
        doorLock.lockType != null &&
        doorLock.facePlateType != null &&
        doorLock.facePlateFixing != null) {
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
  }

  _goNextData() {
    if (filled) {
      doorLock.dinDirection = dinDirectionCtr.text;
      doorLock.type = typeCtr.text;
      doorLock.panicFunction = panicFuncCtr.text;
      doorLock.selfLocking = selfLockingCtr.text;
      doorLock.secureLatchBoltStop = secureLatchCtr.text;
      doorLock.monitoring = monitoringCtr.text;
      doorLock.electricStrike = electricStrikeCtr.text;
      doorLock.daytime = daytimeCtr.text;
      doorLock.lockWithTopLocking = lockWithTopLockingCtr.text;
      doorLock.shootBoltLock = shootBoltLockCtr.text;
      doorLock.handleHeight = handleHeightCtr.text;
      doorLock.doorLeafHight = doorLeafHeightCtr.text;
      doorLock.restrictor = restrictorCtr.text;
      _saveArticle();
    }
  }

  _saveArticle() async {
    doorLock.pdfPath = await PDFManagerDoorLock.getPDFPath(doorLock);
    int id = await helper.insertDoorLock(doorLock);
    print('inserted row: $id');
    if (id != null) {
      NavigationUtils.push(context, FittingPDFViewerPage(model: doorLock,));
//      Navigator.push(
//          context,
//          CupertinoPageRoute(
//              builder: (context) => ArticleWebPreview(doorLock)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Lock data'),
            style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                _goNextData();
              },
              child: _checkImage()),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _constructGenericOption(
              FlutterI18n.translate(context, 'DIN direction'),
              true,
              [
                FlutterI18n.translate(context, 'Left'),
                FlutterI18n.translate(context, 'Right')
              ],
              dinDirectionCtr,
              FlutterI18n.translate(context, 'Left')),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Type'),
              true,
              [
                FlutterI18n.translate(context, 'Defective'),
                FlutterI18n.translate(context, 'Change of use')
              ],
              typeCtr,
              FlutterI18n.translate(context, 'Defective')),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Panic function'),
              true,
              ['Yes', 'No'],
              panicFuncCtr,
              'None'),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Self-locking'),
              false,
              ['Yes', 'No'],
              selfLockingCtr,
              'Yes'),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Secure latch bolt stop'),
              false,
              ['Yes', 'No'],
              secureLatchCtr,
              'Yes'),
          Divider(height: 1),
          _constructGenericOption(FlutterI18n.translate(context, 'Monitoring'),
              false, ['Yes', 'No'], monitoringCtr, 'Yes'),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Electric strike'),
              false,
              ['Yes', 'No'],
              electricStrikeCtr,
              'Yes'),
          Divider(height: 1),
          _getDaytime(),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Lock with top locking'),
              true,
              ['Yes', 'No'],
              lockWithTopLockingCtr,
              'No'),
          Divider(height: 1),
          _getLockWithTopLockingOptions(),
          //LockType image
          InkWell(
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 4),
                        child: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(
                                    context, 'Select lock type'),
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.left),
                            _getMandatory(true)
                          ],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 20),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          DoorLockTypeImage(doorLock.lockType))).then((type) {
                if (type != null && type != '') {
                  doorLock.lockType = type;
                }
              });
            },
          ),
          Divider(height: 1),
          InkWell(
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 4),
                        child: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(
                                    context, 'Select face plate type'),
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.left),
                            _getMandatory(true)
                          ],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 20),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => DoorLockFacePlateTypeImage(
                          doorLock.facePlateType))).then((type) {
                if (type != null && type != '') {
                  doorLock.facePlateType = type;
                }
              });
            },
          ),
          Divider(height: 1),
          InkWell(
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 4),
                        child: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(
                                    context, 'Select face plate fixing'),
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.left),
                            _getMandatory(true)
                          ],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 20),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => DoorLockFacePlateFixingImage(
                          doorLock.facePlateFixing))).then((type) {
                if (type != null && type != '') {
                  doorLock.facePlateFixing = type;
                }
              });
            },
          ),
          Divider(height: 1),
          InkWell(
            child: Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 4),
                        child: Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(
                                    context, 'Multi-point locking'),
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.left),
                            _getMandatory(false)
                          ],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 20),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => DoorLockMultipointLocking(
                          doorLock.multipointLocking))).then((type) {
                if (type != null && type != '') {
                  doorLock.multipointLocking = type;
                }
              });
            },
          ),
          Divider(height: 1)
          //Lock type
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

enum TypeFitting { windows, sunShading, other }
