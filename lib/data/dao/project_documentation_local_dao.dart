import 'dart:convert';

import 'package:repairservices/domain/project_documentation/i_project_document_converter.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_dao.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDocumentationLocalDao implements IProjectDocumentationDao {
  final IProjectDocumentConverter _converter;

  ProjectDocumentationLocalDao(this._converter);

  @override
  Future<bool> deleteProject(ProjectDocumentationModel project) async {
    try {
      var list = await getProjects();
      list.removeWhere((element) => element.id.compareTo(project.id) == 0);
      return (await SharedPreferences.getInstance())
          .setStringList('projects_documentation', _fromProjects(list));
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<List<ProjectDocumentationModel>> getProjects() async {
    try {
      var result = (await SharedPreferences.getInstance())
          .getStringList('projects_documentation');
      if (result != null) return _fromStrings(result);

      return List<ProjectDocumentationModel>();
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future<bool> saveProject(ProjectDocumentationModel project) async {
    try {
      var list = await getProjects();
      int index = project.id != null
          ? list.indexWhere((element) => element.id.compareTo(project.id) == 0)
          : -1;
      if (index != -1) {
        list[index].info = project.info;
        list[index].category = project.category;
        list[index].totalCosts = project.totalCosts;
        list[index].participants = project.participants;
        list[index].address = project.address;
        list[index].abbreviation = project.abbreviation;
        list[index].number = project.number;
        list[index].name = project.name;
        list[index].date = project.date;
        list[index].urlPhoto = project.urlPhoto;
      } else {
        project.id = DateTime.now().toIso8601String();
        list.add(project);
      }
      return (await SharedPreferences.getInstance())
          .setStringList('projects_documentation', _fromProjects(list));
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  List<ProjectDocumentationModel> _fromStrings(List<String> projects) {
    List<ProjectDocumentationModel> list = [];
    projects.forEach((element) {
      list.add(_converter.fromJson(json.decode(element)));
    });
    return list;
  }

  List<String> _fromProjects(List<ProjectDocumentationModel> projects) {
    List<String> list = [];
    projects.forEach((element) {
      list.add(json.encode(_converter.toJson(element)));
    });
    return list;
  }
}
