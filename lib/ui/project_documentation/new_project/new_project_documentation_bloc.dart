import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:repairservices/utils/extensions.dart';

class NewProjectDocumentationBloC implements BaseBloC {
  final IProjectDocumentationRepository _repository;

  NewProjectDocumentationBloC(this._repository);

  BehaviorSubject<bool> _controller = BehaviorSubject();

  Stream<bool> get stream => _controller.stream;

  void save(ProjectDocumentationModel project) async {
    try {
      project.date = DateTime.now();
      final result = await _repository.saveProject(project);
      _controller.sinkAddSafe(result);
    } catch (ex) {
      print(ex);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
