import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_action_sheet_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/fitting_detail/fitting_resource_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_bloc.dart';
import 'package:repairservices/ui/fitting_dimensions/sliding/fitting_sliding_dimension_page.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

class FittingSlidingDetailPage extends StatefulWidget {
  final Sliding model;

  const FittingSlidingDetailPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingSlidingDetailState();
}

class _FittingSlidingDetailState
    extends StateWithBloC<FittingSlidingDetailPage, FittingWindowsBloC> {
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
          child: Column(children: <Widget>[
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Year of construction",
              value: widget.model.year,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Fitting manufacturer",
              value: widget.model.manufacturer,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Direction opening",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: "Direction opening",
                      resourceTitle:
                          (widget.model.directionOpening.contains("1") ||
                                  widget.model.directionOpening.contains("3")
                              ? "Right"
                              : "Left"),
                      resource: bloc
                          .getDirectionOpening(widget.model.directionOpening),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Material",
              value: widget.model.material,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "System",
              value: widget.model.system,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Vent overlap (mm)",
              value: widget.model.directionOpening,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Tilt / sliding fittings",
              value: widget.model.tiltSlide,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Dimensions",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingSlidingDimensionPage(
                      model: widget.model,
                      isEditable: false,
                    ));
              },
            ),
            TXDividerWidget(),
          ]),
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
                Future.delayed(Duration(milliseconds: 100), () {
                  NavigationUtils.pushCupertino(
                      context,
                      FittingPDFViewerPage(
                        navigateFromDetail: true,
                        model: widget.model,
                        isForMail: action.key == 'Email',
                        isForPrint: action.key == 'Print',
                      ));
                });
              } else if (action.key == 'Remove') {
                bloc.delete(widget.model);
              }
            },
            actions: [
              ActionSheetModel(
                  key: "Print", title: "Print", color: R.color.primary_color),
              ActionSheetModel(
                  key: "Email", title: "Email", color: R.color.primary_color),
              ActionSheetModel(
                  key: "Remove", title: "Remove", color: Colors.red)
            ],
          );
        });
  }
}
