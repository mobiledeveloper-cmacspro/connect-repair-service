import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/domain/article_base.dart';

class ArticleLocalModel extends ArticleBase {
  String id = "";
  String displayName;
  String filePath;
  String screenShootFilePath;
  DateTime createdOnImage;
  DateTime createdOnScreenShoot;
  List<String> notes;
  List<String> audiosFilePaths;
  List<String> videosFilePaths;

  ArticleLocalModel(
      {this.id = "",
      this.displayName = "Picture 1",
      this.filePath = "",
      this.screenShootFilePath,
      this.createdOnImage,
      this.createdOnScreenShoot,
      this.audiosFilePaths,
      this.notes,
      this.videosFilePaths});
}
