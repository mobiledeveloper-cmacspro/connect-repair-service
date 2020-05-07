import 'dart:io';

import 'package:flutter/services.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as im;

class PdfCellWindows {
  String title;
  String value;

  PdfCellWindows({this.title, this.value});
}

class PDFManagerWindow {
  static List<PdfCellWindows> _getListFromFitting(Windows model) {
    List<PdfCellWindows> list = [
      PdfCellWindows(
          title: "Part number of defective component",
          value: "${model.number}"),
      PdfCellWindows(title: "Year of construction", value: "${model.year}"),
      PdfCellWindows(title: "Systen depth (mm)", value: "${model.systemDepth}"),
      PdfCellWindows(
          title: "Profile system / -serie", value: "${model.profileSystem}"),
      PdfCellWindows(title: "Description", value: "${model.description}"),
    ];
    return list;
  }

  static Future<String> getPDFPathWindows(Windows windows) async {
    try {
      final cells = _getListFromFitting(windows);

      if (windows.pdfPath?.isNotEmpty == true) {
        final File previousFile = File(windows.pdfPath);
        if (await previousFile.exists() && windows.pdfPath.endsWith('.pdf')) {
          return windows.pdfPath;
        }
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

      List<pw.Column> rows = [];
      cells.forEach((cell) {
        final w = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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

      List<pw.Image> associatedImages = [];
      if (windows.filePath?.isNotEmpty == true) {
        File f = File(windows.filePath);
        if (await f.exists()) {
          PdfImage pdfImage = PdfImage.file(
            pdf.document,
            bytes: f.readAsBytesSync(),
          );
          associatedImages.add(pw.Image(pdfImage));
        }
      }

      List<pw.Widget> children = [];
      children.add(
        pw.Text("Article details:",
            style: pw.TextStyle(
                fontSize: textFontSize, font: ttfBold, color: PdfColors.red)),
      );
      children.add(
        pw.SizedBox(height: 10),
      );
      children.addAll(rows);
      children.addAll(associatedImages);

      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (pw.Context context) {
            return pw.Container(
                width: double.infinity,
                color: PdfColors.grey50,
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
                          ]),
                      pw.SizedBox(height: 30),
                    ]));
          },
          footer: (pw.Context context) {
            return pw.Container(
                color: PdfColors.grey50,
                width: double.infinity,
                child: pw.Column(children: [
                  pw.SizedBox(height: 30),
                  pw.Text('${context.pageNumber}/${context.pagesCount}',
                      style: pw.TextStyle(fontSize: textFontSize))
                ]));
          },
          build: (pw.Context context) => <pw.Widget>[
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: children),
              ]));

      final File file = File('$appRootFiles/$fileName.pdf');
      file.writeAsBytesSync(pdf.save());
      return file.path;
    } catch (ex) {
      return '';
    }
  }

  static Future<void> removePDF(Windows windows) async {
    if (windows?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(windows.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }

    if (windows?.filePath?.isNotEmpty == true) {
      final imagePath = File(windows.filePath);
      if (await imagePath.exists()) await imagePath.delete();
    }
  }
}
