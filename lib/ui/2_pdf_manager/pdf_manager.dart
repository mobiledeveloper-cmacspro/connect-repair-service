import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/utils/file_utils.dart';
import 'package:repairservices/res/R.dart';

class PDFCell {
  String title;
  String value;

  PDFCell({this.title, this.value});
}

class PDFManager {
  ///For text style
  static double textFontSize = 18.0;
  static double textFontSizeMedium = 15.0;
  static double textFontSizeMin = 12.0;
  static PdfPageFormat pageFormat = PdfPageFormat.a4;

  static Future<Font> getTTFBold() async {
    ByteData bdBold =
        await rootBundle.load('lib/res/assets/fonts/montserrat_bold.ttf');
    return pw.Font.ttf(bdBold);
  }

  static Future<Font> getTTFRegular() async {
    ByteData bdRegular =
        await rootBundle.load('lib/res/assets/fonts/montserrat_regular.ttf');
    return pw.Font.ttf(bdRegular);
  }

  static Future<String> getRootFiles() async =>
      await FileUtils.getRootFilesDir();

  static Future<PdfImage> getLogo(Document document) async {
    File fileLogo = File('${await getRootFiles()}/logo.png');
    if (!await fileLogo.exists()) {
      ByteData bd = await rootBundle.load(R.image.logo);
      await fileLogo.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    }
    final pdfLogoImg = PdfImage.file(
      document.document,
      bytes: fileLogo.readAsBytesSync(),
    );
    return pdfLogoImg;
  }

  static pw.Container getHeader(Font ttfBold, PdfImage pdfLogoImg) {
    return pw.Container(
        width: double.infinity,
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("RepairService@Connect Mobile",
              style: pw.TextStyle(
                  color: PdfColors.green,
                  fontSize: textFontSize,
                  font: ttfBold)),
          pw.SizedBox(height: 15),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Image(pdfLogoImg, width: 70, height: 70),
            pw.Expanded(child: pw.Container()),
            pw.Text(CalendarUtils.showInFormat('dd/MM/yyyy', DateTime.now()),
                style: pw.TextStyle(
                    color: PdfColors.black, fontSize: textFontSize)),
          ]),
          pw.SizedBox(height: 30),
        ]));
  }

  static pw.Container getRowSection(String title, Font ttfBold) {
    return pw.Container(
        padding: pw.EdgeInsets.only(bottom: 10),
        child: pw.Text("$title:",
            style: pw.TextStyle(
                fontSize: textFontSize, font: ttfBold, color: PdfColors.red)));
  }

  static List<pw.Column> getRows(List<PDFCell> pdfCells, Font ttfRegular) {
    List<pw.Column> rows = [];
    pdfCells.forEach((cell) {
      final w =
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Container(
            child: pw.Text(cell.title,
                style: pw.TextStyle(
                    fontSize: textFontSize,
                    font: ttfRegular,
                    color: PdfColors.black)),
            width: double.infinity,
            padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: PdfColors.grey200),
        pw.Container(
            child: pw.Text(cell.value,
                style: pw.TextStyle(
                    fontSize: textFontSize,
                    font: ttfRegular,
                    color: PdfColors.grey600)),
            padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            width: double.infinity)
      ]);
      rows.add(w);
    });
    return rows;
  }

  static pw.Container getFooter(pw.Context context) {
    return pw.Container(
        width: double.infinity,
        child: pw.Column(children: [
          pw.SizedBox(height: 30),
          pw.Text('${context.pageNumber}/${context.pagesCount}',
              style: pw.TextStyle(fontSize: textFontSize))
        ]));
  }

  static Future<List<pw.Container>> getAttachedImages(
      Document pdf, List<String> filePaths) async {
    List<pw.Container> images = [];
    await Future.forEach<String>(filePaths, (f) async {
      if (f?.isNotEmpty == true) {
        File file = File(f);
        if (await file.exists()) {
          PdfImage pdfImage = PdfImage.file(
            pdf.document,
            bytes: file.readAsBytesSync(),
          );
          images.add(
            pw.Container(
              constraints:
                  pw.BoxConstraints(maxWidth: double.infinity, maxHeight: 400),
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            ),
          );
        }
      }
    });
    return images;
  }

  static Future<String> savePDFFile(Document pdf) async {
    final rootPath = await getRootFiles();
    final fileName = CalendarUtils.getTimeIdBasedSeconds();
    final File file = File('$rootPath/$fileName.pdf');
    file.writeAsBytesSync(pdf.save());

    ///Cleaning unused files starting with prefix temp
    Directory appDocDir = await FileUtils.getRootFilesDirectory();

    final List<FileSystemEntity> files = appDocDir.listSync();
    files.forEach((f) {
      if (f is File && f.path.split("/").last.startsWith("temp"))
        f.deleteSync();
    });

    return file.path;
  }
}
