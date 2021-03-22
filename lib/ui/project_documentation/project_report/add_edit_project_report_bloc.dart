import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:repairservices/utils/extensions.dart';
import 'package:uuid/uuid.dart';

class AddEditProjectReportBloC extends BaseBloC {
  final IProjectDocumentationRepository _documentationRepository;

  AddEditProjectReportBloC(this._documentationRepository);

  @override
  void dispose() {
    _controller.close();
    _projectReportController.close();
    _controllerWeather.close();
  }

  BehaviorSubject<bool> _controller = BehaviorSubject();

  Stream<bool> get stream => _controller.stream;

  BehaviorSubject<bool> _controllerWeather = BehaviorSubject();

  Stream<bool> get streamWeather => _controllerWeather.stream;

  BehaviorSubject<ProjectDocumentReportModel> _projectReportController =
  BehaviorSubject();

  Stream<ProjectDocumentReportModel> get projectReportResult =>
      _projectReportController.stream;

  get refreshData =>
      _projectReportController.sinkAddSafe(projectDocumentReportModel);

  ProjectDocumentReportModel projectDocumentReportModel;
  DateTime currentDate = DateTime.now();
  DateTime beginDate = DateTime.now();
  DateTime endDate = DateTime.now();
  ProjectDocumentModel projectDocumentModel;

  void init(ProjectDocumentReportModel initModel) {
    projectDocumentModel.reports = projectDocumentModel.reports ?? [];
    projectDocumentReportModel = initModel ??
        ProjectDocumentReportModel(isEditing: false,
            date: DateTime.now(),
            documentWeather: DocumentWeatherModel(
                isActive: false,
                temperature: 0,
                windStrength: -1,
                generalWeather: 1,
            ));
    projectDocumentReportModel.isEditing = initModel == null;
    projectDocumentReportModel.projectId = projectDocumentModel.id;
    refreshData;
  }

  void saveProjectReport() async {
    try {
      if (projectDocumentReportModel.id.isNullOrEmpty())
        projectDocumentReportModel.id = Uuid().v1();
      if (!projectDocumentReportModel.projectId.isNullOrEmpty())
        await _documentationRepository
            .saveProjectDocumentReport(projectDocumentReportModel);

      final index = projectDocumentModel.reports?.indexWhere(
              (element) => projectDocumentReportModel.id == element.id);
      if (index >= 0) projectDocumentModel.reports.removeAt(index);
      projectDocumentModel.reports.add(projectDocumentReportModel);

      _controller.sinkAddSafe(true);
    } catch (ex) {
      Fluttertoast.showToast(
          msg: ex.toString(),
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
