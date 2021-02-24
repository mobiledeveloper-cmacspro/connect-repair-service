import 'dart:convert';

import 'package:repairservices/domain/project_documentation/i_project_document_converter.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_dao.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/local/app_database.dart';
import 'package:repairservices/local/db_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDocumentationLocalDao implements IProjectDocumentationDao {
  final IProjectDocumentConverter _converter;
  final AppDatabase _appDatabase;

  ProjectDocumentationLocalDao(this._converter, this._appDatabase);

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

  @override
  Future<bool> deleteProjectDocument(String id) async {
    try {
      Database db = await _appDatabase.db;
      final delRows = await db.delete(DBConstants.project_document_table,
          where: '${DBConstants.id_key} = ?', whereArgs: [id]);
      if (delRows > 0) {
        final reportsDeleted = await db.delete(DBConstants.project_document_report_table,
            where: '${DBConstants.parent_key} = ?', whereArgs: [id]);
        print(reportsDeleted.toString());
      }
      return delRows > 0;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> deleteProjectDocumentReport(String id) async {
    try {
      Database db = await _appDatabase.db;
      final delRows = await db.delete(DBConstants.project_document_report_table,
          where: '${DBConstants.id_key} = ?', whereArgs: [id]);
      return delRows > 0;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<List<ProjectDocumentReportModel>> getProjectDocumentReports(
      String projectId) async {
    final List<ProjectDocumentReportModel> list = [];
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(DBConstants.project_document_report_table,
          where: '${DBConstants.parent_key} = ?', whereArgs: [projectId]);
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final ProjectDocumentReportModel obj =
            ProjectDocumentReportModel.fromJson(json.decode(value));
        list.add(obj);
      });
      return list;
    } catch (ex) {
      return [];
    }
  }

  @override
  Future<List<ProjectDocumentModel>> getProjectsDocuments() async {
    List<ProjectDocumentModel> list = [];
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(
        DBConstants.project_document_table,
      );
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final ProjectDocumentModel obj =
            ProjectDocumentModel.fromJson(json.decode(value));
        list.add(obj);
      });
      return list;
    } catch (ex) {
      return [];
    }
  }

  @override
  Future<bool> saveProjectDocument(ProjectDocumentModel project) async {
    try {
      Database db = await _appDatabase.db;
      final map = {
        DBConstants.id_key: project.id,
        DBConstants.data_key: json.encode(project.toJson()),
        DBConstants.parent_key: DBConstants.parent_key,
      };
      await db.insert(DBConstants.project_document_table, map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      final delRows = await db.delete(DBConstants.project_document_report_table,
          where: '${DBConstants.parent_key} = ?', whereArgs: [project.id]);

      await Future.forEach<ProjectDocumentReportModel>(project.reports ?? [],
          (report) async {
        await saveProjectDocumentReport(report);
      });

      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> saveProjectDocumentReport(
      ProjectDocumentReportModel report) async {
    try {
      Database db = await (_appDatabase.db);
      final map = {
        DBConstants.id_key: report.id,
        DBConstants.data_key: json.encode(report.toJson()),
        DBConstants.parent_key: report.projectId,
      };
      await db.insert(DBConstants.project_document_report_table, map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return true;
    } catch (ex) {
      return false;
    }
  }
}
