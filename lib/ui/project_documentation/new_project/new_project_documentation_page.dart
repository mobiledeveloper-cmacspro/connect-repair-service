import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cell_check_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_gesture_hide_key_board.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_textfield_widget.dart';
import 'package:repairservices/ui/project_documentation/new_project/new_project_documentation_bloc.dart';
import 'package:repairservices/ui/project_documentation/new_project/project_category_page.dart';
import 'package:repairservices/ui/project_documentation/new_project/projecto_address_page.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/file_utils.dart';

class NewProjectDocumentationPage extends StatefulWidget {
  final ProjectDocumentModel model;

  NewProjectDocumentationPage({this.model});

  @override
  _NewProjectDocumentationPageState createState() =>
      _NewProjectDocumentationPageState();
}

class _NewProjectDocumentationPageState extends StateWithBloC<
    NewProjectDocumentationPage, NewProjectDocumentationBloC> {
  final _keyFormCreateProject = new GlobalKey<FormState>();
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var abbreviationController = TextEditingController();
  var addressController = TextEditingController();
  var participantsController = TextEditingController();
  var totalCostsController = TextEditingController();
  String category;
  var infoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.init(widget.model);
    bloc.stream.listen((event) {
      if (event) NavigationUtils.pop(context);
    });
    if (widget.model != null) _initData();
  }

  _initData() {
    nameController.text = widget.model.name;
    numberController.text = widget.model?.number?.toString() ?? "";
    abbreviationController.text = widget.model?.abbreviation ?? "";
    addressController.text = widget.model?.address?.addressStr ?? "";
    participantsController.text = widget.model?.participants?.toString() ?? "";
    totalCostsController.text = widget.model?.totalCost?.toString() ?? "";
    category = widget.model?.category ?? "";
    infoController.text = widget.model?.info ?? "";
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title:
            Text('New Project', style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: [
          InkWell(
            onTap: () {
              if (nameController.text.trim().isEmpty) {
                Fluttertoast.showToast(
                    msg: R.string.fieldRequired,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    toastLength: Toast.LENGTH_LONG);
                return;
              }
              bloc.save();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                R.image.checkGreen,
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
      ),
      body: TXGestureHideKeyBoard(
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) => Container(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Form(
                key: _keyFormCreateProject,
                child: StreamBuilder<ProjectDocumentModel>(
                    stream: bloc.projectResult,
                    initialData: bloc.projectDocumentModel,
                    builder: (context, snapshot) {
                      final ProjectDocumentModel project = snapshot.data;
                      final isEditing = project.isEditing;
                      final CellEditMode cellEditMode =
                          isEditing ? CellEditMode.input : CellEditMode.detail;
                      return Column(
                        children: [
                          TXItemCellEditWidget(
                            title: R.string.projectName,
                            isMandatory: true,
                            controller: nameController,
                            cellEditMode: cellEditMode,
                            placeholder: isEditing
                                ? "${R.string.projectName} ${R.string.additions.toLowerCase()}"
                                : "",
                            value: nameController.text,
                            onChanged: (value) {
                              nameController.text = value;
                              bloc.projectDocumentModel.name = value;
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.projectNumber,
                            controller: numberController,
                            cellEditMode: cellEditMode,
                            keyboardType: TextInputType.number,
                            value: numberController.text,
                            placeholder: isEditing
                                ? "${R.string.projectNumber} ${R.string.additions.toLowerCase()}"
                                : "",
                            onChanged: (value) {
                              numberController.text = value;
                              bloc.projectDocumentModel.number =
                                  int.tryParse(value) ?? 0;
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.projectShortName,
                            controller: abbreviationController,
                            cellEditMode: cellEditMode,
                            value: abbreviationController.text,
                            placeholder: isEditing
                                ? "${R.string.projectShortName} ${R.string.additions.toLowerCase()}"
                                : "",
                            onChanged: (value) {
                              abbreviationController.text = value;
                              bloc.projectDocumentModel.info = value;
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.address,
                            value: addressController.text,
                            placeholder: isEditing
                                ? "${R.string.address} ${R.string.additions.toLowerCase()}"
                                : "",
                            controller: addressController,
                            cellEditMode: project.isEditing
                                ? CellEditMode.selector
                                : CellEditMode.detail,
                            onSubmitted: (addresValue) {
                              NavigationUtils.pushCupertino(
                                  context,
                                  ProjectAddressPage(
                                    currentAddress:
                                        bloc.projectDocumentModel.address,
                                  )).then((newAddress) {
                                if (newAddress != null &&
                                    newAddress is ProjectDocumentAddressModel) {
                                  addressController.text =
                                      newAddress.addressStr;
                                  bloc.projectDocumentModel.address =
                                      newAddress;
                                  bloc.refreshData;
                                }
                              });
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.participants,
                            controller: participantsController,
                            cellEditMode: cellEditMode,
                            keyboardType: TextInputType.number,
                            placeholder:
                                isEditing ? R.string.nothingDeposited : "",
                            value: participantsController.text,
                            onChanged: (value) {
                              participantsController.text = value;
                              bloc.projectDocumentModel.participants =
                                  int.tryParse(value);
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.totalCost,
                            controller: totalCostsController,
                            value: totalCostsController.text,
                            cellEditMode: cellEditMode,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                            placeholder:
                                isEditing ? R.string.nothingDeposited : "",
                            onChanged: (value) {
                              totalCostsController.text = value;
                              bloc.projectDocumentModel.totalCost =
                                  double.tryParse(value);
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: "",
                            value: R.string.photo,
                            cellEditMode: isEditing
                                ? CellEditMode.selector
                                : CellEditMode.detail,
                            onSubmitted: (valueSubmitted) {
                              _onPhotoOfPartPress(context);
                            },
                          ),
                          (project.photo?.isNotEmpty == true)
                              ? Container(
                                  width: double.infinity,
                                  child: Image.file(
                                    File(
                                      project.photo,
                                    ),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                  alignment: Alignment.centerLeft,
                                )
                              : Container(),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.category,
                            value: bloc.projectDocumentModel?.category ?? "",
                            placeholder: isEditing
                                ? bloc.projectDocumentModel.category
                                            ?.isNotEmpty ==
                                        true
                                    ? bloc.projectDocumentModel.category
                                    : R.string.category
                                : bloc.projectDocumentModel.category,
                            cellEditMode: isEditing
                                ? CellEditMode.selector
                                : CellEditMode.detail,
                            onSubmitted: (valueSubmitted) {
                              NavigationUtils.pushCupertino(
                                  context,
                                  ProjectCategoryPage(
                                    currentCategory:
                                        bloc.projectDocumentModel.category,
                                  )).then((value) {
                                bloc.projectDocumentModel.category = value;
                                bloc.refreshData;
                              });
                            },
                          ),
                          TXDividerWidget(),
                          TXItemCellEditWidget(
                            title: R.string.projectInfo,
                            controller: infoController,
                            value: infoController.text,
                            cellEditMode: cellEditMode,
                            placeholder: isEditing
                                ? "${R.string.projectInfo} ${R.string.additions.toLowerCase()}"
                                : "",
                            multiLine: true,
                            onChanged: (value) {
                              infoController.text = value;
                              bloc.projectDocumentModel.info = value;
                            },
                          ),
                          TXDividerWidget(),
                        ],
                      );
                    }),
              ),
            )),
            Container(
              margin: EdgeInsets.only(bottom: 0),
              height: 70,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TXTextWidget(
                          text: R.string.edit,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () {
                      bloc.projectDocumentModel.isEditing =
                          !bloc.projectDocumentModel.isEditing;
                      bloc.refreshData;
                    },
                  ),
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TXTextWidget(
                          text: R.string.newReport,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () async {},
                  ),
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.filter_none,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TXTextWidget(
                          text: R.string.reportArchive,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () async {},
                  ),
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: new Image.asset('assets/exportWhite.png'),
                        ),
                        TXTextWidget(
                          text: R.string.export,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () async {},
                  )
                ],
              ),
            )
          ],
        ),
      );

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

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {});
  }

  Future _getImageFromSource(ImageSource source) async {
    final File image = await ImagePicker.pickImage(source: source);
    if (image == null) return;
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    final File newImage = await image.copy('$directory/$fileName.png');
    bloc.projectDocumentModel.photo = newImage.path;
    bloc.refreshData;
  }
}
