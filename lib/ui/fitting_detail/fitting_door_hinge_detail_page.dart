import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
import 'package:repairservices/ui/fitting_detail/fitting_resource_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_bloc.dart';
import 'package:repairservices/ui/fitting_dimensions/door_hinge/fitting_door_hinge_dimension_page.dart';
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
              title: FlutterI18n.translate(context, 'Year of construction'),
              value: widget.model.year,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(
                  context, 'Basic depth of the door leaf (mm)'),
              value: widget.model.basicDepthOfDoorLeaf,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(
                  context, 'System'),
              value: widget.model.systemHinge,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Material'),
              value: widget.model.material,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Thermally'),
              value: widget.model.thermally,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Door opening'),
              value: widget.model.doorOpening,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Fitted'),
              value: widget.model.fitted,
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: "",
              value: FlutterI18n.translate(context, 'Dimensions'),
              cellEditMode: CellEditMode.selector,
              onSubmitted: (value) {
                NavigationUtils.pushCupertino(
                  context,
                  FittingDoorHingeDimensionPage(
                    model: widget.model,
                    isEditable: false,
                    dimensionType: DoorHingeDimensionType.surface,
                  ),
                );
              },
            ),
            TXDividerWidget(),
            TXItemCellEditWidget(
              title: FlutterI18n.translate(context, 'Hinge type'),
              value: widget.model.hingeType,
            ),
            TXDividerWidget(),

            _getHingeTypeCells(),

            TXDividerWidget(),
          ]),
        ),
      ),
    );
  }

  Widget _getHingeTypeCells(){
    if(widget.model.hingeType == FlutterI18n.translate(context, 'Barrel hinge')){
      return Column(children: <Widget>[
        TXItemCellEditWidget(
          title: FlutterI18n.translate(context, 'Door leaf (mm)'),
          value: widget.model.doorLeafBarrel,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          title: FlutterI18n.translate(context, 'System'),
          value: widget.model.systemDoorLeaf,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          title: FlutterI18n.translate(context, 'Door frame (mm)'),
          value: widget.model.doorFrame,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          title: FlutterI18n.translate(context, 'System'),
          value: widget.model.systemDoorFrame,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          title: "",
          value: FlutterI18n.translate(context, 'Dimensions'),
          cellEditMode: CellEditMode.selector,
          onSubmitted: (value) {
            NavigationUtils.pushCupertino(
              context,
              FittingDoorHingeDimensionPage(
                model: widget.model,
                isEditable: false,
                dimensionType: DoorHingeDimensionType.barrel,
              ),
            );
          },
        ),
      ],);
    }else if(widget.model.hingeType ==
        FlutterI18n.translate(context, 'Surface-mounted door hinge')){

      return Column(
        children: <Widget>[
          TXItemCellEditWidget(
            title: "",
            value: FlutterI18n.translate(context, 'Door hinge details'),
            cellEditMode: CellEditMode.selector,
            onSubmitted: (value) {
              NavigationUtils.pushCupertino(
                  context,
                  FittingResourcePage(
                    title: FlutterI18n.translate(context, 'Door hinge details'),
                    resourceTitle: "",
                    resource: bloc.getSurfaceType(widget.model.doorHingeDetailsIm),
                  ));
            },
          ),
          TXDividerWidget(),
          TXItemCellEditWidget(
            title: FlutterI18n.translate(context, 'Cover caps of the door hinge'),
            value: widget.model.coverCaps,
          ),
        ],
      );
    }else{
      return Container();
    }
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
