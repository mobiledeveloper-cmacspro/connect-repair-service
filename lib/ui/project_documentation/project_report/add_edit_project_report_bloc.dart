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
  }

  BehaviorSubject<bool> _controller = BehaviorSubject();

  Stream<bool> get stream => _controller.stream;

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

  void init(ProjectDocumentReportModel initModel) {
    projectDocumentReportModel =
        initModel ?? ProjectDocumentReportModel(isEditing: false);
    projectDocumentReportModel.isEditing = initModel == null;
    _projectReportController.sinkAddSafe(projectDocumentReportModel);
  }

  void saveProjectReport() async {
    try{
      if(projectDocumentReportModel.id.isNullOrEmpty())
        projectDocumentReportModel.id = Uuid().v1();
      if(!projectDocumentReportModel.projectId.isNullOrEmpty())
        _documentationRepository.saveProjectDocumentReport(projectDocumentReportModel);

    }catch(ex){
      Fluttertoast.showToast(
          msg: ex.toString(),
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
