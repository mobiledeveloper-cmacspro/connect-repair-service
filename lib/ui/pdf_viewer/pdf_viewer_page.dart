import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_loading_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/pdf_viewer/pdf_viewer_bloc.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';

class PDFViewerPage extends StatefulWidget {
  final ArticleBase model;
  final bool navigateFromDetail;
  final bool isForPrint;
  final bool isForMail;

  const PDFViewerPage(
      {Key key,
      this.model,
      this.navigateFromDetail = false,
      this.isForPrint = false,
      this.isForMail = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingPDFViewerState();
}

class _FittingPDFViewerState
    extends StateWithBloC<PDFViewerPage, PDFViewerBloC> {
  _navBack() {
    widget.navigateFromDetail
        ? NavigationUtils.pop(context)
        : NavigationUtils.popUntilWithRoute(
            context, NavigationUtils.ArticleIdentificationPage);
  }

  @override
  void initState() {
    super.initState();
    bloc.loadPDF(widget.model);
    bloc.sendEmailResult.listen((event) {
      NavigationUtils.pop(context, result: event);
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    String name = (widget.model is Fitting)
        ? (widget.model as Fitting).getNamei18N
        : (widget.model as ProjectDocumentModel).fixedName ?? R.string.pdfViewer;
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          StreamBuilder<String>(
            stream: bloc.pdfPathResult,
            initialData: null,
            builder: (ctx, snapshot) {
              return (snapshot.data == null || snapshot.data.isEmpty)
                  ? TXMainBarWidget(
                      onLeadingTap: () {
                        _navBack();
                      },
                      title: name,
                      body: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: snapshot.data == null
                              ? Container()
                              : TXTextWidget(
                                  text: R.string.failedLoadPDF,
                                  size: 18,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    )
                  : PDFViewerScaffold(
                      path: snapshot.data,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        leading: TXIconButtonWidget(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: R.color.primary_color,
                            size: 35,
                          ),
                          onPressed: () {
                            _navBack();
                          },
                        ),
                        centerTitle: Platform.isIOS,
                        title: TXTextWidget(
                          size: 18,
                          color: Colors.black,
                          text: name,
                        ),
                        actions: <Widget>[
                          widget.isForMail || widget.isForPrint
                              ? InkWell(
                                  child: Container(
                                    child: TXTextWidget(
                                      text: widget.isForMail
                                          ? R.string.send
                                          : R.string.print,
                                      fontWeight: FontWeight.bold,
                                      color: R.color.primary_color,
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 5)
                                        .copyWith(right: 10),
                                  ),
                                  onTap: () {
                                    if (widget.isForMail) {
                                      bloc.sendPdfByEmail(widget.model);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: R.string.underConstruction,
                                          toastLength: Toast.LENGTH_LONG);
                                    }
                                  },
                                )
                              : Container()
                        ],
                      ),
                    );
            },
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }
}