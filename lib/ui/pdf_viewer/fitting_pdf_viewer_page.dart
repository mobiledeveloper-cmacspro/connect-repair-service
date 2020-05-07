import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_loading_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/pdf_viewer/pdf_viewer_bloc.dart';

class FittingPDFViewerPage extends StatefulWidget {
  final Fitting model;

  const FittingPDFViewerPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingPDFViewerState();
}

class _FittingPDFViewerState
    extends StateWithBloC<FittingPDFViewerPage, PDFViewerBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadPDF(widget.model);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder<String>(
          stream: bloc.pdfPathResult,
          initialData: null,
          builder: (ctx, snapshot) {
            return (snapshot.data == null || snapshot.data.isEmpty)
                ? TXMainBarWidget(
                    leading: TXIconButtonWidget(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: R.color.primary_color,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: widget.model.name ?? "PDF viewer",
                    body: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: snapshot.data == null
                            ? Container()
                            : TXTextWidget(
                                text: "Failed to load PDF",
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
                          Icons.arrow_back_ios,
                          color: R.color.primary_color,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      centerTitle: Platform.isIOS,
                      title: TXTextWidget(
                        size: 18,
                        color: Colors.black,
                        text: widget.model.name ?? "PDF viewer",
                      ),
                    ),
                  );
          },
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }
}
