import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:repairservices/utils/extensions.dart';

class ProjectReportBloC extends BaseBloC {
  final IProjectDocumentationRepository _documentationRepository;

  ProjectReportBloC(this._documentationRepository);

  @override
  void dispose() {
    _projectReportController.close();
  }

  ProjectDocumentModel projectDocumentModel;

  BehaviorSubject<List<ProjectDocumentReportModel>> _projectReportController =
      new BehaviorSubject();

  Stream<List<ProjectDocumentReportModel>> get projectReportResult =>
      _projectReportController.stream;

  void loadProjectReports(String projectId) async {
    if (projectId.isNullOrEmpty())
      _projectReportController.sinkAddSafe(projectDocumentModel.reports ?? []);
    else {
      final res =
          await _documentationRepository.getProjectDocumentReports(projectId);
      _projectReportController.sinkAddSafe(res);
    }
  }

  void deleteReport(String projectId, String reportId) async {
    final res =
        await _documentationRepository.deleteProjectDocumentReport(reportId);
    projectDocumentModel.reports
        .removeWhere((element) => element.id == reportId);
    loadProjectReports(projectId);
  }

  void updateReport(ProjectDocumentReportModel report) async {
    final res =
        await _documentationRepository.saveProjectDocumentReport(report);
    final index = projectDocumentModel.reports
        .indexWhere((element) => report.id == element.id);
    if (index >= 0) projectDocumentModel.reports.removeAt(index);
    projectDocumentModel.reports.add(report);
    loadProjectReports(report.projectId);
  }
}
