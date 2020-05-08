import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/DoorLockData.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorLock.dart';

class DoorLockGeneralData extends StatefulWidget {
  final DoorLock doorLock;

  DoorLockGeneralData(this.doorLock);

  @override
  State<StatefulWidget> createState() {
    return DoorLockGeneralDataState(this.doorLock);
  }
}

class DoorLockGeneralDataState extends State<DoorLockGeneralData> {
  DoorLock doorLock;

  DoorLockGeneralDataState(this.doorLock);

  FocusNode logoVisibleNode,
      yearNode,
      profileNode,
      protectionNode,
      basicDepthNode,
      openingDirNode,
      leafNode,
      boltNode;

  final logoVisibleCtr = TextEditingController();
  final yearCtr = TextEditingController();
  final profileCtr = TextEditingController();
  final protectionCtr = TextEditingController();
  final basicDepthCtr = TextEditingController();
  final openingDirCtr = TextEditingController();
  final leafCtr = TextEditingController();
  final boltCtr = TextEditingController();

  DatabaseHelper helper = DatabaseHelper.instance;
  bool filled = false;

  @override
  void initState() {
    super.initState();
    logoVisibleNode = FocusNode();
    yearNode = FocusNode();
    profileNode = FocusNode();
    protectionNode = FocusNode();
    basicDepthNode = FocusNode();
    openingDirNode = FocusNode();
    leafNode = FocusNode();
    boltNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    logoVisibleNode.dispose();
    yearNode.dispose();
    profileNode.dispose();
    protectionNode.dispose();
    basicDepthNode.dispose();
    openingDirNode.dispose();
    leafNode.dispose();
    boltNode.dispose();
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

  Widget _getBolt() {
    if (leafCtr.text == FlutterI18n.translate(context, 'Double-leaf door')) {
      return Column(
        children: <Widget>[
          _constructGenericOption(
              FlutterI18n.translate(context, 'Bolt'),
              true,
              [
                FlutterI18n.translate(context, 'Rebate shoot bolt'),
                FlutterI18n.translate(context, 'Surface-mounted shoot bolt'),
                FlutterI18n.translate(context, 'Shoot bolt lock1')
              ],
              boltCtr,
              FlutterI18n.translate(context, 'Rebate shoot bolt')),
          Divider(height: 1),
        ],
      );
    } else
      return Container();
  }

  Widget _checkImage() {
    if (logoVisibleCtr.text != "" &&
        profileCtr.text != "" &&
        protectionCtr.text != "" &&
        openingDirCtr.text != "" &&
        leafCtr.text != "") {
      if (leafCtr.text == FlutterI18n.translate(context, 'Double-leaf door') &&
          boltCtr.text != "") {
        filled = true;
        return Image.asset(
          'assets/checkGreen.png',
          height: 25,
        );
      } else if (leafCtr.text == FlutterI18n.translate(context, 'Single')) {
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
      filled = false;
      return Image.asset(
        'assets/checkGrey.png',
        height: 25,
      );
    }
  }

  _goNextData() {
    if (filled) {
      debugPrint('next');
      doorLock.logoVisible = logoVisibleCtr.text;
      doorLock.year = yearCtr.text;
      doorLock.profile = profileCtr.text;
      doorLock.protection = protectionCtr.text;
      doorLock.basicDepthDoor = basicDepthCtr.text;
      doorLock.openingDirection = openingDirCtr.text;
      doorLock.leafDoor = leafCtr.text;
      doorLock.bolt = boltCtr.text;
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => DoorLockData(doorLock)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'General data'),
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
                yearNode.unfocus();
                _goNextData();
              },
              child: _checkImage()),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _constructGenericOption(
              FlutterI18n.translate(
                  context, 'Schüco logo visible in face plate'),
              true,
              ['Yes', 'No'],
              logoVisibleCtr,
              'Yes'),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(FlutterI18n.translate(context, 'Year of manufacturing'),
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: yearNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.body1,
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
          _constructGenericOption(
              FlutterI18n.translate(context, 'Profile insulation'),
              true,
              [
                FlutterI18n.translate(context, 'Thermally insulated profiles'),
                FlutterI18n.translate(context, 'Non-insulated profiles')
              ],
              profileCtr,
              FlutterI18n.translate(context, 'Thermally insulated profiles')),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Protection'),
              true,
              [
                FlutterI18n.translate(context, 'None'),
                FlutterI18n.translate(context, 'Fire protection'),
                FlutterI18n.translate(context, 'Smoke protection')
              ],
              protectionCtr,
              FlutterI18n.translate(context, 'None')),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(
                  context, 'Basic depth of door profile (mm)'),
              false,
              ['50mm', '60mm', '65mm', '70mm', '75mm', '90mm'],
              basicDepthCtr,
              '50mm'),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Opening direction'),
              true,
              [
                FlutterI18n.translate(context, 'Inward'),
                FlutterI18n.translate(context, 'Outward')
              ],
              openingDirCtr,
              FlutterI18n.translate(context, 'Inward')),
          Divider(height: 1),
          _constructGenericOption(
              FlutterI18n.translate(context, 'Leaf'),
              true,
              [
                FlutterI18n.translate(context, 'Single'),
                FlutterI18n.translate(context, 'Double-leaf door')
              ],
              leafCtr,
              FlutterI18n.translate(context, 'Single')),
          Divider(height: 1),
          _getBolt()
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
