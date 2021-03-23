import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/domain/project_documentation/i_project_documentation_repository.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:repairservices/utils/mail_mananger.dart';
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
import 'package:repairservices/utils/extensions.dart';

class ProjectDocumentationBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC {
  final IProjectDocumentationRepository _iArticleLocalRepository;
  DatabaseHelper helper = DatabaseHelper.instance;

  ProjectDocumentationBloC(this._iArticleLocalRepository);

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

    final articlesLocal = await _iArticleLocalRepository.getProjectsDocuments();

    articles.addAll(articlesLocal);

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
      if (articleBase.isSelected) {
        //if (articleBase is ArticleLocalModel) {
        await _iArticleLocalRepository
            .deleteProjectDocument((articleBase as ProjectDocumentModel).id);
        /* if (articleBase.filePath.isNotEmpty) {
            final file = File(articleBase.filePath);
            if (file.existsSync()) file.deleteSync();
          }

          articleBase.audios.forEach((element) {
            if (element.filePath.isNotEmpty) {
              final file = File(element.filePath);
              if (file.existsSync()) file.deleteSync();
            }
          });

          articleBase.videos.forEach((element) {
            if (element.filePath.isNotEmpty) {
              final file = File(element.filePath);
              if (file.existsSync()) file.deleteSync();
            }
          });*/
        //}
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
    _deleteImages(fitting);
  }

  Future<void> _deleteImages(Fitting model) async {
    if (model is DoorHinge) {
      List<String> files = [
        model.dimensionSurfaceIm,
        model.dimensionBarrelIm,
      ];
      files.forEach((element) {
        File f = File(element ?? '');
        if (f.existsSync()) {
          f.deleteSync();
        }
      });
    } else if (model is DoorLock) {
      List<String> files = [
        model.dimensionImage1Path,
        model.dimensionImage2Path,
        model.dimensionImage3Path
      ];
      files.forEach((element) {
        File f = File(element ?? '');
        if (f.existsSync()) {
          f.deleteSync();
        }
      });
    }
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
    final MailModel mailModel =
        MailModel(subject: name, body: name, attachments: attachments);

    final res = await MailManager.sendEmail(mailModel);
    if (res != 'OK') {
      Fluttertoast.showToast(
          msg: "$res", toastLength: Toast.LENGTH_LONG, textColor: Colors.red);
    }
    isLoading = false;
  }

  void exportByEmail() async {
    isLoading = true;
    final name = 'export';
    final List<String> attachments = [];
    _articleLocalController.value.forEach((articleBase) async {
      if (articleBase.isSelected) {
        attachments.add(articleBase is ArticleLocalModel
            ? articleBase.filePath
            : (articleBase is ProjectDocumentModel) ? articleBase.pdfPath : (articleBase as Fitting).pdfPath);
      }
    });

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
