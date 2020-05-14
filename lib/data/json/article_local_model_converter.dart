import 'package:repairservices/domain/article_local_model/i_article_local_model_converter.dart';
import 'package:repairservices/local/db_constants.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';

class ArticleLocalModelConverter implements IArticleLocalModelConverter {
  ArticleLocalModel fromJson(Map<String, dynamic> json) {
    return ArticleLocalModel(
        id: json[DBConstants.id],
        displayName: json[DBConstants.display_name],
        filePath: json[DBConstants.file_path],
        screenShootFilePath: json[DBConstants.screenshoot_file_path],
        createdOnImage: DateTime.tryParse(json[DBConstants.created_on_image]),
        notes: json.containsKey(DBConstants.notes)
            ? List<String>.from(json[DBConstants.notes])
            : [],
        audiosFilePaths: json.containsKey(DBConstants.audios)
            ? List<String>.from(json[DBConstants.notes])
            : [],
        videosFilePaths: json.containsKey(DBConstants.videos)
            ? List<String>.from(json[DBConstants.notes])
            : [],
        createdOnScreenShoot:
            DateTime.tryParse(json[DBConstants.created_on_screen_shoot]));
  }

  Map<String, dynamic> toJson(ArticleLocalModel model) {
    return {
      DBConstants.id: model.id,
      DBConstants.display_name: model.displayName,
      DBConstants.file_path: model.filePath,
      DBConstants.screenshoot_file_path: model.screenShootFilePath,
      DBConstants.created_on_image: model.createdOnImage.toIso8601String(),
      DBConstants.created_on_screen_shoot:
          model.createdOnScreenShoot.toIso8601String(),
      DBConstants.notes: model.notes.map((n) => n).toList(),
      DBConstants.audios: model.audiosFilePaths.map((n) => n).toList(),
      DBConstants.videos: model.videosFilePaths.map((n) => n).toList()
    };
  }
}
