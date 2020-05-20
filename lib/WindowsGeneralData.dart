import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairservices/ArticleWebPreview.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

class WindowsGeneralData extends StatefulWidget {
  final TypeFitting typeFitting;

  WindowsGeneralData(this.typeFitting);

  @override
  State<StatefulWidget> createState() {
    return WindowsGeneralDataState(this.typeFitting);
  }
}

enum SystemDepth { e50mm, e60mm, e65mm, e70mm, e75mm, e90mm }

class WindowsGeneralDataState extends State<WindowsGeneralData> {
  WindowsGeneralDataState(this.typeFitting);

  FocusNode numberNode, yearNode, profileSystemNode, descriptionNode;
  final numberCtr = TextEditingController();
  final yearCtr = TextEditingController();
  final systemCtr = TextEditingController();
  final profileCtr = TextEditingController();
  final descriptionCtr = TextEditingController();
  final TypeFitting typeFitting;
  DatabaseHelper helper = DatabaseHelper.instance;
  File image;
  bool isImage = false;
  String filePath;
  bool isSunShading;

  @override
  void initState() {
    super.initState();
    numberNode = FocusNode();
    yearNode = FocusNode();
    profileSystemNode = FocusNode();
    descriptionNode = FocusNode();
    systemCtr.text = '50mm';
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    numberCtr.dispose();
    yearNode.dispose();
    profileCtr.dispose();
    descriptionCtr.dispose();
    super.dispose();
  }

  void _changeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
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

