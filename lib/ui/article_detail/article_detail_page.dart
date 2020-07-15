import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/article_detail/article_detail_bloc.dart';

class ArticleDetailPage extends StatefulWidget {
  final ArticleLocalModel articleLocalModel;

  const ArticleDetailPage({Key key, this.articleLocalModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArticleDetailState();
}

class _ArticleDetailState
    extends StateWithBloC<ArticleDetailPage, ArticleDetailBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(R.string.articleImage,
            style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.file(
          File(widget.articleLocalModel.screenShootFilePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
