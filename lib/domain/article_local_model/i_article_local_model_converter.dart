import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';

abstract class IArticleLocalModelConverter {
  ArticleLocalModel fromJson(Map<String, dynamic> json);

  MemoNoteModel fromJsonNote(Map<String, dynamic> json);

  MemoAudioModel fromJsonAudio(Map<String, dynamic> json);

  MemoVideoModel fromJsonVideo(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ArticleLocalModel model);

  Map<String, dynamic> toJsonNote(MemoNoteModel model);

  Map<String, dynamic> toJsonAudio(MemoAudioModel model);

  Map<String, dynamic> toJsonVideo(MemoVideoModel model);
}
