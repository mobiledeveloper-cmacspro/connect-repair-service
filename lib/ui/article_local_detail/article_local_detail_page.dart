import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_bloc.dart';

class ArticleLocalDetailPage extends StatefulWidget {
  final ArticleLocalModel articleLocalModel;
  final bool navigateFromDetail;
  final bool isForMail;

  ArticleLocalDetailPage(
      {Key key,
      this.articleLocalModel,
      this.navigateFromDetail = false,
      this.isForMail = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArticleLocalDetailState();
}

class _ArticleLocalDetailState
    extends StateWithBloC<ArticleLocalDetailPage, ArticleLocalDetailBloC> {
  _navBack() {
    widget.navigateFromDetail
        ? NavigationUtils.pop(context)
        : NavigationUtils.popUntilWithRoute(
            context, NavigationUtils.ArticleIdentificationPage);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXMainBarWidget(
            title: FlutterI18n.translate(context, 'Article detail'),
            onLeadingTap: () {
              _navBack();
            },
            actions: <Widget>[
              widget.isForMail
                  ? InkWell(
                      child: Container(
                        child: TXTextWidget(
                          text: FlutterI18n.translate(context, "Send"),
                          fontWeight: FontWeight.bold,
                          color: R.color.primary_color,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 5)
                            .copyWith(right: 10),
                      ),
                      onTap: () {
                        bloc.sendPdfByEmail(widget.articleLocalModel);
                      },
                    )
                  : Container()
            ],
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Image.file(
                File(widget.articleLocalModel.screenShootFilePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
