import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/models/DoorLock.dart';
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
import 'package:repairservices/ui/fitting_dimensions/door_lock/fitting_door_lock_dimension_page.dart';
import 'package:repairservices/ui/pdf_viewer/fitting_pdf_viewer_page.dart';

class FittingDoorLockDetailPage extends StatefulWidget {
  final DoorLock model;

  const FittingDoorLockDetailPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingDoorLockDetailState();
}

class _FittingDoorLockDetailState
    extends StateWithBloC<FittingDoorLockDetailPage, FittingWindowsBloC> {
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
              title: "Schüco logo visible on face plate",
              value: widget.model.logoVisible,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Profile insulations",
              value: widget.model.profile,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Basic depth of the door profile (mm)",
              value: widget.model.basicDepthDoor,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Opening direction",
              value: widget.model.openingDirection,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Leaf",
              value: widget.model.leafDoor,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "DIN direction",
              value: widget.model.dinDirection,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Type",
              value: widget.model.type,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Panic function",
              value: widget.model.panicFunction,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Electric strike",
              value: widget.model.electricStrike,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "Lock with top locking",
              value: widget.model.lockWithTopLocking,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Lock type",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: "Lock type",
                      resourceTitle: "",
                      resource: bloc.getLockType(widget.model.lockType),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Face plate type",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: "Face plate type",
                      resourceTitle: "",
                      resource:
                          bloc.getFacePlateType(widget.model.facePlateType),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Face plate fixing",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: "Face plate fixing",
                      resourceTitle: "",
                      resource:
                          bloc.getFacePlateMixing(widget.model.facePlateFixing),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: "Dimensions",
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingDoorLockDimensionPage(
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
