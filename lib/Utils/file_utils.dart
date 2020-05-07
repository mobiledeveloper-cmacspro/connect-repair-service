import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as im;
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/domain/common_model.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';

class FileUtils {
  static Future<String> getRootFilesDir() async {
    try {
      Directory appDocDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();
      return appDocDir.path;
    } catch (ex) {
      return '';
    }
  }

  static Future<String> getPDFPathFitting(Fitting fitting,
      {List<PdfCellModel> cells, List<String> filePaths}) async {
    try {
      final File previousFile = File(fitting.pdfPath);
      if (fitting.pdfPath.endsWith('.pdf') && await previousFile.exists()) {
        return fitting.pdfPath;
      }
      final appRootFiles = await FileUtils.getRootFilesDir();
      final fileName = CalendarUtils.getTimeIdBasedSeconds();

      File fileLogo = File('$appRootFiles/logo.png');
      if (!await fileLogo.exists()) {
        ByteData bd = await rootBundle.load(R.image.logo);
        await fileLogo.writeAsBytes(bd.buffer.asUint8List(), flush: true);
      }

      final pdf = pw.Document();

      final pdfLogoImg = PdfImage.file(
        pdf.document,
        bytes: fileLogo.readAsBytesSync(),
      );
      final textFontSize = 18.0;

      ByteData bdBold =
          await rootBundle.load('lib/res/assets/fonts/montserrat_bold.ttf');
      ByteData bdRegular =
          await rootBundle.load('lib/res/assets/fonts/montserrat_regular.ttf');
      final ttfBold = pw.Font.ttf(bdBold);
      final ttfRegular = pw.Font.ttf(bdRegular);

      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (pw.Context context) {
            return pw.Container(
                width: double.infinity,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("RepairService@Connect Mobile",
                          style: pw.TextStyle(
                              color: PdfColors.green,
                              fontSize: textFontSize,
                              font: ttfBold)),
                      pw.SizedBox(height: 15),
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Image(pdfLogoImg, width: 70, height: 70),
                            pw.Expanded(child: pw.Container()),
                            pw.Text(
                                CalendarUtils.showInFormat(
                                    'dd/MM/yyyy', DateTime.now()),
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: textFontSize)),
                          ])
                    ]));
          },
          footer: (pw.Context context) {
            return pw.Container(
                width: double.infinity,
                child: pw.Column(children: [
                  pw.Text('${context.pageNumber}/${context.pagesCount}',
                      style: pw.TextStyle(fontSize: textFontSize))
                ]));
          },
          build: (pw.Context context) => <pw.Widget>[
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 30),
                      pw.Text("Article details:",
                          style: pw.TextStyle(
                              fontSize: textFontSize,
                              font: ttfBold,
                              color: PdfColors.red)),
                      pw.SizedBox(height: 10),
                      pw.ListView.builder(
                          itemBuilder: (ctx, index) {
                            final cell = cells[index];
                            return pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                      child: pw.Text(cell.title,
                                          style: pw.TextStyle(
                                              fontSize: textFontSize,
//                                              font: ttfBold,
                                              color: PdfColors.black)),
                                      width: double.infinity,
                                      padding: pw.EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      color: PdfColors.grey200),
                                  pw.Container(
                                      child: pw.Text(cell.value,
                                          style: pw.TextStyle(
                                              fontSize: textFontSize,
//                                              font: ttfRegular,
                                              color: PdfColors.grey600)),
                                      padding: pw.EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      width: double.infinity)
                                ]);
                          },
                          itemCount: cells.length),
                    ]),
              ]));

      final File file = File('$appRootFiles/$fileName.pdf');
      file.writeAsBytesSync(pdf.save());
      return file.path;
    } catch (ex) {
      return '';
    }
  }
}
