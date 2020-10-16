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
import 'package:repairservices/utils/mail_mananger.dart';

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
      title: widget.model.getNamei18N,
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
              title: R.string.schucoLogoVisibleOnFacePlate,
              value: widget.model.logoVisible,
            ),
            widget.model.year.trim().isNotEmpty
                ? Column(
                    children: <Widget>[
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.yearOfManufacturing,
                        value: widget.model.year,
                      ),
                    ],
                  )
                : Container(),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.profileInsulation,
              value: widget.model.profile,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.basicDepthDoorProfileMM,
              value: widget.model.basicDepthDoor,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.openingDirection,
              value: widget.model.openingDirection,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.leaf,
              value: widget.model.leafDoor,
            ),
            widget.model.leafDoor != 'Single'
                ? Column(
                    children: <Widget>[
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.bolt,
                        value: widget.model.bolt,
                      ),
                    ],
                  )
                : Container(),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.dinDirection,
              value: widget.model.dinDirection,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.type,
              value: widget.model.type,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.panicFunction,
              value: widget.model.panicFunction,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.electricStrike,
              value: widget.model.electricStrike,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: R.string.lockTopLocking,
              value: widget.model.lockWithTopLocking,
            ),
            TXDividerWidget(),
            widget.model.lockWithTopLocking == 'Yes'
                ? Column(
                    children: <Widget>[
                      TXItemCellEditWidget(
                        title:
                            R.string.shootBoltLock,
                        value: widget.model.shootBoltLock,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.handleHeight,
                        value: widget.model.handleHeight,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title:
                            R.string.doorLeafHeight,
                        value: widget.model.doorLeafHight,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        title: R.string.restrictor,
                        value: widget.model.restrictor,
                      ),
                    ],
                  )
                : Container(),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: R.string.lockType,
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: R.string.lockType,
                      resourceTitle: "",
                      resource: bloc.getLockType(widget.model.lockType),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: R.string.facePlateType,
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title: R.string.facePlateType,
                      resourceTitle: "",
                      resource:
                          bloc.getFacePlateType(widget.model.facePlateType),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: R.string.facePlateFixing,
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                    context,
                    FittingResourcePage(
                      title:
                        R.string.facePlateFixing,
                      resourceTitle: "",
                      resource:
                          bloc.getFacePlateMixing(widget.model.facePlateFixing),
                    ));
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: R.string.dimensions,
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
                NavigationUtils.pop(context);
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

  @override
  void dispose() {
    super.dispose();
  }
}
