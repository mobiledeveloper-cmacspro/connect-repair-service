import 'dart:io';

import 'package:flutter/services.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFManagerDoorHinge {
  static List<PDFCell> _getListCells(DoorHinge model, {int type}) {
    List<PDFCell> list = [
      PDFCell(title: R.string.yearConstruction, value: model.year),
      PDFCell(
          title: R.string.basicDepthDoorLeafMM,
          value: model.basicDepthOfDoorLeaf),
      PDFCell(title: R.string.schucoSystem, value: model.systemHinge),
      PDFCell(title: R.string.material, value: model.material),
      PDFCell(title: R.string.thermally, value: model.thermally),
      PDFCell(title: R.string.doorOpening, value: model.doorOpening),
      PDFCell(title: R.string.fitted, value: model.fitted),
      PDFCell(title: R.string.dimensionSurface, value: ""),
      PDFCell(title: R.string.hingeType, value: model.hingeType),
    ];

    if (type == 2) {
      list.add(PDFCell(
          title: "${R.string.doorHingeDetails}: ${model.doorHingeDetailsIm}", value: ""));
      list.add(
          PDFCell(
              title: R.string.coverCapsDoorHinge, value: model.coverCaps));
    }
    
    if(type == 1){
      list.add(PDFCell(title: R.string.doorLeafMM, value: model.doorLeafBarrel));
      list.add(PDFCell(title: R.string.system, value: model.systemDoorLeaf));
      list.add(PDFCell(title: R.string.doorFrameMM, value: model.doorFrame));
      list.add(PDFCell(title: R.string.system, value: model.systemDoorFrame));
      list.add(PDFCell(title: R.string.dimensionBarrel, value: ""));
    }

    return list;
  }

  static Future<String> getPDFPath(DoorHinge model, {int type}) async {
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
      final cells = _getListCells(model, type: type);
      List<pw.Column> rows = PDFManager.getRows(cells, ttfRegular);

      ///Adding all views together in a column
      pw.Container detailsRowSection =
      PDFManager.getRowSection(R.string.generalData, ttfBold);

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
      children.insert(9, associatedImages[0]);

      if(type == 1){
        children.add(associatedImages[1]);
      }

      if(type == 2){
        final String doorHingeDetailsImId =
        model.doorHingeDetailsIm.replaceAll('type', '');
        ByteData bd1 = await rootBundle
            .load('lib/res/assets/img/surfaceType$doorHingeDetailsImId.png');
        final doorHingeDetailsImage = PdfImage.file(
          pdf.document,
          bytes: bd1.buffer.asUint8List(),
        );
        children.insert(12, pw.Image(doorHingeDetailsImage));
      }

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

  static Future<void> removePDF(DoorHinge model) async {
    if (model?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(model.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }
  }
}
