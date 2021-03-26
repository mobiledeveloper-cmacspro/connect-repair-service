import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:repairservices/utils/calendar_utils.dart';

class PDFManagerProjectDocumentation {
  static List<PDFCell> _getListReportCells(ProjectDocumentReportModel report) {
    List<PDFCell> listCellsReport = [];
    listCellsReport.add(
      PDFCell(title: R.string.category, value: report.category),
    );
    listCellsReport.add(
      PDFCell(
        title: R.string.date,
        value: CalendarUtils.showInFormat(
            R.string.dateFormat1, report?.date ?? DateTime.now()),
      ),
    );
    listCellsReport.add(
      PDFCell(
        title: R.string.beginDate,
        value: CalendarUtils.showInFormat(
            R.string.dateFormat2, report?.begin ?? DateTime.now()),
      ),
    );
    listCellsReport.add(
      PDFCell(
        title: R.string.endDate,
        value: CalendarUtils.showInFormat(
            R.string.dateFormat2, report?.end ?? DateTime.now()),
      ),
    );
    listCellsReport.add(
      PDFCell(title: R.string.note, value: report.shortInfo),
    );
    listCellsReport.add(
      PDFCell(title: R.string.video, value: R.string.videoReport),
    );
    listCellsReport.add(
      PDFCell(title: R.string.voiceMemo, value: R.string.voiceMemoReport),
    );
    listCellsReport.add(
      PDFCell(title: R.string.photo, value: ""),
    );
    return listCellsReport;
  }

  static List<PDFCell> _getListCells(ProjectDocumentModel model) {
    List<PDFCell> list = [
      PDFCell(title: R.string.projectName, value: model.name),
      PDFCell(
          title: R.string.projectNumber, value: model.number?.toString() ?? ""),
      PDFCell(title: R.string.projectShortName, value: model.abbreviation ?? ""),
      PDFCell(title: R.string.address, value: model.address?.addressStr ?? ""),
      PDFCell(
          title: R.string.participants,
          value: model.participants?.toString() ?? ""),
      PDFCell(
          title: R.string.totalCost, value: model.totalCost?.toString() ?? ""),
      PDFCell(title: R.string.categories, value: model.category ?? ""),
      PDFCell(title: R.string.projectInfo, value: model.info ?? ""),
      PDFCell(title: R.string.photo, value: ""),
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
          PDFManager.getRowSection(R.string.generalProjectInfo, ttfBold);

      pw.Container detailsReportRowSection =
          PDFManager.getRowSection(R.string.archiveReport, ttfBold);

      ///List of associates images
      pw.Container projectPhoto;
      if (model.photo != null) {
        projectPhoto = await PDFManager.getAttachedImage(pdf, model.photo);
      }

      List<pw.Widget> children = [];

      children.add(
        detailsRowSection,
      );

      children.addAll(rows);

      if (projectPhoto != null) children.add(projectPhoto);

      await Future.forEach<ProjectDocumentReportModel>(model.reports ?? [],
          (report) async {
        children.add(detailsReportRowSection);
        final reportCells = _getListReportCells(report);
        List<pw.Column> reportRows =
            PDFManager.getRows(reportCells, ttfRegular);
        children.addAll(reportRows);
        if (report?.photo != null) {
          final reportPhoto =
              await PDFManager.getAttachedImage(pdf, report.photo);
          if (reportPhoto != null) {
            children.add(reportPhoto);
          }
        }
        if (report?.measurementCamera != null) {
          final reportMeasurementCamera =
              await PDFManager.getAttachedImage(pdf, report.measurementCamera);
          if (reportMeasurementCamera != null) {
            children.add(reportMeasurementCamera);
          }
        }
      });

      ///Creating pdf pages
      pdf.addPage(
        pw.MultiPage(
            pageFormat: PDFManager.pageFormat,
            header: (pw.Context context) => PDFManager.getHeader(ttfBold, logo,
                title: R.string.projectDocumentation),
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
      print(ex.toString());
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
