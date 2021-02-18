import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_date_picker.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/article_resources/audio/audio_page.dart';
import 'package:repairservices/ui/article_resources/video/video_page.dart';
import 'package:repairservices/ui/marker_component/drawer_container_page.dart';
import 'package:repairservices/ui/project_documentation/project_report/add_edit_project_report_bloc.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/extensions.dart';
import 'package:repairservices/utils/file_utils.dart';

import '../project_category_page.dart';

class AddEditProjectReportPage extends StatefulWidget {
  final ProjectDocumentReportModel projectDocumentReportModel;

  const AddEditProjectReportPage({
    Key key,
    this.projectDocumentReportModel,
  }) : super(key: key);

  @override
  _ProjectReportPageState createState() => _ProjectReportPageState();
}

class _ProjectReportPageState
    extends StateWithBloC<AddEditProjectReportPage, AddEditProjectReportBloC> {
  var noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteController.text = widget?.projectDocumentReportModel?.shortInfo ?? "";
    bloc.init(widget.projectDocumentReportModel);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<ProjectDocumentReportModel>(
        stream: bloc.projectReportResult,
        initialData: bloc.projectDocumentReportModel,
        builder: (context, snapshot) {
          final ProjectDocumentReportModel projectReport = snapshot.data;
          final isEditing = projectReport.isEditing;
          final CellEditMode cellEditMode =
              isEditing ? CellEditMode.input : CellEditMode.detail;
          return TXMainBarWidget(
              title: R.string.newReport,
              onLeadingTap: () {
                NavigationUtils.pop(context);
              },
              actions: [
                InkWell(
                  onTap: () {
                    NavigationUtils.pop(context,
                        result: bloc.projectDocumentReportModel);
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
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TXItemCellEditWidget(
                        title: R.string.category,
                        value: bloc.projectDocumentReportModel?.category ?? "",
                        placeholder: isEditing
                            ? bloc.projectDocumentReportModel.category
                                        ?.isNotEmpty ==
                                    true
                                ? bloc.projectDocumentReportModel.category
                                : R.string.category
                            : bloc.projectDocumentReportModel.category,
                        cellEditMode: isEditing
                            ? CellEditMode.selector
                            : CellEditMode.detail,
                        onSubmitted: (valueSubmitted) {
                          NavigationUtils.pushCupertino(
                              context,
                              ProjectCategoryPage(
                                currentCategory:
                                    bloc.projectDocumentReportModel.category,
                                categoryType: CategoryType.report,
                              )).then((value) {
                            bloc.projectDocumentReportModel.category = value;
                            bloc.refreshData;
                          });
                        },
                      ),
                      TXItemCellEditWidget(
                        title: "",
                        value: CalendarUtils.showInFormat(
                            R.string.dateFormat1,
                            bloc.projectDocumentReportModel.date ??
                                DateTime.now()),
                        cellEditMode: CellEditMode.selector,
                        onSubmitted: (valueSubmitted) {
                          _selectDate(context, onDateChange: (date) {
                            bloc.currentDate = date;
                          }, onOK: () {
                            bloc.projectDocumentReportModel.date =
                                bloc.currentDate;
                          }, mode: CupertinoDatePickerMode.date);
                        },
                      ),
                      TXDividerWidget(),
                      InkWell(
                        onTap: () {
                          _selectDate(context, onDateChange: (date) {
                            bloc.beginDate = date;
                          }, onOK: () {
                            bloc.projectDocumentReportModel.begin =
                                bloc.beginDate;
                            bloc.refreshData;
                          }, mode: CupertinoDatePickerMode.time);
                        },
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child:
                                      TXTextWidget(text: R.string.beginDate)),
                              TXTextWidget(
                                  color: R.color.primary_color,
                                  fontWeight: FontWeight.bold,
                                  text: bloc.projectDocumentReportModel.begin ==
                                          null
                                      ? "HH:MM"
                                      : CalendarUtils.showInFormat(
                                          R.string.dateFormat2,
                                          bloc.projectDocumentReportModel
                                              .begin))
                            ],
                          ),
                        ),
                      ),
                      TXDividerWidget(),
                      InkWell(
                        onTap: () {
                          _selectDate(context, onDateChange: (date) {
                            bloc.endDate = date;
                          }, onOK: () {
                            bloc.projectDocumentReportModel.end = bloc.endDate;
                            bloc.refreshData;
                          }, mode: CupertinoDatePickerMode.time);
                        },
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TXTextWidget(text: R.string.endDate)),
                              TXTextWidget(
                                  color: R.color.primary_color,
                                  fontWeight: FontWeight.bold,
                                  text: bloc.projectDocumentReportModel.end ==
                                          null
                                      ? "HH:MM"
                                      : CalendarUtils.showInFormat(
                                          R.string.dateFormat2,
                                          bloc.projectDocumentReportModel.end))
                            ],
                          ),
                        ),
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.note,
                        controller: noteController,
                        cellEditMode: cellEditMode,
                        multiLine: true,
                        placeholder: isEditing
                            ? "${R.string.note} ${R.string.additions.toLowerCase()}"
                            : "",
                        value: bloc.projectDocumentReportModel.shortInfo,
                        onChanged: (value) {
                          bloc.projectDocumentReportModel.shortInfo = value;
                        },
                      ),
                      TXDividerWidget(),
                      SizedBox(
                        height: 100,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.photo,
                        cellEditMode: isEditing
                            ? CellEditMode.selector
                            : CellEditMode.detail,
                        onSubmitted: (valueSubmitted) {
                          _onPhotoOfPartPress(context);
                        },
                      ),
                      (projectReport.photo?.isNotEmpty == true)
                          ? Container(
                              width: double.infinity,
                              child: Image.file(
                                File(
                                  projectReport.photo,
                                ),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10),
                            )
                          : Container(),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.measurementCamera,
                        cellEditMode: isEditing
                            ? CellEditMode.selector
                            : CellEditMode.detail,
                        onSubmitted: (valueSubmitted) async {
                          String path = bloc.projectDocumentReportModel
                                  ?.measurementCamera ??
                              "";

                          if (path.isEmpty)
                            path =
                                await _getImageFromSource(ImageSource.camera);

                          if (path.isEmpty) return;

                          final res = await NavigationUtils.push(
                              context,
                              DrawerContainerPage(
                                imagePath: path,
                                autoSave: false,
                              ));
                          if (res != null && res is String) {
                            bloc.projectDocumentReportModel.video =
                                res;
                            bloc.refreshData;
                          }
                        },
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.video,
                        cellEditMode: isEditing
                            ? CellEditMode.selector
                            : CellEditMode.detail,
                        onSubmitted: (valueSubmitted) async {
                          String path =
                              bloc.projectDocumentReportModel?.video ?? "";

                          if (path.isEmpty)
                            path = await _getImageFromSource(ImageSource.camera,
                                isImage: false);

                          if (path.isEmpty) return;

                          final res = await NavigationUtils.push(
                              context,
                              VideoPage(
                                model: MemoVideoModel(filePath: path),
                              ));
                          if (res is MemoVideoModel) {
                            bloc.projectDocumentReportModel.video =
                                res.filePath;
                            bloc.refreshData;
                          }
                        },
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.voiceMemo,
                        cellEditMode: isEditing
                            ? CellEditMode.selector
                            : CellEditMode.detail,
                        onSubmitted: (valueSubmitted) async {
                          String path =
                              bloc.projectDocumentReportModel?.voiceMemo ?? "";

                          final res = await NavigationUtils.push(
                              context,
                              AudioPage(
                                model: MemoAudioModel(filePath: path),
                              ));
                          if (res is MemoAudioModel) {
                            bloc.projectDocumentReportModel.voiceMemo =
                                res.filePath;
                            bloc.refreshData;
                          }
                        },
                      ),
                      TXDividerWidget(),
                    ],
                  ),
                ),
              ));
        });
  }

  void _selectDate(BuildContext context,
      {CupertinoDatePickerMode mode,
      ValueChanged<DateTime> onDateChange,
      Function onOK}) async {
    showModalBottomSheet<DateTime>(
        context: context,
        builder: (context) {
          return TXCupertinoDatePicker(
            onDateChange: onDateChange,
            onOK: onOK,
            mode: mode,
          );
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
            onPressed: () async {
              Navigator.pop(context);
              final path = await _getImageFromSource(ImageSource.camera);
              bloc.projectDocumentReportModel.photo = path;
              bloc.refreshData;
            },
          ),
          CupertinoActionSheetAction(
            child: new Text(R.string.chooseFromGallery,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () async {
              Navigator.pop(context);
              final path = await _getImageFromSource(ImageSource.gallery);
              bloc.projectDocumentReportModel.photo = path;
              bloc.refreshData;
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

  Future<String> _getImageFromSource(ImageSource source,
      {bool isImage = true}) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = isImage
        ? await _picker.getImage(source: source)
        : await _picker.getVideo(source: source);
    if (pickedFile == null) return "";
    final directory = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    final File newImage =
        await File(pickedFile.path).copy('$directory/$fileName.png');
    return newImage.path;
  }
}
