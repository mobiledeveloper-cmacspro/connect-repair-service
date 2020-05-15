import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/ArticleWebPreview.dart';
import 'package:repairservices/DoorLockData.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/domain/common_model.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/cnt_loading_fullscreen.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cell_check_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_action_sheet_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_loading_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/ui/article_detail/article_detail_page.dart';
import 'package:repairservices/ui/article_identification/article_identification_bloc.dart';
import 'package:repairservices/ui/article_identification/article_identification_gallery_page.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_door_hinge_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_door_lock_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_sliding_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_detail_page.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';
import '../../database_helpers.dart';
import 'package:repairservices/models/Windows.dart';
import '../../IdentificationType.dart';
import '../../SettingArticleIdentification.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ArticleIdentificationV extends StatefulWidget {
  @override
  _ArticleIdentificationState createState() =>
      new _ArticleIdentificationState();
}

class _ArticleIdentificationState
    extends StateWithBloC<ArticleIdentificationV, ArticleIdentificationBloC> {
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
            child: new Text(FlutterI18n.translate(context, 'Print'),
                style: Theme.of(context).textTheme.display1),
            onPressed: () => Navigator.pop(context, 'Print'),
          ),
          CupertinoActionSheetAction(
            child: new Text(FlutterI18n.translate(context, 'Email'),
                style: Theme.of(context).textTheme.display1),
            onPressed: () => Navigator.pop(context, 'Email'),
          ),
          CupertinoActionSheetAction(
            child: new Text(FlutterI18n.translate(context, 'Remove'),
                style: TextStyle(color: Colors.red, fontSize: 22.0)),
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, 'Remove'),
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

  @override
  void initState() {
    super.initState();
    bloc.loadArticles();
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
                title: FlutterI18n.translate(context, 'Article Identification'),
                onLeadingTap: () {
                  Navigator.pop(context);
                },
                actions: <Widget>[
                  TXIconButtonWidget(
                    onPressed: () async {
                      final list = await bloc.articlesResult.first ?? [];
                      if (snapshotMode.data) {
                        list.forEach((a) => a.isSelected = false);
                        bloc.setSelectionMode = !bloc.isInSelectionMode;
                      } else {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  ArticleIdentificationGalleryPage(
                                    articles: list,
                                  )),
                        );
                      }
                    },
                    icon: snapshotMode.data
                        ? Image.asset(R.image.checkGreen)
                        : Icon(
                            Icons.image,
                            color: R.color.primary_color,
                            size: 25,
                          ),
                  ),
                ],
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TXDividerWidget(),
                    Expanded(
                      child: StreamBuilder<List<ArticleBase>>(
                        stream: bloc.articlesResult,
                        initialData: [],
                        builder: (context, snapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
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
                                  FlutterI18n.translate(context, 'Setting'),
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
                                new Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: new Image.asset(
                                      'assets/articleLookUpWhite.png'),
                                ),
                                new Text(
                                  FlutterI18n.translate(context, 'Find Part'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.5),
                                )
                              ],
                            ),
                            onTap: () async {
                              await NavigationUtils.pushCupertino(
                                  context, IdentificationTypeV());
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
                                  FlutterI18n.translate(context, 'Export'),
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
                title: articleBase is ArticleLocalModel
                    ? articleBase.displayName
                    : (articleBase as Fitting).name,
                subtitle: CalendarUtils.showInFormat(
                    "dd/MM/yyyy",
                    articleBase is ArticleLocalModel
                        ? articleBase.createdOnScreenShoot
                        : (articleBase as Fitting).created),
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
                    if (articleBase is Fitting) {
                      if (articleBase is Windows) {
                        await NavigationUtils.pushCupertino(
                          context,
                          FittingWindowsDetailPage(
                            model: articleBase,
                            typeFitting:
                                articleBase.systemDepth?.isNotEmpty == true
                                    ? TypeFitting.windows
                                    : TypeFitting.sunShading,
                          ),
                        );
                      } else if (articleBase is Sliding) {
                        await NavigationUtils.pushCupertino(
                          context,
                          FittingSlidingDetailPage(
                            model: articleBase,
                          ),
                        );
                      } else if (articleBase is DoorLock) {
                        await NavigationUtils.pushCupertino(
                          context,
                          FittingDoorLockDetailPage(
                            model: articleBase,
                          ),
                        );
                      } else if (articleBase is DoorHinge) {
                        await NavigationUtils.pushCupertino(
                          context,
                          FittingDoorHingeDetailPage(
                            model: articleBase,
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: FlutterI18n.translate(
                                context, "Object not recognized"));
                      }
                    } else {
                      await NavigationUtils.pushCupertino(
                        context,
                        ArticleLocalDetailPage(
                          articleLocalModel: articleBase,
                          isForMail: true,
                          navigateFromDetail: true,
                        ),
                      );
                    }
                    bloc.loadArticles();
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
                    caption: FlutterI18n.translate(context, 'Email'),
                    foregroundColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    icon: CupertinoIcons.mail,
                    onTap: () {
                      bloc.sendPdfByEmail(articleBase);
                    },
                  ),
                  IconSlideAction(
                    caption: FlutterI18n.translate(context, 'Delete'),
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
              } else if (action.key == 'Remove') {
                bloc.deleteArticle();
              }
            },
            actions: [
              ActionSheetModel(
                  key: "Print",
                  title: FlutterI18n.translate(context, 'Print'),
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Email",
                  title: FlutterI18n.translate(context, 'Email'),
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Remove",
                  title: FlutterI18n.translate(context, 'Remove'),
                  color: Colors.red)
            ],
          );
        });
  }
}
