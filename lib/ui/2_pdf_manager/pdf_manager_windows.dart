import 'dart:io';

import 'package:flutter/services.dart';
import 'package:repairservices/Utils/calendar_utils.dart';
import 'package:repairservices/Utils/file_utils.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';

class PDFManagerWindow {
  static List<PDFCell> _getListCells(Windows model) {
    List<PDFCell> list = [
      PDFCell(
          title: "Part number of defective component",
          value: "${model.number}"),
      PDFCell(title: "Year of construction", value: model.year),
      PDFCell(title: "Systen depth (mm)", value: model.systemDepth),
      PDFCell(title: "Profile system / -serie", value: model.profileSystem),
      PDFCell(title: "Description", value: model.description),
    ];
    return list;
  }

  static Future<String> getPDFPath(Windows model) async {
    try {
      if (model.pdfPath?.isNotEmpty == true) {
        final File previousFile = File(model.pdfPath);
        if (await previousFile.exists() && model.pdfPath.endsWith('.pdf')) {
          return model.pdfPath;
        }
      }

      ///Root
      final pdf = pw.Document();
      PdfImage logo = await PDFManager.getLogo(pdf);
      final ttfBold = await PDFManager.getTTFBold();
      final ttfRegular = await PDFManager.getTTFRegular();

      ///List of rows
      final cells = _getListCells(model);
      List<pw.Column> rows = PDFManager.getRows(cells, ttfRegular);

      ///List of associates images
      List<pw.Image> associatedImages =
          await PDFManager.getAttachedImages(pdf, [model.filePath]);

      ///Adding all views together in a column
      List<pw.Widget> children = [];
      children.add(
        pw.Text("Article details:",
            style: pw.TextStyle(
                fontSize: PDFManager.textFontSize,
                font: ttfBold,
                color: PdfColors.red)),
      );
      children.add(
        pw.SizedBox(height: 10),
      );
      children.addAll(rows);
      children.addAll(associatedImages);

      ///Creating pdf pages
      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (pw.Context context) => PDFManager.getHeader(ttfBold, logo),
          footer: (pw.Context context) => PDFManager.getFooter(context),
          build: (pw.Context context) => <pw.Widget>[
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: children),
              ]));

      final String filePath = await PDFManager.savePDFFile(pdf);
      return filePath;
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
