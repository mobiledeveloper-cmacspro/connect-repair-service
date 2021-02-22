import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/project_documentation/project_documentation_bloc.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cell_check_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_action_sheet_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_loading_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/article_identification/article_identification_bloc.dart';
import 'package:repairservices/models/Windows.dart';
import '../../SettingArticleIdentification.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'new_project/new_project_documentation_page.dart';

class ProjectDocumentationV extends StatefulWidget {
  @override
  _ArticleIdentificationState createState() =>
      new _ArticleIdentificationState();
}

class _ArticleIdentificationState
    extends StateWithBloC<ProjectDocumentationV, ProjectDocumentationBloC> {
  List<Fitting> articleList;
  int selected = 0;
  bool selecting = false;
  String lastSelectedValue;

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: new Text(R.string.print,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () => Navigator.pop(context, 'Print'),
          ),
          CupertinoActionSheetAction(
            child: new Text(R.string.email,
                style: Theme.of(context).textTheme.headline4),
            onPressed: () => Navigator.pop(context, 'Email'),
          ),
          CupertinoActionSheetAction(
            child: new Text(R.string.remove,
                style: TextStyle(color: Colors.red, fontSize: 22.0)),
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, 'Remove'),
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

  @override
  void initState() {
    super.initState();
    bloc.loadArticles();

    Future.delayed(Duration(seconds: 1)).then((value) async {
      Directory appDocDir = await FileUtils.getRootFilesDirectory();
      final List<FileSystemEntity> files = appDocDir.listSync();
      files.forEach((element) {
        print(element.path);
      });
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder<bool>(
            stream: bloc.selectionModeResult,
            initialData: bloc.isInSelectionMode,
            builder: (ctx, snapshotMode) {
              return TXMainBarWidget(
                title: R.string.projectDoc,
                onLeadingTap: () {
                  Navigator.pop(context);
                },
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TXDividerWidget(),
                    _orderBar(),
                    TXDividerWidget(),
                    Expanded(
                      child: StreamBuilder<List<ArticleBase>>(
                        stream: bloc.articlesResult,
                        initialData: [],
                        builder: (context, snapshot) {
                          final list = snapshot.data ?? [];
                          if(list.length > 1){
                            alphabetical
                                ? list.sort((a, b) => (a
                            as ProjectDocumentModel)
                                .name.toLowerCase()
                                .compareTo((b as ProjectDocumentModel).name.toLowerCase())) :
                            list.sort((a, b) => (b
                            as ProjectDocumentModel)
                                .date.millisecondsSinceEpoch
                                .compareTo((a as ProjectDocumentModel).date.millisecondsSinceEpoch));
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index) {
                                final articleBaseModel = snapshot.data[index];
                                return _getArticle(context, articleBaseModel);
                              });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new InkWell(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child:
                                      new Image.asset('assets/gearWhite.png'),
                                ),
                                new Text(
                                  R.string.setting,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.5),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        SettingsArticleIdentificationV()),
                              );
                            },
                          ),
                          new InkWell(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.add_circled,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                new Text(
                                  R.string.newProject,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.5),
                                )
                              ],
                            ),
                            onTap: () async {
                              await NavigationUtils.pushCupertino(
                                  context, NewProjectDocumentationPage());
                              bloc.loadArticles();
                            },
                          ),
                          new InkWell(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child:
                                      new Image.asset('assets/exportWhite.png'),
                                ),
                                new Text(
                                  R.string.export,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.5),
                                )
                              ],
                            ),
                            onTap: () async {
                              final list =
                                  (await bloc.articlesResult.first ?? [])
                                      .where((a) => a.isSelected)
                                      .toList();
                              if (list.isNotEmpty) {
                                launchOptions(context);
                              } else if (!bloc.isInSelectionMode) {
                                bloc.setSelectionMode = true;
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  bool alphabetical = true;

  Widget _orderBar() => Container(
        height: 50,
        width: double.maxFinite,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    alphabetical = true;
                  });
                },
                child: Container(
                  width: 120,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    border: Border.all(color: R.color.gray, width: 0.5),
                    color: alphabetical
                        ? R.color.primary_color
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: TXTextWidget(
                      text: R.string.alphabetical,
                      color: alphabetical ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    alphabetical = false;
                  });
                },
                child: Container(
                  width: 120,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    border: Border.all(color: R.color.gray, width: 0.5),
                    color: !alphabetical
                        ? R.color.primary_color
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: TXTextWidget(
                      text: R.string.chronological,
                      color: !alphabetical ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _getArticle(BuildContext context, ArticleBase articleBase) {
    return Container(
        color: R.color.gray_light,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: Column(
            children: <Widget>[
              TXCellCheckWidget(
                checkMode: bloc.isInSelectionMode
                    ? CellCheckMode.check
                    : CellCheckMode.selector,
                isChecked: articleBase.isSelected,
                title: (articleBase as ProjectDocumentModel).name,
                subtitle: CalendarUtils.showInFormat(
                    "dd/MM/yyyy", (articleBase as ProjectDocumentModel).date),
                leading: Image.asset(
                  'assets/productImage.png',
                  height: 40,
                  width: 50,
                ),
                onLongPress: bloc.isInSelectionMode
                    ? null
                    : () {
                        articleBase.isSelected = true;
                        bloc.setSelectionMode = true;
                      },
                onTap: () async {
                  if (bloc.isInSelectionMode) {
                    articleBase.isSelected = !articleBase.isSelected;
                    bloc.refreshList();
                  } else {
                    NavigationUtils.push(
                        context,
                        NewProjectDocumentationPage(
                          model: articleBase as ProjectDocumentModel,
                        )).then((_) {
                      bloc.loadArticles();
                    });
                  }
                },
              ),
              TXDividerWidget()
            ],
          ),
          secondaryActions: bloc.isInSelectionMode
              ? []
              : [
                  IconSlideAction(
                    caption: R.string.delete,
                    color: Colors.red,
                    icon: CupertinoIcons.delete,
                    onTap: () {
                      articleBase.isSelected = true;
                      bloc.deleteArticle();
                    },
                  ),
                ],
        ));
  }

  void launchOptions(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return TXCupertinoActionSheetWidget(
            onActionTap: (action) async {
              if (action.key == 'Print' || action.key == 'Email') {
                bloc.exportByEmail();
              } else if (action.key == 'Remove') {
                bloc.deleteArticle();
              }
            },
            actions: [
              ActionSheetModel(
                  key: "Print",
                  title: R.string.print,
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Email",
                  title: R.string.email,
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Remove", title: R.string.remove, color: Colors.red)
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
