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
import 'package:repairservices/ui/fitting_windows/fitting_windows_bloc.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

class FittingWindowsDetail extends StatefulWidget {
  final Windows model;
  final TypeFitting typeFitting;

  const FittingWindowsDetail({Key key, this.model, this.typeFitting})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingWindowsDetails();
}

class _FittingWindowsDetails
    extends StateWithBloC<FittingWindowsDetail, FittingWindowsBloC> {
  DatabaseHelper helper = DatabaseHelper.instance;

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
                title: FlutterI18n.translate(
                    context, 'Part number of defective component'),
                value: widget.model.number.toString(),
              ),
              TXDividerWidget(),
              TXItemCellEditWidget(
                title: FlutterI18n.translate(context, 'Year of construction'),
                value: widget.model.year,
              ),
              widget.typeFitting == TypeFitting.other ||
                      widget.typeFitting == TypeFitting.windows
                  ? Column(
                      children: <Widget>[
                        TXDividerWidget(),
                        TXItemCellEditWidget(
                          title: FlutterI18n.translate(
                              context, 'System depth (mm)'),
                          value: widget.model.systemDepth,
                        ),
                        TXDividerWidget(),
                        TXItemCellEditWidget(
                          title: FlutterI18n.translate(
                              context, 'Profile system / -serie'),
                          value: widget.model.profileSystem,
                        ),
                      ],
                    )
                  : Container(),
              TXDividerWidget(),
              TXItemCellEditWidget(
                title: FlutterI18n.translate(context, 'Description'),
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
                        Fluttertoast.showToast(msg: "Under construction");
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
              if (action.key == 'Print') {
                Fluttertoast.showToast(
                    msg: "Under construction...",
                    toastLength: Toast.LENGTH_LONG);
              } else if (action.key == 'Email') {
                Future.delayed(Duration(milliseconds: 100), () {
                  NavigationUtils.push(
                      context,
                      FittingPDFViewerPage(
                        model: widget.model,
                      ));
                });
              } else if (action.key == 'Remove') {
                await helper.deleteWindows(widget.model.id);
                await PDFManagerWindow.removePDF(widget.model);
                NavigationUtils.pop(context);
              }
            },
            actions: [
              ActionSheetModel(
                  key: "Print",
                  title: "Print",
                  color: Theme.of(context).primaryColor),
              ActionSheetModel(
                  key: "Email",
                  title: "Email",
                  color: Theme.of(context).primaryColor),
              ActionSheetModel(
                  key: "Remove", title: "Remove", color: Colors.red)
            ],
          );
        });
  }
}
