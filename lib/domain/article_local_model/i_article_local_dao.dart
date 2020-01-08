import 'package:repairservices/domain/article_local_model/article_local_model.dart';

abstract class IArticleLocalDao {
  Future<List<ArticleLocalModel>> getArticleLocalList();

  Future<bool> saveArticleLocal(ArticleLocalModel model);

  Future<bool> deleteArticleLocal(ArticleLocalModel model);
}
