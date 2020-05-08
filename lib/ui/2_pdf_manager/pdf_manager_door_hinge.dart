import 'dart:io';

import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFManagerDoorHinge {
  static List<PDFCell> _getListCells(DoorHinge model) {
    List<PDFCell> list = [
      PDFCell(title: "Year of construction", value: model.year),
    ];
    return list;
  }

  static Future<String> getPDFPath(DoorHinge model) async {
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


      ///Adding all views together in a column
      pw.Container detailsRowSection =
      PDFManager.getRowSection("Article details", ttfBold);

      List<pw.Widget> children = [];
      children.add(
        detailsRowSection,
      );
      children.addAll(rows);

      ///Creating pdf pages
      pdf.addPage(
        pw.MultiPage(
            pageFormat: PDFManager.pageFormat,
            header: (pw.Context context) => PDFManager.getHeader(ttfBold, logo),
            footer: (pw.Context context) => PDFManager.getFooter(context),
            build: (pw.Context context) => <pw.Widget>[
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: children),
            ]),
      );

      final String filePath = await PDFManager.savePDFFile(pdf);
      return filePath;

    }catch(ex){
      return '';
    }
  }

  static Future<void> removePDF(DoorHinge model) async {
    if (model?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(model.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }

//    if (model?.dimensionImage1Path?.isNotEmpty == true) {
//      final imagePath = File(model.dimensionImage1Path);
//      if (await imagePath.exists()) await imagePath.delete();
//    }
  }
}
