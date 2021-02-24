import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';

abstract class IProjectDocumentationRepository{

  Future<List<ProjectDocumentationModel>> getProjects();

  Future<bool> saveProject(ProjectDocumentationModel project);

  Future<bool> deleteProject(ProjectDocumentationModel project);


  Future<List<ProjectDocumentModel>> getProjectsDocuments();

  Future<bool> saveProjectDocument(ProjectDocumentModel project);

  Future<bool> deleteProjectDocument(String id);

  Future<List<ProjectDocumentReportModel>> getProjectDocumentReports(String projectId);

  Future<bool> saveProjectDocumentReport(ProjectDocumentReportModel report);

  Future<bool> deleteProjectDocumentReport(String id);
}