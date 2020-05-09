import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/Utils/mail_mananger.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/0_base/bloc_error_handler.dart';
import 'package:repairservices/ui/0_base/bloc_loading.dart';

class ArticleLocalDetailBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC {

  void sendPdfByEmail(ArticleLocalModel articleLocalModel) async {
    isLoading = true;
    final name = articleLocalModel.displayName;
    final List<String> attachments = [articleLocalModel.screenShootFilePath];

    final MailModel mailModel =
        MailModel(subject: name, body: name, attachments: attachments);

    final res = await MailManager.sendEmail(mailModel);
    if (res != 'OK') {
      Fluttertoast.showToast(
          msg: "$res", toastLength: Toast.LENGTH_LONG, textColor: Colors.red);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
