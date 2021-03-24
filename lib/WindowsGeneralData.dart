import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:repairservices/res/R.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairservices/ArticleWebPreview.dart';
import 'package:repairservices/GenericSelection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/ui/pdf_viewer/pdf_viewer_page.dart';

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
  List<ImageFileModel> files;
  bool isSunShading;

  @override
  void initState() {
    super.initState();
    numberNode = FocusNode();
    yearNode = FocusNode();
    profileSystemNode = FocusNode();
    descriptionNode = FocusNode();
    systemCtr.text = '50mm';
    files = [];
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
      String filePath = await FilePicker.getFilePath(
          type: FileType.custom, allowedExtensions: ['PDF']);
      File pdf = File(filePath);
      if (!canAddNewFile(pdf)) {
        Fluttertoast.showToast(
            msg: "The size limit has been reached",
            toastLength: Toast.LENGTH_LONG);
        return;
      }
      final path = await FileUtils.getRootFilesDir();
      final fileName = CalendarUtils.getTimeIdBasedSeconds();
      final File newFile = await pdf.copy('$path/$fileName.pdf');
      await newFile.create();
      setState(() {
        files.add(ImageFileModel(
            isImage: false, filePath: newFile.path, file: newFile));
        debugPrint('Archive file path: ${newFile.path}');
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {});
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {});
  }

  Future _getImageFromSource(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    final File newImage = File(pickedFile.path);
    if (!canAddNewFile(newImage)) {
      Fluttertoast.showToast(
          msg: "The size limit has been reached",
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    await newImage.copy('$directory/$fileName.png');
    setState(() {
      files.add(ImageFileModel(
          isImage: true, filePath: newImage.path, file: newImage));
    });
  }

  void _onPhotoOfPartPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: new Text(R.string.camera,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () {
              Navigator.pop(context);
              _getImageFromSource(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: new Text(R.string.chooseFromGallery,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () {
              Navigator.pop(context);
              _getImageFromSource(ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: new Text(R.string.cancel,
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
            child: new Text(R.string.photoOfPart,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () {
              Navigator.pop(context);
              _onPhotoOfPartPress(context);
            },
          ),
          CupertinoActionSheetAction(
            child: new Text(R.string.invoiceOfProduct,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () {
              Navigator.pop(context);
              _getDocuments();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: new Text(R.string.cancel,
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
        return R.string.windowsFittings;
      case TypeFitting.sunShading:
        return R.string.sunShadingScreening;
      default:
        return R.string.otherFitting;
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
        files);
    final pdfPath = await PDFManagerWindow.getPDFPath(windows);
    windows.pdfPath = pdfPath;
    int id = await helper.insert(windows);
    print('inserted row: $id');
    if (id != null) {
      NavigationUtils.pushCupertino(
        context,
        PDFViewerPage(
          model: windows,
        ),
      );
//      Navigator.push(context,context
//          CupertinoPageRoute(builder: (context) => ArticleWebPreview(windows)));
//      debugPrint('poping');
//      Navigator.of(context).popUntil((route) => route.settings.name == "ArticleIdentificationV");
    }
  }

  bool canAddNewFile(File f) {
    var size = 0;
    files.forEach((element) {
      size += element.file.lengthSync();
    });
    return size + f.lengthSync() <= 35700160;
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
                  child: Text(R.string.systemDepthMM,
                      style: Theme.of(context).textTheme.bodyText2,
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
                    style: Theme.of(context).textTheme.bodyText2,
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
                      builder: (context) =>
                          GenericSelection(R.string.systemDepthMM, myOptions)))
              .then((systemDepth) {
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
            child: Text(R.string.profileSystemSerie,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.left),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: profileSystemNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: profileCtr,
              textInputAction: TextInputAction.next,
              onSubmitted: (next) {
                _changeFocus(context, profileSystemNode, descriptionNode);
              },
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: R.string.profile,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
        ],
      );
    } else
      return Container(height: 0);
  }

  void _navBack() {
    files.forEach((element) {
      if(element.file.existsSync()) element.file.deleteSync();
    });
    Navigator.pop(context);
  }

  final double _gridElementWidth = 150;

  @override
  Widget build(BuildContext context) {
    double actualWidth = MediaQuery.of(context).size.width;
    double availableWidth = actualWidth - 10;
    final elements = (availableWidth / (_gridElementWidth + 10)).floor();
    return WillPopScope(
        onWillPop: () async {
          _navBack();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Colors.white,
            actionsIconTheme:
                IconThemeData(color: Theme.of(context).primaryColor),
            title: Text(R.string.generalData,
                style: Theme.of(context).textTheme.bodyText2),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: _navBack,
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
            child: Text(R.string.partNumberDefectiveComponent,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: numberNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: numberCtr,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onSubmitted: (next) {
                _changeFocus(context, numberNode, yearNode);
              },
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: R.string.number,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(R.string.yearConstruction,
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
            child: Text(R.string.description,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.left),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: new TextField(
              focusNode: descriptionNode,
              textAlign: TextAlign.left,
              expands: false,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 1,
              controller: descriptionCtr,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: R.string.partDetails,
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
                        R.string.upload,
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    )),
                onTap: () => _onActionSheetPress(context),
              )),
          GridView.count(
            crossAxisCount: elements,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              ..._getListImageOfFile(),
            ],
          ),
        ],
      ),
    ));
  }

  List<Widget> _getListImageOfFile() =>
      files.map((e) => _getImageOfFile(e)).toList();

  Widget _getImageOfFile(ImageFileModel f) {
    return Container(
      width: _gridElementWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.clear_circled,
                    color: Theme.of(context).primaryColor,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      files.remove(f);
                    });
                  },
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              OpenFile.open(f.filePath);
            },
            child: Container(
              width: 100,
              child: f.isImage
                  ? Image.file(f.file, fit: BoxFit.contain)
                  : Image.asset('assets/pdf.png', fit: BoxFit.contain),
            ),
          ),
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
