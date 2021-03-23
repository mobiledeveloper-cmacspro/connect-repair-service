import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFManagerProjectDocumentation{
  static List<PDFCell> _getListCells(ProjectDocumentModel model) {
    List<PDFCell> list = [
      PDFCell(title: R.string.yearConstruction, value: "2020"),

    ];

    return list;
  }

  static Future<String> getPDFPath(ProjectDocumentModel model) async {
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
      PDFManager.getRowSection(R.string.generalData, ttfBold);

      ///List of associates images
      List<pw.Container> associatedImages =
      await PDFManager.getAttachedImages(pdf, [

      ]);

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
            build: (pw.Context context) =>
            <pw.Widget>[
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: children),
            ]),
      );

      final String filePath = await PDFManager.savePDFFile(pdf);
      return filePath;
    } catch (ex) {
      return '';
    }
  }

  static Future<void> removePDF(ProjectDocumentModel model) async {
    if (model?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(model.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }
  }
}