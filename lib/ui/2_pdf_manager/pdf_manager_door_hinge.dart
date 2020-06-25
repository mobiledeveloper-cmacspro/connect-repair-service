import 'dart:io';

import 'package:flutter/services.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFManagerDoorHinge {
  static List<PDFCell> _getListCells(DoorHinge model, {int type}) {
    List<PDFCell> list = [
      PDFCell(title: "Year of construction", value: model.year),
      PDFCell(
          title: "Basic depth of door leaf (mm)",
          value: model.basicDepthOfDoorLeaf),
      PDFCell(title: "Schüco system", value: model.systemHinge),
      PDFCell(title: "Material", value: model.material),
      PDFCell(title: "Thermally", value: model.thermally),
      PDFCell(title: "Door opening", value: model.doorOpening),
      PDFCell(title: "Fitted", value: model.fitted),
      PDFCell(title: "Dimension surface", value: ""),
      PDFCell(title: "Hinge type", value: model.hingeType),
    ];

    if (type == 2) {
      list.add(PDFCell(
          title: "Door hinge details: ${model.doorHingeDetailsIm}", value: ""));
      list.add(
          PDFCell(
              title: "Cover caps of the door hinge", value: model.coverCaps));
    }
    
    if(type == 1){
      list.add(PDFCell(title: "Door leaf (mm)", value: model.doorLeafBarrel));
      list.add(PDFCell(title: "System", value: model.systemDoorLeaf));
      list.add(PDFCell(title: "Door frame (mm)", value: model.doorFrame));
      list.add(PDFCell(title: "System", value: model.systemDoorFrame));
      list.add(PDFCell(title: "Dimension barrel", value: ""));
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
