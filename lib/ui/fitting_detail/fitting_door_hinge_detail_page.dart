import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cupertino_action_sheet_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_icon_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_bloc.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

class FittingDoorHingeDetailPage extends StatefulWidget {
  final DoorHinge model;

  const FittingDoorHingeDetailPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingDoorHingeDetailState();
}

class _FittingDoorHingeDetailState
    extends StateWithBloC<FittingDoorHingeDetailPage, FittingWindowsBloC> {
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
              title: "Basic depth of the door leaf (mm)",
              value: widget.model.basicDepthOfDoorLeaf,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Material",
              value: widget.model.material,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Thermally",
              value: widget.model.thermally,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Door opening",
              value: widget.model.doorOpening,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Fitted",
              value: widget.model.fitted,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Dimensions",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {},
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Hinge type",
              value: widget.model.hingeType,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Door leaf (mm)",
              value: widget.model.systemDoorLeaf,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Door frame (mm)",
              value: widget.model.doorFrame,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "System",
              value: widget.model.systemHinge,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Dimensions",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {},
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
