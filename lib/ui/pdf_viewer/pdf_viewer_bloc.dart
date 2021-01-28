import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/Utils/mail_mananger.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_hinge.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_door_lock.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_sliding.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:rxdart/subjects.dart';
import 'package:repairservices/Utils/extensions.dart';

class PDFViewerBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<String> _pdfPathController = new BehaviorSubject();

  Stream<String> get pdfPathResult => _pdfPathController.stream;

  BehaviorSubject<MailModel> _sendEmailController = new BehaviorSubject();

  Stream<MailModel> get sendEmailResult => _sendEmailController.stream;

  void loadPDF(Fitting model) async {
    isLoading = true;
    String path = '';
    if (model is Windows)
      path = await PDFManagerWindow.getPDFPath(model);
    else if (model is Sliding)
      path = await PDFManagerSliding.getPDFPath(model);
    else if (model is DoorLock)
      path = await PDFManagerDoorLock.getPDFPath(model);
    else if (model is DoorHinge)
      path = await PDFManagerDoorHinge.getPDFPath(model);
    _pdfPathController.sinkAddSafe(path);
    isLoading = false;
  }

  void sendPdfByEmail(ArticleBase articleBase) async {
    isLoading = true;
    final name = (articleBase is Fitting)
        ? articleBase.getNamei18N
        : (articleBase as ArticleLocalModel).displayName;
    final List<String> attachments = [
      articleBase is ArticleLocalModel
          ? articleBase.filePath
          : (articleBase as Fitting).pdfPath
    ];
    final MailModel mailModel = MailModel(recipients: [
      // name.contains(R.string.otherFitting)
      //     ? "ersatzteile@schueco.com"
      //     : "connect-app@schueco.com"
      R.string.receivingMailAddressArticleIdentification
    ], subject: name, body: name, attachments: attachments);

//    _sendEmailController.sinkAddSafe(mailModel);

      final res = await MailManager.sendEmail(mailModel);
    if (res != 'OK') {
      Fluttertoast.showToast(
          msg: "$res", toastLength: Toast.LENGTH_LONG, textColor: Colors.red);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _pdfPathController.close();
    _sendEmailController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