  void _getDocuments() async {
    debugPrint('DocumentPicker');
    try {
      filePath = await FilePicker.getFilePath(
          type: FileType.custom, allowedExtensions: ['PDF']);
      File pdf = File(filePath);
      final path = await FileUtils.getRootFilesDir();
      final fileName = CalendarUtils.getTimeIdBasedSeconds();
      final File newFile = await pdf.copy('$path/$fileName.pdf');
      await newFile.create();
      setState(() {
        this.image = newFile;
        isImage = false;
        filePath = newFile.path;
        debugPrint('Archive file path: $filePath');
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {});
  }

  Widget _getImageOfFile() {
    if (image != null) {
      if (isImage) {
        return Container(
//          color: Colors.red,
          margin: EdgeInsets.only(left: 16),
//          width: 100,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
//                  Expanded(child: Container()),
                  Container(
                      margin: EdgeInsets.only(left: 55, bottom: 4),
                      child: InkWell(
                        child: Icon(CupertinoIcons.clear_circled,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          setState(() {
                            image = null;
                          });
                        },
                      ))
                ],
              ),
              Image.file(image, fit: BoxFit.fitHeight, width: 58, height: 58)
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(left: 16),
          width: 100,
          height: 100,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Container()),
                  Container(
                      margin: EdgeInsets.only(right: 0, bottom: 4),
                      child: InkWell(
                        child: Icon(CupertinoIcons.clear_circled,
                            color: Theme.of(context).primaryColor),
                        onTap: () {
                          setState(() {
                            image = null;
                          });
                        },
                      ))
                ],
              ),
              Image.asset('assets/pdf.png',
                  fit: BoxFit.fitHeight, width: 58, height: 58)
            ],
          ),
        );
      }
    } else {
      return Container();
    }
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {});
  }

  Future _getImageFromSource(ImageSource source) async {
    final File image = await ImagePicker.pickImage(source: source);
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    final File newImage = await image.copy('$directory/$fileName.png');
    setState(() {
      this.image = newImage;
      isImage = true;
      filePath = newImage.path;
    });
  }

  void _onPhotoOfPartPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: new Text(FlutterI18n.translate(context, 'Camera'),
                style: Theme.of(context).textTheme.display1),
            onPressed: () {
              Navigator.pop(context);
              _getImageFromSource(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: new Text(
                FlutterI18n.translate(context, 'Choose from gallery'),
                style: Theme.of(context).textTheme.display1),
            onPressed: () {
              Navigator.pop(context);
              _getImageFromSource(ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: new Text(FlutterI18n.translate(context, 'Cancel'),
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, 'Cancel'),
        ),
      ),
    );
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
//        title: const Text('Favorite Dessert'),
//        message: const Text('Please select the best dessert from the options below.'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: new Text(FlutterI18n.translate(context, 'Photo of part'),
                style: Theme.of(context).textTheme.display1),
            onPressed: () {
              Navigator.pop(context);
              _onPhotoOfPartPress(context);
            },
          ),
          CupertinoActionSheetAction(
            child: new Text(
                FlutterI18n.translate(context, 'Invoice of product'),
                style: Theme.of(context).textTheme.display1),
            onPressed: () {
              Navigator.pop(context);
              _getDocuments();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: new Text(FlutterI18n.translate(context, 'Cancel'),
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, 'Cancel'),
        ),
      ),
    );
  }

  String _getNameByFitting() {
    switch (typeFitting) {
      case TypeFitting.windows:
        return FlutterI18n.translate(context, 'Windows fittings');
      case TypeFitting.sunShading:
        return FlutterI18n.translate(context, 'Sun shading and screening');
      default:
        return FlutterI18n.translate(context, 'Other fitting');
    }
  }

  _saveArticle() async {
    debugPrint('saving windows');
    final windows = Windows.withData(
        _getNameByFitting(),
        DateTime.now(),
        yearCtr.text,
        numberCtr.text != '' ? int.parse(numberCtr.text) : 0,
        systemCtr.text,
        profileCtr.text,
        descriptionCtr.text,
        filePath,
        isImage);
    final pdfPath = await PDFManagerWindow.getPDFPath(windows);
    windows.pdfPath = pdfPath;
    int id = await helper.insert(windows);
    print('inserted row: $id');
    if (id != null) {
      NavigationUtils.pushCupertino(
        context,
        FittingPDFViewerPage(
          model: windows,
        ),
      );
//      Navigator.push(context,context
//          CupertinoPageRoute(builder: (context) => ArticleWebPreview(windows)));
//      debugPrint('poping');
//      Navigator.of(context).popUntil((route) => route.settings.name == "ArticleIdentificationV");
    }
  }

  Widget _getSystemDepth() {
    if (typeFitting == TypeFitting.other ||
        typeFitting == TypeFitting.windows) {
      return InkWell(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                      FlutterI18n.translate(context, 'System depth (mm)'),
                      style: Theme.of(context).textTheme.body1,
                      textAlign: TextAlign.left),
                ),
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
                    controller: systemCtr,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (next) {
                      _changeFocus(context, profileSystemNode, descriptionNode);
                    },
                    decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: '50 mm',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ),
              ],
            )),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child:
                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            )
          ],
        ),
        onTap: () {
          List<String> myOptions = [];
          SystemDepth.values.forEach((e) =>
              myOptions.add(e.toString().split(".")[1].replaceAll("e", "")));
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => GenericSelection(
                      FlutterI18n.translate(context, 'System depth (mm)'),
                      myOptions))).then((systemDepth) {
            setState(() {
              systemCtr.text = systemDepth;
            });
          });
        },
      );
    } else
      return Container(height: 0);
  }

  Widget _getProfileSystem() {
    if (typeFitting == TypeFitting.other ||
        typeFitting == TypeFitting.windows) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(
                FlutterI18n.translate(context, 'Profile system / -serie'),
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.left),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: profileSystemNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.body1,
              maxLines: 1,
              controller: profileCtr,
              textInputAction: TextInputAction.next,
              onSubmitted: (next) {
                _changeFocus(context, profileSystemNode, descriptionNode);
              },
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: FlutterI18n.translate(context, 'Profile'),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
        ],
      );
    } else
      return Container(height: 0);
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
              numberNode.unfocus();
              yearNode.unfocus();
              profileSystemNode.unfocus();
              descriptionNode.unfocus();
              _saveArticle();
            },
            child: Image.asset(
              'assets/checkGreen.png',
              height: 25,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(
                FlutterI18n.translate(
                    context, 'Part number of defective component'),
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: numberNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.body1,
              maxLines: 1,
              controller: numberCtr,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSubmitted: (next) {
                _changeFocus(context, numberNode, yearNode);
              },
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: FlutterI18n.translate(context, 'Number'),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(FlutterI18n.translate(context, 'Year of construction'),
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
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSubmitted: (next) {
                _changeFocus(
                    context,
                    yearNode,
                    typeFitting == TypeFitting.sunShading
                        ? descriptionNode
                        : profileSystemNode);
              },
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'YYYY',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              onChanged: (value) => _yearChange(),
            ),
          ),
          Divider(height: 1),
          _getSystemDepth(),
          Divider(height: typeFitting == TypeFitting.sunShading ? 0 : 1),
          _getProfileSystem(),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(FlutterI18n.translate(context, 'Description'),
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.left),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: descriptionNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.body1,
              maxLines: 1,
              controller: descriptionCtr,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: FlutterI18n.translate(context, 'Part details'),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: GestureDetector(
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        FlutterI18n.translate(context, 'Upload'),
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    )),
                onTap: () => _onActionSheetPress(context),
              )),
          _getImageOfFile()
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
