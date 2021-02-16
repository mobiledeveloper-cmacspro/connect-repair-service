import 'package:repairservices/domain/project_documentation/i_project_documentation_dao.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';

class ProjectDocumentationRepository
    implements IProjectDocumentationRepository {
  final IProjectDocumentationDao _dao;

  ProjectDocumentationRepository(this._dao);

  @override
  Future<bool> deleteProject(ProjectDocumentationModel project) async {
    try {
      return await _dao.deleteProject(project);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<List<ProjectDocumentationModel>> getProjects() async {
    try {
      return await _dao.getProjects();
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<bool> saveProject(ProjectDocumentationModel project) async {
    try {
      return await _dao.saveProject(project);
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<bool> deleteProjectDocument(String id) async {
    try {
      return await _dao.deleteProjectDocument(id);
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> deleteProjectDocumentReport(String id) async {
    try {
      return await _dao.deleteProjectDocumentReport(id);
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<List<ProjectDocumentReportModel>> getProjectDocumentReports() async {
    try {
      return await _dao.getProjectDocumentReports();
    } catch (ex) {
      return [];
    }
  }

  @override
  Future<List<ProjectDocumentModel>> getProjectsDocuments() async {
    try {
      return await _dao.getProjectsDocuments();
    } catch (ex) {
      return [];
    }
  }

  @override
  Future<bool> saveProjectDocument(ProjectDocumentModel project) async {
    try {
      return await _dao.saveProjectDocument(project);
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> saveProjectDocumentReport(
      ProjectDocumentReportModel report) async {
    try {
      return await _dao.saveProjectDocumentReport(report);
    } catch (ex) {
      return false;
    }
  }
}
