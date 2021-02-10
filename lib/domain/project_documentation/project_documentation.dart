import 'package:repairservices/domain/article_base.dart';

class ProjectDocumentationModel extends ArticleBase {
  String id;
  String name;
  String number;
  String abbreviation;
  String address;
  String participants;
  String totalCosts;
  String urlPhoto;
  String category;
  String info;
  DateTime date;

  ProjectDocumentationModel({
    this.id,
    this.name,
    this.abbreviation,
    this.address,
    this.category,
    this.info,
    this.number,
    this.participants,
    this.totalCosts,
    this.urlPhoto,
    this.date,
  });
}
