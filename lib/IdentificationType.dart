import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/EditPicture.dart';
import 'package:repairservices/FittingSelection.dart';
import 'package:repairservices/Utils/DeviceInfo.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/article_resources/audio/audio_page.dart';
import 'package:repairservices/ui/article_resources/video/video_page.dart';
import 'package:repairservices/ui/marker_component/drawer_container_page.dart';

class IdentificationTypeV extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IdentificationTypeState();
  }
}

class IdentificationTypeState extends State<IdentificationTypeV> {
  String imagePath;
  bool isPhysicalDevice = true;

  @override
  initState() {
    super.initState();
    _isPhysicalDevice();
  }

  Future _getImageFromSource(ImageSource source) async {
    final File image = await ImagePicker.pickImage(source: source);
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    final File newImage = await image.copy('$directory/$fileName.png');
    imagePath = newImage.path;
    _showAlertDialog(context);
  }

  _isPhysicalDevice() async {
    final deviceData = DeviceInfo();
    await deviceData.initPlatformState();
    final isPhysicalDevice = deviceData.getData()['isPhysicalDevice'];
    debugPrint('physical ${deviceData.getData()}');
    setState(() {
      this.isPhysicalDevice = isPhysicalDevice;
    });
  }

  Widget _fromGallery() {
    if (isPhysicalDevice) {
      return Container();
    } else {
      return InkWell(
        child: Icon(Icons.image),
        onTap: () => _getImageFromSource(ImageSource.gallery),
      );
    }
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(FlutterI18n.translate(context, "Send by Email"),
                  style: Theme.of(context).textTheme.subhead),
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  FlutterI18n.translate(context, "Send this article"),
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: new Text(
                      FlutterI18n.translate(context, "Just save it"),
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => DrawerContainerPage(
                                  imagePath: imagePath,
                                  isForMail: false,
                                )));
                  },
                ),
                CupertinoDialogAction(
                  child: new Text(
                      FlutterI18n.translate(
                          context, "Save it and send by email"),
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                DrawerContainerPage(imagePath: imagePath)));
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, "Identification Type"),
            style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: new Container(
          child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8),
//                      color: Theme.of(context).primaryColor,
                child: InkWell(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/cameraGreen.png',
                      ),
                      new Container(
                        child: new Text(
                            FlutterI18n.translate(context, "Camera"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.body1),
                        margin: EdgeInsets.only(top: 26),
                      )
                    ],
                  ),
                  onTap: () {
                    _getImageFromSource(ImageSource.camera);
                  },
                ),
              )),
              Container(
                color: Colors.grey,
                width: 1,
                height: MediaQuery.of(context).size.width / 2 - 40,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 8),
//                      color: Theme.of(context).primaryColor,
                child: InkWell(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/notesGreen.png',
                      ),
                      new Container(
                        child: new Text(
                            FlutterI18n.translate(context, "Record Product"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.body1),
                        margin: EdgeInsets.only(top: 26),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => FittingSelection()),
                    );
                  },
                ),
              )),
            ],
          ),
          Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width,
            height: 1,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8),
//                      color: Theme.of(context).primaryColor,
                child: InkWell(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*Image.asset(
                            '',
                          ),*/
                      new Container(
                        child: new Text(FlutterI18n.translate(context, "Video"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.body1),
                        margin: EdgeInsets.only(top: 26),
                      )
                    ],
                  ),
                  onTap: () async {
//                    await NavigationUtils.pushCupertino(
//                        context,  VideoPage(filePath: ""));
                  },
                ),
              )),
              Container(
                color: Colors.grey,
                width: 1,
                height: MediaQuery.of(context).size.width / 2 - 40,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 8),
//                      color: Theme.of(context).primaryColor,
                child: InkWell(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /* Image.asset(
                            '',
                          ),*/
                      new Container(
                        child: new Text(FlutterI18n.translate(context, "Audio"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.body1),
                        margin: EdgeInsets.only(top: 26),
                      )
                    ],
                  ),
                  onTap: () async{
//                    await NavigationUtils.pushCupertino(
//                        context,  AudioPage(filePath: ""));
                  },
                ),
              )),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 1,
            width: MediaQuery.of(context).size.width,
          ),
          _fromGallery()
        ],
      )),
    );
  }
}
