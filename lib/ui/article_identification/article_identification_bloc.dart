import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/Utils/mail_mananger.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_repository.dart';
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

class ArticleIdentificationBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC {
  final IArticleLocalRepository _iArticleLocalRepository;
  DatabaseHelper helper = DatabaseHelper.instance;

  ArticleIdentificationBloC(this._iArticleLocalRepository);

  BehaviorSubject<List<ArticleBase>> _articleLocalController =
      new BehaviorSubject();

  Stream<List<ArticleBase>> get articlesResult =>
      _articleLocalController.stream;

  BehaviorSubject<bool> _selectionModeController = new BehaviorSubject();

  Stream<bool> get selectionModeResult => _selectionModeController.stream;

  bool isInSelectionMode = false;

  set setSelectionMode(bool mode) {
    isInSelectionMode = mode;
    _selectionModeController.sinkAddSafe(isInSelectionMode);
  }

  void loadArticles() async {
    isLoading = true;
    List<ArticleBase> sortedList = [];
    List<ArticleBase> articles = [];
    List<Fitting> fittingList = [];
    final articleWindows = await helper.queryAllWindows();
    for (Windows windows in articleWindows) {
      fittingList.add(windows);
    }
    final articleDoorLock = await helper.queryAllDoorLock();
    for (DoorLock doorLock in articleDoorLock) {
      fittingList.add(doorLock);
    }
    final articleDoorHinge = await helper.queryAllDoorHinge();
    for (DoorHinge doorHinge in articleDoorHinge) {
      fittingList.add(doorHinge);
    }
    final articleSliding = await helper.queryAllSliding();
    for (Sliding sliding in articleSliding) {
      fittingList.add(sliding);
    }
    fittingList.sort((a, b) => b.created.compareTo(a.created));

    final articlesLocal = await _iArticleLocalRepository.getArticleLocalList();

    articles.addAll(fittingList);
    articles.addAll(articlesLocal);

    articles.sort((a, b) => (a is Fitting
            ? a.created
            : (a as ArticleLocalModel).createdOnScreenShoot)
        .compareTo(b is Fitting
            ? b.created
            : (b as ArticleLocalModel).createdOnScreenShoot));
    _articleLocalController.sinkAddSafe(articles.reversed.toList());

    articles.forEach((a) => a.isSelected = false);
    setSelectionMode = false;
    isLoading = false;
  }

  void refreshList() async {
    List<ArticleBase> articleBaseList = (await articlesResult.first);
    final ArticleBase article =
        articleBaseList.firstWhere((a) => a.isSelected, orElse: () {
      return null;
    });
    if (article == null) setSelectionMode = false;

    _articleLocalController.sinkAddSafe(articleBaseList);
  }

  void deleteArticle() async {
    List<ArticleBase> articleBaseList = await articlesResult.first;
    await Future.forEach(articleBaseList, (articleBase) async {
      if(articleBase.isSelected){
        if (articleBase is ArticleLocalModel)
          await _iArticleLocalRepository.deleteArticleLocal(articleBase);
        else
          await _deleteArticleFitting((articleBase as Fitting));
      }
    });
    articleBaseList.removeWhere((a) => a.isSelected);

    refreshList();
  }

  Future<void> _deleteArticleFitting(Fitting fitting) async {
    if (fitting is Windows) {
      await helper.deleteWindows(fitting.id);
      await PDFManagerWindow.removePDF(fitting);
    } else if (fitting is Sliding) {
      await helper.deleteSliding(fitting.id);
      await PDFManagerSliding.removePDF(fitting);
    } else if (fitting is DoorLock) {
      await helper.deleteDoorLock(fitting.id);
      await PDFManagerDoorLock.removePDF(fitting);
    } else if (fitting is DoorHinge) {
      await helper.deleteDoorHinge(fitting.id);
      await PDFManagerDoorHinge.removePDF(fitting);
    }
  }

  void sendPdfByEmail(ArticleBase articleBase) async {
    isLoading = true;
    final name = (articleBase is Fitting)
        ? articleBase.name
        : (articleBase as ArticleLocalModel).displayName;
    final List<String> attachments = [
      articleBase is ArticleLocalModel
          ? articleBase.filePath
          : (articleBase as Fitting).pdfPath
    ];
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
    _selectionModeController.close();
    _articleLocalController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
