import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/article_detail/article_detail_page.dart';

class ArticleIdentificationGalleryPage extends StatelessWidget {
  final List<ArticleBase> articles;

  const ArticleIdentificationGalleryPage({Key key, this.articles = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(FlutterI18n.translate(context, 'Article Gallery'),
            style: Theme.of(context).textTheme.body1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: <Widget>[..._articlesList(context)],
      ),
    );
  }

  List<Widget> _articlesList(BuildContext context) {
    List<Widget> list = [];
    articles.forEach((a) {
      final w = a is ArticleLocalModel
          ? _getLocalArticle(context, a)
          : _getArticle(context, a);

      list.add(w);
    });
    return list;
  }

  Widget _getArticle(BuildContext context, ArticleBase article) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: Image.asset(
          'assets/doorFitting.png',
          fit: BoxFit.contain,
        ),
        onTap: () {

        },
      ),
    );
  }

  Widget _getLocalArticle(
      BuildContext context, ArticleLocalModel articleLocalModel) {
    return Container(
      child: InkWell(
        onTap: (){
          NavigationUtils.pushCupertino(
            context,
            ArticleDetailPage(
              articleLocalModel: articleLocalModel,
            ),
          );
        },
        child: Image.asset('assets/productImage.png'),
      ),
    );
  }
}
