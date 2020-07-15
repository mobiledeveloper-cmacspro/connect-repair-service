import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/DoorLockData.dart';
import 'package:repairservices/database_helpers.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_action_sheet_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/2_pdf_manager/pdf_manager_windows.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_bloc.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';
import 'package:repairservices/utils/mail_mananger.dart';

class FittingWindowsDetailPage extends StatefulWidget {
  final Windows model;
  final TypeFitting typeFitting;

  const FittingWindowsDetailPage({Key key, this.model, this.typeFitting})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingWindowsDetails();
}

class _FittingWindowsDetails
    extends StateWithBloC<FittingWindowsDetailPage, FittingWindowsBloC> {
  @override
  void initState() {
    super.initState();
    bloc.deleteResult.listen((onData) {
      if (onData == true) {
        NavigationUtils.pop(context);
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainBarWidget(
      title: widget.model.name,
      onLeadingTap: () {
        Navigator.pop(context);
      },
      actions: <Widget>[
        TXIconButtonWidget(
          onPressed: () {
            launchOptions(context);
          },
          icon: Icon(
            Icons.more_horiz,
            color: R.color.primary_color,
            size: 35,
          ),
        )
      ],
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TXDividerWidget(),
              TXItemCellEditWidget(
                title: R.string.partNumberDefectiveComponent,
                value: widget.model.number.toString(),
              ),
              TXDividerWidget(),
              TXItemCellEditWidget(
                title: R.string.yearConstruction,
                value: widget.model.year,
              ),
              widget.typeFitting == TypeFitting.other ||
                      widget.typeFitting == TypeFitting.windows
                  ? Column(
                      children: <Widget>[
                        TXDividerWidget(),
                        TXItemCellEditWidget(
                          title: R.string.systemDepthMM,
                          value: widget.model.systemDepth,
                        ),
                        TXDividerWidget(),
                        TXItemCellEditWidget(
                          title: R.string.profileSystemSerie,
                          value: widget.model.profileSystem,
                        ),
                      ],
                    )
                  : Container(),
              TXDividerWidget(),
              TXItemCellEditWidget(
                title: R.string.description,
                value: widget.model.description,
              ),
              TXDividerWidget(),
              Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: R.string.underConstruction);
                      },
                      child: Container(
                        constraints:
                            BoxConstraints(maxHeight: 150, maxWidth: 150),
                        child: widget.model.filePath?.isNotEmpty == true
                            ? Image.file(File(widget.model.filePath))
                            : Container(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void launchOptions(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return TXCupertinoActionSheetWidget(
            onActionTap: (action) async {
              if (action.key == 'Print' || action.key == 'Email') {
                Future.delayed(Duration(milliseconds: 100), () async{
                  final res = await NavigationUtils.pushCupertino(
                      context,
                      FittingPDFViewerPage(
                        navigateFromDetail: true,
                        model: widget.model,
                        isForMail: action.key == 'Email',
                        isForPrint: action.key == 'Print',
                      ));
                  if (res is MailModel) {
                    final sendResult = await MailManager.sendEmail(res);
                    if (sendResult != 'OK') {
                      Fluttertoast.showToast(
                          msg: "$res",
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.red);
                    }
                  }
                });
              } else if (action.key == 'Remove') {
                bloc.delete(widget.model);
              }
            },
            actions: [
              ActionSheetModel(
                  key: "Print",
                  title: R.string.print,
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Email",
                  title: R.string.email,
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Remove",
                  title: R.string.remove,
                  color: Colors.red)
            ],
          );
        });
  }
}
