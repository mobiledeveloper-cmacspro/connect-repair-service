import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/DoorLockData.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/res/R.dart';

class DoorLockGeneralData extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DoorLockGeneralDataState();
  }
}

class DoorLockGeneralDataState extends State<DoorLockGeneralData> {
  DoorLock doorLock;

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
    doorLock = DoorLock();
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

  Widget _getBolt() {
    if (leafCtr.text == R.string.doubleLeafDoor) {
      return Column(
        children: <Widget>[
          _constructGenericOption(
              R.string.bolt,
              true,
              [
                R.string.rebateShootBolt,
                R.string.surfaceMountedShootBolt,
                R.string.shootBoltLock1
              ],
              boltCtr,
              R.string.rebateShootBolt
          ),
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
      if (leafCtr.text == R.string.doubleLeafDoor && boltCtr.text != "") {
        filled = true;
        return Image.asset(
          'assets/checkGreen.png',
          height: 25,
        );
      } else if (leafCtr.text == R.string.single) {
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
        title: Text(R.string.generalData,
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
                yearNode.unfocus();
                _goNextData();
              },
              child: _checkImage()),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _constructGenericOption(
              R.string.schucoLogoVisibleOnFacePlate,
              true,
              ['Yes', 'No'],
              logoVisibleCtr,
              'Yes'),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(R.string.yearOfManufacturing,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.left),
          ),
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
          _constructGenericOption(
              R.string.profileInsulation,
              true,
              [
                R.string.thermallyInsulatedProfiles,
                R.string.nonInsulatedProfiles
              ],
              profileCtr,
              R.string.thermallyInsulatedProfiles
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.protection,
              true,
              [
                R.string.none,
                R.string.fireProtection,
                R.string.smokeProtection
              ],
              protectionCtr,
            R.string.none,
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.basicDepthDoorProfileMM,
              false,
              ['50mm', '60mm', '65mm', '70mm', '75mm', '90mm'],
              basicDepthCtr,
              '50mm'),
          Divider(height: 1),
          _constructGenericOption(
              R.string.openingDirection,
              true,
              [
                R.string.inward,
                R.string.outward
              ],
              openingDirCtr,
              R.string.inward
          ),
          Divider(height: 1),
          _constructGenericOption(
              R.string.leaf,
              true,
              [
                R.string.single,
                R.string.doubleLeafDoor
              ],
              leafCtr,
              R.string.single
          ),
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
