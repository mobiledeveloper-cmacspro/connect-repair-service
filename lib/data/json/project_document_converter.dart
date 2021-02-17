import 'package:repairservices/domain/project_documentation/i_project_document_converter.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';

class ProjectDocumentationConverter implements IProjectDocumentConverter {
  @override
  ProjectDocumentationModel fromJson(Map<String, dynamic> json) =>
      ProjectDocumentationModel(
          id: json['id'],
          totalCosts: json['totalCosts'],
          participants: json['participants'],
          number: json['number'],
          info: json['info'],
          category: json['category'],
          address: json['address'],
          abbreviation: json['abbreviation'],
          name: json['name'],
          urlPhoto: json['urlPhoto'],
          date: json['date'] != null ? DateTime.tryParse(json['date']) : null);


  @override
  Map<String, dynamic> toJson(ProjectDocumentationModel project) => {
        'id': project.id,
        'totalCosts': project.totalCosts,
        'participants': project.participants,
        'number': project.number,
        'info': project.info,
        'category': project.category,
        'address': project.address,
        'abbreviation': project.abbreviation,
        'name': project.name,
        'urlPhoto': project.urlPhoto,
        'date': project.date.toIso8601String()
      };
}
