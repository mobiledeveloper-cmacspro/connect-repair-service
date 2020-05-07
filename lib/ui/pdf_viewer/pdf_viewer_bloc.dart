import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_sliding.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:rxdart/subjects.dart';
import 'package:repairservices/Utils/extensions.dart';

class PDFViewerBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<String> _pdfPathController = new BehaviorSubject();

  Stream<String> get pdfPathResult => _pdfPathController.stream;

  void loadPDF(Fitting model) async {
    isLoading = true;
    String path = '';
    if (model is Windows)
      path = await PDFManagerWindow.getPDFPath(model);
    else if (model is Sliding) path = await PDFManagerSliding.getPDFPath(model);
    _pdfPathController.sinkAddSafe(path);
    isLoading = false;
  }

  @override
  void dispose() {
    _pdfPathController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
