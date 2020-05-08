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
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/cnt_loading_fullscreen.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_loading_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/ui/article_detail/article_detail_page.dart';
import 'package:repairservices/ui/article_identification/article_identification_bloc.dart';
import 'package:repairservices/ui/article_identification/article_identification_gallery_page.dart';
import 'package:repairservices/ui/fitting_windows/fitting_windows_detail.dart';
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
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Fitting> articleList;
  int selected = 0;
  bool selecting = false;

  _sendPdfByEmail(String name, String pdfPath) async {
    final MailOptions mailOptions = MailOptions(
      body: 'Article fitting',
      subject: name,
      recipients: ['lepuchenavarro@gmail.com'],
      isHTML: true,
//      bccRecipients: ['other@example.com'],
//      ccRecipients: ['third@example.com'],
      attachments: [pdfPath],
    );

    await FlutterMailer.send(mailOptions);
  }

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
        TXMainBarWidget(
          title: FlutterI18n.translate(context, 'Article Identification'),
          onLeadingTap: () {
            Navigator.pop(context);
          },
          actions: <Widget>[
            TXIconButtonWidget(
              onPressed: () async {
                final list = await bloc.articlesResult.first;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ArticleIdentificationGalleryPage(
                            articles: list,
                          )),
                );
              },
              icon: Icon(
                Icons.image,
                color: R.color.primary_color,
                size: 30,
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
                          return _getItem(context, articleBaseModel);
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
                            child: new Image.asset('assets/gearWhite.png'),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => IdentificationTypeV()),
                        ).then((_) {
                          bloc.loadArticles();
                        });
                      },
                    ),
                    new InkWell(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: new Image.asset('assets/exportWhite.png'),
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
                      onTap: () {
                        if (!selecting) {
                          setState(() {
                            selecting = true;
                          });
                        } else if (selected != 0) {
                          _onActionSheetPress(context);
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  Widget _getItem(BuildContext context, ArticleBase articleBaseModel) {
    if (articleBaseModel is Fitting)
      return _getFitting(context, articleBaseModel);
    else
      return _getArticleLocalItem((articleBaseModel as ArticleLocalModel));
  }

  Widget _getFitting(BuildContext context, Fitting fitting) {
    return Container(
        color: R.color.gray_light,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: Column(
            children: <Widget>[
              TXItemCellEditWidget(
                cellEditMode: CellEditMode.selector,
                title: fitting.name,
                value:
                    CalendarUtils.showInFormat("dd/MM/YYYY", fitting.created),
                leading: Image.asset(
                  'assets/productImage.png',
                  height: 40,
                  width: 50,
                ),
                onSubmitted: (value) async {
                  if (fitting is Windows) {
                    final res = await NavigationUtils.push(
                      context,
                      FittingWindowsDetail(
                        model: fitting,
                        typeFitting: fitting.systemDepth?.isNotEmpty == true
                            ? TypeFitting.windows
                            : TypeFitting.sunShading,
                      ),
                    );
                    bloc.loadArticles();
                  } else {
                    NavigationUtils.push(
                      context,
                      FittingPDFViewerPage(
                        model: fitting,
                      ),
                    );
                  }
                },
              ),
              TXDividerWidget()
            ],
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'E-mail',
              foregroundColor: Colors.white,
              color: Theme.of(context).primaryColor,
              icon: CupertinoIcons.mail,
              onTap: () {
                bloc.sendPdfByEmail(fitting);
//                _sendPdfByEmail(fitting.name, fitting.pdfPath);
              },
            ),
            IconSlideAction(
              caption: FlutterI18n.translate(context, 'Delete'),
              color: Colors.red,
              icon: CupertinoIcons.delete,
              onTap: () {
                bloc.deleteArticle(fitting);
              },
            ),
          ],
        ));
  }

  Widget _getArticleLocalItem(ArticleLocalModel articleLocalModel) {
    return Container(
        color: R.color.gray_light,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: Column(
            children: <Widget>[
              TXItemCellEditWidget(
                cellEditMode: CellEditMode.selector,
                title: articleLocalModel.displayName,
                value: CalendarUtils.showInFormat(
                    "dd/MM/YYYY", articleLocalModel.createdOnScreenShoot),
                leading: Image.asset(
                  'assets/productImage.png',
                  height: 40,
                  width: 50,
                ),
                onSubmitted: (value) async {
                  NavigationUtils.push(
                    context,
                    ArticleDetailPage(
                      articleLocalModel: articleLocalModel,
                    ),
                  );
                },
              ),
              TXDividerWidget()
            ],
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'E-mail',
              foregroundColor: Colors.white,
              color: Theme.of(context).primaryColor,
              icon: CupertinoIcons.mail,
              onTap: () {
//                Future.delayed(
//                    Duration(milliseconds: 500), () {
//                  _sendPdfByEmail(
//                      articleList[index].name,
//                      articleList[index].pdfPath);
//                });
              },
            ),
            IconSlideAction(
              caption: FlutterI18n.translate(context, 'Delete'),
              color: Colors.red,
              icon: CupertinoIcons.delete,
              onTap: () {
                bloc.deleteArticle(articleLocalModel);
              },
            ),
          ],
        ));
  }
}
