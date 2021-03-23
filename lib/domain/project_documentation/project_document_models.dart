import '../article_base.dart';
import 'package:repairservices/utils/extensions.dart';

class ProjectDocumentModel extends ArticleBase {
  String id;
  String name;
  DateTime date;
  int number;
  String abbreviation;
  int participants;
  double totalCost;
  String photo;
  String category;
  String info;
  ProjectDocumentAddressModel address;
  List<ProjectDocumentReportModel> reports;
  bool isEditing;
  String pdfPath;

  String get fixedName => name.isNullOrEmpty() ? "" : name;

  ProjectDocumentModel(
      {this.id,
      this.isEditing = false,
      this.date,
      this.name,
      this.pdfPath,
      this.number,
      this.abbreviation,
      this.participants,
      this.totalCost,
      this.photo,
      this.category,
      this.info,
      this.address,
      this.reports});

  ProjectDocumentModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        number = json['number'],
        abbreviation = json['abbreviation'],
        participants = json['participants'],
        totalCost = json['totalCost'],
        photo = json['photo'],
        category = json['category'],
        info = json['info'],
        address = ProjectDocumentAddressModel.fromJson(json['address']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'date': date.millisecondsSinceEpoch,
        'number': number,
        'abbreviation': abbreviation,
        'participants': participants,
        'totalCost': totalCost,
        'photo': photo,
        'category': category,
        'info': info,
        'address': address.toJson()
      };
}

class ProjectDocumentAddressModel {
  String street;
  int houseNumber;
  String extraAddressLine;
  int postCode;
  String location;

  String get addressStr =>
      "${street?.isNotEmpty == true ? "$street," : ""} ${houseNumber != null ? "$houseNumber;" : ""}${postCode != null ? " $postCode." : ""}${location?.isNotEmpty == true ? " $location." : ""}${extraAddressLine?.isNotEmpty == true ? " $extraAddressLine." : ""}";

  ProjectDocumentAddressModel(
      {this.street,
      this.houseNumber,
      this.extraAddressLine,
      this.postCode,
      this.location});

  ProjectDocumentAddressModel.fromJson(Map<String, dynamic> json)
      : street = json['street'],
        houseNumber = json['houseNumber'],
        extraAddressLine = json['extraAddressLine'],
        postCode = json['postCode'],
        location = json['location'];

  Map<String, dynamic> toJson() => {
        'street': street,
        'houseNumber': houseNumber,
        'extraAddressLine': extraAddressLine,
        'postCode': postCode,
        'location': location,
      };
}

class ProjectDocumentReportModel {
  String id;
  String projectId;
  String category;
  DateTime date;
  DateTime begin;
  DateTime end;
  String shortInfo;
  String photo;
  String measurementCamera;
  String video;
  String voiceMemo;
  DocumentWeatherModel documentWeather;
  bool isEditing;

  DateTime get subTitleFixed => date != null
      ? date
      : begin != null
          ? begin
          : end != null
              ? end
              : null;

  ProjectDocumentReportModel(
      {this.id,
      this.projectId,
      this.category,
      this.isEditing,
      this.date,
      this.begin,
      this.end,
      this.shortInfo,
      this.photo,
      this.measurementCamera,
      this.video,
      this.voiceMemo,
      this.documentWeather});

  ProjectDocumentReportModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        projectId = json['projectId'],
        category = json['category'],
        date = json['date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['date'])
            : null,
        begin = json['begin'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['begin'])
            : null,
        end = json['end'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['end'])
            : null,
        shortInfo = json['shortInfo'],
        photo = json['photo'],
        measurementCamera = json['measurementCamera'],
        video = json['video'],
        voiceMemo = json['voiceMemo'],
        documentWeather = json['documentWeather'] != null
            ? DocumentWeatherModel.fromJson(json['documentWeather'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'projectId': projectId,
        'date': date?.millisecondsSinceEpoch,
        'begin': begin?.millisecondsSinceEpoch,
        'end': end?.millisecondsSinceEpoch,
        'shortInfo': shortInfo,
        'photo': photo,
        'measurementCamera': measurementCamera,
        'video': video,
        'voiceMemo': voiceMemo,
        'documentWeather': documentWeather?.toJson(),
      };
}

class DocumentWeatherModel {
  String photo;
  String recording;
  String video;
  String voiceMemo;
  double temperature;
  double generalWeather;
  double windStrength;
  bool isActive;

  DocumentWeatherModel(
      {this.photo,
      this.recording,
      this.voiceMemo,
      this.video,
      this.temperature,
      this.generalWeather,
      this.windStrength,
      this.isActive});

  DocumentWeatherModel.fromJson(Map<String, dynamic> json)
      : photo = json['photo'],
        recording = json['recording'],
        video = json['video'],
        voiceMemo = json['voiceMemo'],
        temperature = json['temperature'],
        generalWeather = json['generalWeather'],
        windStrength = json['windStrength'],
        isActive = json['isActive'];

  Map<String, dynamic> toJson() => {
        'photo': photo,
        'recording': recording,
        'video': video,
        'voiceMemo': voiceMemo,
        'temperature': temperature,
        'generalWeather': generalWeather,
        'windStrength': windStrength,
        'isActive': isActive
      };
}
