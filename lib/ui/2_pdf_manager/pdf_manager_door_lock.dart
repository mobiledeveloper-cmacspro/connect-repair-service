import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';

abstract class PDFManagerDoorLock {
  static List<PDFCell> _getListCells(DoorLock model) {
    List<PDFCell> list = [
      PDFCell(
          title: R.string.logoVisibleFacePlate,
          value: "${model.logoVisible}"),
      PDFCell(title: R.string.yearOfManufacturing, value: model.year),
      PDFCell(title: R.string.profileInsulation, value: model.profile),
      PDFCell(title: R.string.protection, value: model.protection),
      PDFCell(
          title: R.string.basicDepthDoorProfileMM,
          value: model.basicDepthDoor),
      PDFCell(title: R.string.openingDirection, value: model.openingDirection),
      PDFCell(title: R.string.leaf, value: model.leafDoor),


      PDFCell(title: R.string.dinDirection, value: model.dinDirection),
      PDFCell(title: R.string.type, value: model.type),
      PDFCell(title: R.string.panicFunction, value: model.panicFunction),
      PDFCell(title: R.string.electricStrike, value: model.electricStrike),
      PDFCell(title: R.string.lockTopLocking, value: model.lockWithTopLocking),
    ];

    if(model.leafDoor != R.string.single){
      list.insert(7, PDFCell(title: R.string.bolt, value: model.bolt));
    }

    if (model.lockWithTopLocking == R.string.yes) {
      list.add(
          PDFCell(title: R.string.shootBoltLock, value: model.shootBoltLock));
      list.add(
          PDFCell(title: R.string.handleHeight, value: model.handleHeight));
      list.add(
          PDFCell(title: R.string.doorLeafHeight, value: model.doorLeafHight));
      list.add(PDFCell(title: R.string.restrictor, value: model.restrictor));
    }
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

      final String multiPointLockingId =
      model.multipointLocking.replaceAll('type', '');
      ByteData bd4 = await rootBundle
          .load('lib/res/assets/img/multipointLocking$multiPointLockingId.png');
      final multiPointLockingImage = PdfImage.file(
        pdf.document,
        bytes: bd4.buffer.asUint8List(),
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
      PDFManager.getRowSection(R.string.generalData, ttfBold);
      pw.Container lockDataRowSection =
      PDFManager.getRowSection(R.string.lockData, ttfBold);
      pw.Container lockDimensionsRowSection =
      PDFManager.getRowSection(R.string.lockDimensions, ttfBold);

      List<pw.Widget> children = [];
      children.add(
        generalDataRowSection,
      );
      children.addAll(rows);

      final int lockDataPos = model.leafDoor != R.string.single ? 9 : 8;
      children.insert(lockDataPos, lockDataRowSection);
      children.add(pw.Container(
          margin: pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                        child: pw.Text(R.string.lockType,
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                                fontSize: PDFManager.textFontSizeMin,
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
                        child: pw.Text(R.string.facePlateType,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: PDFManager.textFontSizeMin,
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
                        child: pw.Text(R.string.facePlateFixing,
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: PDFManager.textFontSizeMin,
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
                        child: pw.Text(R.string.multiPointLocking,
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: PDFManager.textFontSizeMin,
                                font: ttfRegular,
                                color: PdfColors.black)),
                        width: double.infinity,
                        padding:
                        pw.EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        color: PdfColors.grey200),
                  )
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Image(lockTypeImage),
                  pw.Image(facePlateTypeImage),
                  pw.Image(facePlateFixingImage),
                  pw.Image(multiPointLockingImage),
                ]),
          ])));
      children.add(
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            lockDimensionsRowSection,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
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
      print(ex.toString());
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
