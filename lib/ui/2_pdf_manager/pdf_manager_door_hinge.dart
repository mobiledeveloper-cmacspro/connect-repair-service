import 'dart:io';

import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFManagerDoorHinge {
  static List<PDFCell> _getListCells(DoorHinge model) {
    List<PDFCell> list = [
      PDFCell(title: "Year of construction", value: model.year),
      PDFCell(
          title: "Basic depth of the door leaf (mm)",
          value: model.basicDepthOfDoorLeaf),
      PDFCell(title: "Schüco system", value: model.systemHinge),
      PDFCell(title: "Material", value: model.material),
      PDFCell(title: "Thermally", value: model.thermally),
      PDFCell(title: "Door opening", value: model.doorOpening),
      PDFCell(title: "Fitter", value: model.fitted),
      PDFCell(title: "Dimension surface", value: ""),
      PDFCell(title: "Hinge type", value: model.hingeType),
      PDFCell(title: "Door leaf (mm)", value: model.systemDoorLeaf),
      PDFCell(title: "Door frame (mm)", value: model.doorFrame),
      PDFCell(title: "System", value: model.systemHinge),
      PDFCell(title: "Dimension barrel", value: ""),
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
          PDFManager.getRowSection("General Data", ttfBold);

      ///List of associates images
      List<pw.Container> associatedImages =
          await PDFManager.getAttachedImages(pdf, [
        model.dimensionSurfaceIm,
        model.dimensionBarrelIm,
      ]);

      List<pw.Widget> children = [];
      children.add(
        detailsRowSection,
      );
      children.addAll(rows);

//      children.insert(
//          9,
//          pw.Container(
//              padding: pw.EdgeInsets.symmetric(vertical: 5),
//              child: associatedImages[0]));
//
//      children.add(pw.Container(
//          padding: pw.EdgeInsets.symmetric(vertical: 5),
//          child: associatedImages[1]));

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

  static Future<void> removePDF(DoorHinge model) async {
    if (model?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(model.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }
  }
}
