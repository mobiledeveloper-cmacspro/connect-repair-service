import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';

class ProjectReportBloC extends BaseBloC {
  final IProjectDocumentationRepository _documentationRepository;

  ProjectReportBloC(this._documentationRepository);

  @override
  void dispose() {
    // TODO: implement dispose
  }


}
