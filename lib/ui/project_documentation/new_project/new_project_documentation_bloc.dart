import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_form_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:repairservices/utils/extensions.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class NewProjectDocumentationBloC extends BaseBloC with FormValidatorBloC {
  final IProjectDocumentationRepository _repository;

  NewProjectDocumentationBloC(this._repository);

  @override
  void dispose() {
    _controller.close();
    _projectController.close();
  }

  BehaviorSubject<bool> _controller = BehaviorSubject();

  Stream<bool> get stream => _controller.stream;

  BehaviorSubject<ProjectDocumentModel> _projectController = BehaviorSubject();

  Stream<ProjectDocumentModel> get projectResult => _projectController.stream;

  ProjectDocumentModel projectDocumentModel;

  get refreshData => _projectController.sinkAddSafe(projectDocumentModel);

  void init(ProjectDocumentModel initModel) {
    projectDocumentModel = initModel ??
        ProjectDocumentModel(
            reports: [], address: ProjectDocumentAddressModel());
    projectDocumentModel.isEditing = initModel == null;
    _projectController.sinkAddSafe(projectDocumentModel);
  }

  void save() async {
    try {
      projectDocumentModel.date = DateTime.now();
      if (projectDocumentModel.id.isNullOrEmpty())
        projectDocumentModel.id = Uuid().v1();

      final result =
          await _repository.saveProjectDocument(projectDocumentModel);
      _controller.sinkAddSafe(result);
    } catch (ex) {
      Fluttertoast.showToast(
          msg: ex.toString(),
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
