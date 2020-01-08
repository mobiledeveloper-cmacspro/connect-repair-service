import 'dart:convert';

import 'package:repairservices/domain/article_local_model/i_article_local_dao.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_model_converter.dart';
import 'package:repairservices/local/app_database.dart';
import 'package:repairservices/local/db_constants.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ArticleLocalDao implements IArticleLocalDao {
  final AppDatabase _appDatabase;
  final IArticleLocalModelConverter _articleLocalModelConverter;

  ArticleLocalDao(this._appDatabase, this._articleLocalModelConverter);

  @override
  Future<List<ArticleLocalModel>> getArticleLocalList() async {
    final List<ArticleLocalModel> list = [];
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(
        DBConstants.article_image__table,
      );
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final ArticleLocalModel obj =
            _articleLocalModelConverter.fromJson(json.decode(value));
        list.add(obj);
      });
      return list;
    } catch (ex) {
      return [];
    }
  }

  @override
  Future<bool> saveArticleLocal(ArticleLocalModel model) async {
    try {
      Database db = await _appDatabase.db;
      final map = {
        DBConstants.id_key: model.id,
        DBConstants.data_key:
            json.encode(_articleLocalModelConverter.toJson(model)),
        DBConstants.parent_key: DBConstants.parent_key,
      };
      await db.insert(DBConstants.article_image__table, map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> deleteArticleLocal(ArticleLocalModel model) async {
    try {
      Database db = await _appDatabase.db;
      final delRows = await db.delete(DBConstants.article_image__table,
          where: '${DBConstants.id_key} = ?', whereArgs: [model.id]);
      return delRows > 0;
    } catch (ex) {
      return false;
    }
  }
}
