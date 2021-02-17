import 'package:repairservices/domain/project_documentation/project_documentation.dart';

abstract class IProjectDocumentConverter {
  ProjectDocumentationModel fromJson(Map<String, dynamic> json);


  Map<String, dynamic> toJson(ProjectDocumentationModel project);

}
