import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/ArticleWebPreview.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/domain/common_model.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/cnt_loading_fullscreen.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/ui/article_detail/article_detail_page.dart';
import 'package:repairservices/ui/article_identification/article_identification_bloc.dart';
import 'package:repairservices/ui/article_identification/article_identification_gallery_page.dart';
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
        Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Colors.white,
              actionsIconTheme:
                  IconThemeData(color: Theme.of(context).primaryColor),
              title: Text(
                  FlutterI18n.translate(context, 'Article Identification'),
                  style: Theme.of(context).textTheme.body1),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Theme.of(context).primaryColor,
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    final list = await bloc.articlesResult.first;
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              ArticleIdentificationGalleryPage(
                                articles: list,
                              )),
                    );
                  },
                  icon: Icon(Icons.image),
                ),
              ],
            ),
            body: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded(
                  child: StreamBuilder<List<ArticleBase>>(
                    stream: bloc.articlesResult,
                    initialData: [],
                    builder: (context, snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final articleBaseModel = snapshot.data[index];
                            return _getItem(articleBaseModel);
                          });
                    },
                  ),
                ),
                new Container(
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
            )),
        CNTLoadingFullScreenWithStream(
          loadingStream: bloc.showLoading,
        )
      ],
    );
  }

  Widget _getItem(ArticleBase articleBaseModel) {
    if (articleBaseModel is Fitting)
      return _getFitting(articleBaseModel);
    else
      return _getArticleLocalItem((articleBaseModel as ArticleLocalModel));
  }

  Widget _getFitting(Fitting fitting) {
    return Container(
        color: Color.fromRGBO(243, 243, 243, 1.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: ListTile(
            leading: Image.asset('assets/productImage.png'),
            title: Text(fitting.name, style: Theme.of(context).textTheme.body1),
            subtitle: Text(
                fitting.created.month.toString() +
                    "-" +
                    fitting.created.day.toString() +
                    "-" +
                    fitting.created.year.toString(),
                style: Theme.of(context).textTheme.body2),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              NavigationUtils.push(
                context,
                FittingPDFViewerPage(
                  model: fitting,
                ),
              );
            },
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
        color: Color.fromRGBO(243, 243, 243, 1.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: ListTile(
            leading: Image.asset('assets/productImage.png'),
            title: Text(articleLocalModel.displayName,
                style: Theme.of(context).textTheme.body1),
            subtitle: Text(
                CalendarUtils.showInFormat(
                    "M-d-yyyy", articleLocalModel.createdOnScreenShoot),
                style: Theme.of(context).textTheme.body2),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              NavigationUtils.pushCupertino(
                context,
                ArticleDetailPage(
                  articleLocalModel: articleLocalModel,
                ),
              );
            },
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
