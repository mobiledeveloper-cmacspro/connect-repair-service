import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/fitting_dimensions/door_hinge/fitting_door_hinge_dimension_bloc.dart';

enum DoorHingeDimensionType { barrel, surface }

class FittingDoorHingeDimensionPage extends StatefulWidget {
  final DoorHingeDimensionType dimensionType;
  final DoorHinge model;
  final bool isEditable;

  const FittingDoorHingeDimensionPage(
      {Key key, this.dimensionType, this.model, this.isEditable})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingDoorHingeDimensionState();
}

class _FittingDoorHingeDimensionState extends StateWithBloC<
    FittingDoorHingeDimensionPage, FittingDoorHingeDimensionBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainBarWidget(
          title: "Hinge dimension",
          onLeadingTap: () {
            NavigationUtils.pop(context);
          },
          body: Stack(
            children: <Widget>[
              Positioned(top: 0, right: 0, left: 0, child: TXDividerWidget()),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
//                  decoration: BoxDecoration(
//                      border:
//                          Border.all(width: 1, color: R.color.gray_darkest)),
                  width: bloc.widthArea,
                  height: bloc.heightArea,
                  child: Center(
                    child: _getDimension1(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      TXDividerWidget(),
                      widget.dimensionType == DoorHingeDimensionType.barrel
                          ? _getCellsDimensionBarrel()
                          : _getCellsDimensionSurface(),
                      TXDividerWidget(),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getDimension1() {
    return Image.asset(
      widget.dimensionType == DoorHingeDimensionType.barrel
          ? R.image.hingeDimensionBarrel
          : R.image.hingeDimensionSurface,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  Widget _getCellsDimensionSurface() {
    final cellEditMode =
        widget.isEditable ? CellEditMode.input : CellEditMode.detail;
    return Column(
      children: <Widget>[
        TXItemCellEditWidget(
          value: widget.model?.dimensionsSurfaceA ?? '',
          title: "A",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model?.dimensionsSurfaceB ?? '',
          title: "B",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model?.dimensionsSurfaceC ?? '',
          title: "C",
          cellEditMode: cellEditMode,
        ),
      ],
    );
  }

  Widget _getCellsDimensionBarrel() {
    final cellEditMode =
        widget.isEditable ? CellEditMode.input : CellEditMode.detail;
    return Column(
      children: <Widget>[
        TXItemCellEditWidget(
          value: widget.model?.dimensionsBarrelA ?? '',
          title: "A",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model?.dimensionsBarrelB ?? '',
          title: "B",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
