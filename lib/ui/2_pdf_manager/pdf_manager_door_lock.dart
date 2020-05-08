import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';

abstract class PDFManagerDoorLock {
  static List<PDFCell> _getListCells(DoorLock model) {
    List<PDFCell> list = [
      PDFCell(
          title: "Schüco logo visible on face place",
          value: "${model.logoVisible}"),
      PDFCell(title: "Profile insulation", value: model.profile),
      PDFCell(title: "Protection", value: model.protection),
      PDFCell(
          title: "Basic depth of door profile (mm)",
          value: model.basicDepthDoor),
      PDFCell(title: "Opening direction", value: model.openingDirection),
      PDFCell(title: "Leaf", value: model.leafDoor),
      PDFCell(title: "DIN direction", value: model.dinDirection),
      PDFCell(title: "Type", value: model.type),
      PDFCell(title: "Panic function", value: model.panicFunction),
      PDFCell(title: "Electric strike", value: model.electricStrike),
      PDFCell(title: "Lock with top locking", value: model.lockWithTopLocking),
    ];
    return list;
  }

  static Future<String> getPDFPath(DoorLock model) async {
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

      final String lockTypeId = model.lockType.replaceAll('t', 'T');
      ByteData bd1 =
          await rootBundle.load('lib/res/assets/img/lock$lockTypeId.png');
      final lockTypeImage = PdfImage.file(
        pdf.document,
        bytes: bd1.buffer.asUint8List(),
      );

      final String facePlateTypeId = model.facePlateType.replaceAll('t', 'T');
      ByteData bd2 = await rootBundle
          .load('lib/res/assets/img/facePlate$facePlateTypeId.png');
      final facePlateTypeImage = PdfImage.file(
        pdf.document,
        bytes: bd2.buffer.asUint8List(),
      );

      final String facePlateFixingId =
          model.facePlateFixing.replaceAll('type', '');
      ByteData bd3 = await rootBundle
          .load('lib/res/assets/img/facePlateFixing$facePlateFixingId.png');
      final facePlateFixingImage = PdfImage.file(
        pdf.document,
        bytes: bd3.buffer.asUint8List(),
      );

      ///List of associates images
      List<pw.Container> associatedImages = await PDFManager.getAttachedImages(
          pdf, [
        model.dimensionImage1Path,
        model.dimensionImage2Path,
        model.dimensionImage3Path
      ]);

      ///Adding all views together in a column
      pw.Container generalDataRowSection =
          PDFManager.getRowSection("General data", ttfBold);
      pw.Container lockDataRowSection =
          PDFManager.getRowSection("Lock data", ttfBold);
      pw.Container lockDimensionsRowSection =
          PDFManager.getRowSection("Lock dimensions", ttfBold);

      List<pw.Widget> children = [];
      children.add(
        generalDataRowSection,
      );
      children.addAll(rows);

      children.insert(7, lockDataRowSection);
      children.add(pw.Container(
          margin: pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(children: [
            pw.Row(children: [
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                    child: pw.Text("Lock type",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                            fontSize: PDFManager.textFontSize,
                            font: ttfRegular,
                            color: PdfColors.black)),
                    width: double.infinity,
                    padding:
                        pw.EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    color: PdfColors.grey200),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                    child: pw.Text("Face plate type",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: PDFManager.textFontSize,
                            font: ttfRegular,
                            color: PdfColors.black)),
                    width: double.infinity,
                    padding:
                        pw.EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    color: PdfColors.grey200),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                    child: pw.Text("Face plate fixing",
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            fontSize: PDFManager.textFontSize,
                            font: ttfRegular,
                            color: PdfColors.black)),
                    width: double.infinity,
                    padding:
                        pw.EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    color: PdfColors.grey200),
              )
            ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(lockTypeImage),
                  pw.Image(facePlateTypeImage),
                  pw.Image(facePlateFixingImage),
                ]),
          ])));
      children.add(
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        lockDimensionsRowSection,
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Expanded(flex: 1, child: associatedImages[0]),
              pw.Expanded(flex: 1, child: associatedImages[1]),
              pw.Expanded(flex: 1, child: associatedImages[2]),
            ])
      ]));

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

  static Future<void> removePDF(DoorLock windows) async {
    if (windows?.pdfPath?.isNotEmpty == true) {
      final pdfFile = File(windows.pdfPath);
      if (await pdfFile.exists()) await pdfFile.delete();
    }
  }
}
