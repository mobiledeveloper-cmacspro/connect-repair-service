import 'package:repairservices/domain/article_local_model/article_local_model.dart';

abstract class IArticleLocalModelConverter {
  ArticleLocalModel fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(ArticleLocalModel model);
}