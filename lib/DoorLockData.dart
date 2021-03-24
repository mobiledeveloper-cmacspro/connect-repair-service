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
import 'package:repairservices/LockDimensions.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_lock.dart';
import 'package:repairservices/ui/pdf_viewer/pdf_viewer_page.dart';
import 'package:repairservices/res/R.dart';

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

  Widget _getDaytime() {
    if (electricStrikeCtr.text == R.string.yes) {
      return Column(
        children: <Widget>[
          _constructGenericOption(
              R.string.daytimeSetting,
              false,
              [R.string.yes, R.string.no],
              daytimeCtr,
              R.string.yes),
          Divider(height: 1),
        ],
      );
    } else
      return Container();
  }

  Widget _getLockWithTopLockingOptions() {
    if (lockWithTopLockingCtr.text == R.string.yes) {
      return Column(
        children: <Widget>[
          _constructGenericOption(
              R.string.shootBoltLock,
              false,
              [R.string.dinEn1125PushBar, R.string.dinEn179Handle],
              shootBoltLockCtr,
              R.string.dinEn179Handle),
          Divider(height: 1),
          _constructGenericOption(
              R.string.handleHeight,
              false,
              [R.string.standard1050mm, '850 mm', '1500'],
              handleHeightCtr,
              R.string.standard1050mm),
          Divider(height: 1),
          _constructGenericOption(
              R.string.doorLeafHeight,
              false,
              [R.string.under2500mm, R.string.over2500mm],
              doorLeafHeightCtr,
              R.string.under2500mm),
          Divider(height: 1),
          _constructGenericOption(R.string.restrictor,
              false, [R.string.yes, R.string.no], restrictorCtr, R.string.yes),
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
      debugPrint('next');
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => LockDimensions(doorLock)));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.lockData,
            style: Theme.of(context).textTheme.bodyText2),
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
              R.string.dinDirection,
              true,
              [
                R.string.left,
                R.string.right
              ],
              dinDirectionCtr,
              R.string.left
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.type,
              true,
              [
                R.string.defective,
                R.string.changeOfUse
              ],
              typeCtr,
              R.string.defective
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.panicFunction,
              true,
              [R.string.yes, R.string.no],
              panicFuncCtr,
              R.string.none
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.selfLocking,
              false,
              [R.string.yes, R.string.no],
              selfLockingCtr,
              R.string.yes
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.secureLatchBoltStop,
              false,
              [R.string.yes, R.string.no],
              secureLatchCtr,
              R.string.yes
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.monitoring,
              false, [R.string.yes, R.string.no], monitoringCtr, R.string.yes
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.electricStrike,
              false,
              [R.string.yes, R.string.no],
              electricStrikeCtr,
              R.string.yes
          ),
          Divider(height: 1),
          _getDaytime(),
          _constructGenericOption(
              R.string.lockTopLocking,
              true,
              [R.string.yes, R.string.no],
              lockWithTopLockingCtr,
              R.string.yes
          ),
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
                                R.string.selectLockType,
                                style: Theme.of(context).textTheme.bodyText2,
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
                  setState(() {
                    doorLock.lockType = type;
                  });
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
                                R.string.selectFacePlateType,
                                style: Theme.of(context).textTheme.bodyText2,
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
                  setState(() {
                    doorLock.facePlateType = type;
                  });
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
                                R.string.selectFacePlateFixing,
                                style: Theme.of(context).textTheme.bodyText2,
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
                  setState(() {
                    doorLock.facePlateFixing = type;
                  });
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
                                R.string.multiPointLocking,
                                style: Theme.of(context).textTheme.bodyText2,
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
