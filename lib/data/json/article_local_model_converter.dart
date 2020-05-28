import 'package:repairservices/domain/article_local_model/i_article_local_model_converter.dart';
import 'package:repairservices/local/db_constants.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';

class ArticleLocalModelConverter implements IArticleLocalModelConverter {
  ArticleLocalModel fromJson(Map<String, dynamic> json) {
    return ArticleLocalModel(
        id: json[DBConstants.id],
        displayName: json[DBConstants.display_name],
        filePath: json[DBConstants.file_path],
        screenShootFilePath: json[DBConstants.screenshoot_file_path],
        createdOnImage: DateTime.tryParse(json[DBConstants.created_on_image]),
        notes: json.containsKey(DBConstants.notes)
            ? (json[DBConstants.notes] as List<dynamic>)
                .map((model) => fromJsonNote(model))
                .toList()
            : [],
        audios: json.containsKey(DBConstants.audios)
            ? (json[DBConstants.audios] as List<dynamic>)
                .map((model) => fromJsonAudio(model))
                .toList()
            : [],
        videos: json.containsKey(DBConstants.videos)
            ? (json[DBConstants.videos] as List<dynamic>)
                .map((model) => fromJsonVideo(model))
                .toList()
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
      DBConstants.notes: model.notes.map((model) => toJsonNote(model)).toList(),
      DBConstants.audios:
          model.audios.map((model) => toJsonAudio(model)).toList(),
      DBConstants.videos:
          model.videos.map((model) => toJsonVideo(model)).toList()
    };
  }

  @override
  MemoAudioModel fromJsonAudio(Map<String, dynamic> json) {
    final model = MemoAudioModel(filePath: json["filePath"]);
    model.id = json["id"];
    model.xPos = json["xPos"];
    model.yPos = json["yPos"];
    return model;
  }

  @override
  MemoVideoModel fromJsonVideo(Map<String, dynamic> json) {
    final model = MemoVideoModel(filePath: json["filePath"]);
    model.id = json["id"];
    model.xPos = json["xPos"];
    model.yPos = json["yPos"];
    return model;
  }

  @override
  MemoNoteModel fromJsonNote(Map<String, dynamic> json) {
    final model = MemoNoteModel(description: json["description"]);
    model.id = json["id"];
    model.xPos = json["xPos"];
    model.yPos = json["yPos"];
    return model;
  }

  @override
  Map<String, dynamic> toJsonAudio(MemoAudioModel model) {
    return {
      "id": model.id,
      "xPos": model.xPos,
      "yPos": model.yPos,
      "filePath": model.filePath
    };
  }

  @override
  Map<String, dynamic> toJsonVideo(MemoVideoModel model) {
    return {
      "id": model.id,
      "xPos": model.xPos,
      "yPos": model.yPos,
      "filePath": model.filePath
    };
  }

  @override
  Map<String, dynamic> toJsonNote(MemoNoteModel model) {
    return {
      "id": model.id,
      "xPos": model.xPos,
      "yPos": model.yPos,
      "description": model.description
    };
  }
}
