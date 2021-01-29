import 'package:repairservices/domain/project_documentation/project_documentation.dart';

abstract class IProjectDocumentationRepository{

  Future<List<ProjectDocumentationModel>> getProjects();

  Future<bool> saveProject(ProjectDocumentationModel project);

  Future<bool> deleteProject(ProjectDocumentationModel project);

}