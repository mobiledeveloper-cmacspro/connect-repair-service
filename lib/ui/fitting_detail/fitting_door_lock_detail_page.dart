import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
              title: FlutterI18n.translate(
                  context, 'Schüco logo visible on face plate'),
              value: widget.model.logoVisible,
            ),
            widget.model.year.trim().isNotEmpty
                ? Column(
                    children: <Widget>[
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: FlutterI18n.translate(
                            context, 'Year of manufactoring'),
                        value: widget.model.year,
                      ),
                    ],
                  )
                : Container(),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Profile insulations'),
              value: widget.model.profile,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(
                  context, 'Basic depth of the door profile (mm)'),
              value: widget.model.basicDepthDoor,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Opening direction'),
              value: widget.model.openingDirection,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Leaf'),
              value: widget.model.leafDoor,
            ),
            widget.model.leafDoor != 'Single'
                ? Column(
                    children: <Widget>[
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: FlutterI18n.translate(context, 'Bolt'),
                        value: widget.model.bolt,
                      ),
                    ],
                  )
                : Container(),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'DIN direction'),
              value: widget.model.dinDirection,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Type'),
              value: widget.model.type,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Panic function'),
              value: widget.model.panicFunction,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Electric strike'),
              value: widget.model.electricStrike,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Lock with top locking'),
              value: widget.model.lockWithTopLocking,
            ),
            TXDividerWidget(),
            widget.model.lockWithTopLocking == 'Yes'
                ? Column(
                    children: <Widget>[
                      TXItemCellEditWidget(
                        title:
                            FlutterI18n.translate(context, 'Shoot bolt lock'),
                        value: widget.model.shootBoltLock,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: FlutterI18n.translate(context, 'Handle height'),
                        value: widget.model.handleHeight,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title:
                            FlutterI18n.translate(context, 'Door leaf height'),
                        value: widget.model.doorLeafHight,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: FlutterI18n.translate(context, 'Restrictor'),
                        value: widget.model.restrictor,
                      ),
                    ],
                  )
                : Container(),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: FlutterI18n.translate(context, 'Lock type'),
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: FlutterI18n.translate(context, 'Lock type'),
                      resourceTitle: "",
                      resource: bloc.getLockType(widget.model.lockType),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: FlutterI18n.translate(context, 'Face plate type'),
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: FlutterI18n.translate(context, 'Face plate type'),
                      resourceTitle: "",
                      resource:
                          bloc.getFacePlateType(widget.model.facePlateType),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: FlutterI18n.translate(context, 'Face plate fixing'),
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title:
                          FlutterI18n.translate(context, 'Face plate fixing'),
                      resourceTitle: "",
                      resource:
                          bloc.getFacePlateMixing(widget.model.facePlateFixing),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: FlutterI18n.translate(context, 'Dimensions'),
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
                  key: "Print",
                  title: FlutterI18n.translate(context, 'Print'),
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Email",
                  title: FlutterI18n.translate(context, 'Email'),
                  color: R.color.primary_color),
              ActionSheetModel(
                  key: "Remove",
                  title: FlutterI18n.translate(context, 'Remove'),
                  color: Colors.red)
            ],
          );
        });
  }
}
