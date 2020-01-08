import 'dart:io';

import 'package:repairservices/domain/article_local_model/i_article_local_dao.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_repository.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';

class ArticleLocalRepository implements IArticleLocalRepository {
  final IArticleLocalDao _articleLocalDao;

  ArticleLocalRepository(this._articleLocalDao);

  @override
  Future<List<ArticleLocalModel>> getArticleLocalList() async {
    final res = await _articleLocalDao.getArticleLocalList();
    return res ?? [];
  }

  @override
  Future<bool> saveArticleLocal(ArticleLocalModel model) async {
    final res = await _articleLocalDao.saveArticleLocal(model);
    return res;
  }

  @override
  Future<bool> deleteArticleLocal(ArticleLocalModel articleLocalModel) async {
    final res = await _articleLocalDao.deleteArticleLocal(articleLocalModel);
    try {
      final File imageFile = File(articleLocalModel.filePath);
      await imageFile.delete();
      final File screenShootFile = File(articleLocalModel.screenShootFilePath);
      await screenShootFile.delete();
    } catch (ex) {}
    return res;
  }
}
