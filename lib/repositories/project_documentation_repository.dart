import 'package:repairservices/domain/project_documentation/i_project_documentation_dao.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';

class ProjectDocumentationRepository
    implements IProjectDocumentationRepository {
  final IProjectDocumentationDao _dao;

  ProjectDocumentationRepository(this._dao);

  @override
  Future<bool> deleteProject(ProjectDocumentationModel project) {
    // TODO: implement deleteProject
    throw UnimplementedError();
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
}
