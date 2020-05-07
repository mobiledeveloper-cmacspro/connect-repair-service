import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_repository.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:rxdart/subjects.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as im;

class ArticleIdentificationBloC extends BaseBloC {
  final IArticleLocalRepository _iArticleLocalRepository;
  DatabaseHelper helper = DatabaseHelper.instance;

  ArticleIdentificationBloC(this._iArticleLocalRepository);

  BehaviorSubject<List<ArticleBase>> _articleLocalController =
      new BehaviorSubject();

  Stream<List<ArticleBase>> get articlesResult =>
      _articleLocalController.stream;

  BehaviorSubject<bool> _loadingController = new BehaviorSubject();

  Stream<bool> get showLoading => _loadingController.stream;

  void loadArticles() async {
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

    _articleLocalController.sink.add(articles);
  }

  void deleteArticle(ArticleBase articleBase) async {
    if (articleBase is ArticleLocalModel)
      await _iArticleLocalRepository.deleteArticleLocal(articleBase);
    else
      await _deleteArticleFitting((articleBase as Fitting));
    loadArticles();
  }

  Future<void> _deleteArticleFitting(Fitting fitting) async {
    if (fitting is Windows) {
      await helper.deleteWindows(fitting.id);
      PDFManagerWindow.removePDF(fitting);
    } else if (fitting is Sliding) {
      await helper.deleteSliding(fitting.id);
    } else if (fitting is DoorLock) {
      await helper.deleteDoorLock(fitting.id);
    } else if (fitting is DoorHinge) {
      await helper.deleteDoorHinge(fitting.id);
    }
  }

  Future<String> getPDFPath(Fitting model) async {

  }

  void sendPdfByEmail(ArticleBase articleBase) async {
    _loadingController.sink.add(true);
    var htmlContent = await _loadHtmlFromAssets(articleBase);

    final appRootFiles = await FileUtils.getRootFilesDir();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    var targetFileName = "example-pdf";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, appRootFiles, targetFileName);

    final MailOptions mailOptions = MailOptions(
      body: 'Article fitting',
      subject: (articleBase is Fitting)
          ? articleBase.name
          : (articleBase as ArticleLocalModel).displayName,
      recipients: ['lepuchenavarro@gmail.com'],
      isHTML: true,
//      bccRecipients: ['other@example.com'],
//      ccRecipients: ['third@example.com'],
      attachments: [generatedPdfFile.path],
    );

    _loadingController.sink.add(false);
    await FlutterMailer.send(mailOptions);
  }

  Future<String> _loadHtmlFromAssets(ArticleBase article) async {
    String fileText = '';
    if (article is Windows) {
      fileText = await rootBundle.loadString('assets/articleWindows.html');
      fileText = await article.getHtmlString(fileText);
    } else if (article is DoorLock) {
      fileText = await rootBundle.loadString('assets/articleDoorLock.html');
      fileText = await article.getHtmlString(fileText);
    } else if (article is DoorHinge) {
      fileText = await rootBundle.loadString('assets/articleDoorHinge.html');
      fileText = await article.getHtmlString(fileText);
    } else if (article is Sliding) {
      fileText = await rootBundle.loadString('assets/articleSliding.html');
      fileText = await article.getHtmlString(fileText);
    }
    return fileText;
  }

  @override
  void dispose() {
    _articleLocalController.close();
    _loadingController.close();
  }
}
