import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';

class PDFManagerSliding {
  static List<PDFCell> _getListCells(Sliding model) {
    List<PDFCell> list = [
      PDFCell(title: R.string.yearConstruction, value: model.year),
      PDFCell(title: R.string.fittingManufacturer, value: "${model.manufacturer}"),
      PDFCell(title: R.string.openingDirection, value: model.directionOpening),
      PDFCell(title: R.string.material, value: "${model.material}"),
      PDFCell(title: R.string.system, value: "${model.system}"),
      PDFCell(title: R.string.ventOverlapMM, value: "${model.ventOverlap}"),
      PDFCell(title: R.string.tiltSlidingFittings, value: "${model.tiltSlide}"),
    ];
    return list;
  }

  static Future<String> getPDFPath(Sliding model) async {
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
      List<pw.Container> associatedImages =
          await PDFManager.getAttachedImages(pdf, [model.dimensionImage1Path]);

      final String id = model.directionOpening.replaceAll("type", '');
      ByteData bd = await rootBundle
          .load('lib/res/assets/img/slidingDirectionOpening$id.png');
      final openingImage = PdfImage.file(
        pdf.document,
        bytes: bd.buffer.asUint8List(),
      );

      ///Adding all views together in a column
      pw.Container detailsRowSection =
          PDFManager.getRowSection(R.string.articleDetails, ttfBold);

      List<pw.Widget> children = [];
      children.add(
        detailsRowSection,
      );
      children.addAll(rows);
      children.insert(
          5,
          pw.Container(
              padding: pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Image(openingImage)));
      children.addAll(associatedImages);

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
    } catch (ex) {
      return '';
    }
  }

  static Future<void> removePDF(Sliding model) async {
    if (model?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(model.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }

    if (model?.dimensionImage1Path?.isNotEmpty == true) {
      final imagePath = File(model.dimensionImage1Path);
      if (await imagePath.exists()) await imagePath.delete();
    }
  }
}
