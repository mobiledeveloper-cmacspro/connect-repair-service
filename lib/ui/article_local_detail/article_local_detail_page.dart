import 'dart:io';

import 'package:flutter/material.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_bloc.dart';

class ArticleLocalDetailPage extends StatefulWidget {
  final String filePath;

  const ArticleLocalDetailPage({Key key, this.filePath = ""}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArticleLocalDetailState();
}

class _ArticleLocalDetailState
    extends StateWithBloC<ArticleLocalDetailPage, ArticleLocalDetailBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text("Edit Picture", style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Container(
        height: 200,
        width: 100,
        child: Image.file(File(widget.filePath)),
      ),
    );
  }
}
