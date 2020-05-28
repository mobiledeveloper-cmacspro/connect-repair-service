import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';

class ArticleLocalModel extends ArticleBase {
  String id = "";
  String displayName;
  String filePath;
  String screenShootFilePath;
  DateTime createdOnImage;
  DateTime createdOnScreenShoot;
  List<MemoNoteModel> notes;
  List<MemoAudioModel> audios;
  List<MemoVideoModel> videos;

  ArticleLocalModel(
      {this.id = "",
      this.displayName = "Picture 1",
      this.filePath = "",
      this.screenShootFilePath,
      this.createdOnImage,
      this.createdOnScreenShoot,
      this.audios,
      this.notes,
      this.videos});
}
