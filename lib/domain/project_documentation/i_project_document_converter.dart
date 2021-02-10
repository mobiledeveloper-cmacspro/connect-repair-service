import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/domain/project_documentation/project_report.dart';

abstract class IProjectDocumentConverter {
  ProjectDocumentationModel fromJson(Map<String, dynamic> json);

  ProjectReportModel projectReportFromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ProjectDocumentationModel project);

  Map<String, dynamic> projectReportToJson(ProjectReportModel report);
}
