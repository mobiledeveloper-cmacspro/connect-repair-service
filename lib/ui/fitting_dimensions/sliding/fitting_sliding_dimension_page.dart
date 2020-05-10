import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/fitting_dimensions/sliding/fitting_sliding_dimension_bloc.dart';

class FittingSlidingDimensionPage extends StatefulWidget {
  final Sliding model;
  final bool isEditable;

  const FittingSlidingDimensionPage({Key key, this.model, this.isEditable})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingDimensionSlidingState();
}

class _FittingDimensionSlidingState extends StateWithBloC<
    FittingSlidingDimensionPage, FittingSlidingDimensionBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double offSetW = screenW - bloc.widthArea;
    return Stack(
      children: <Widget>[
        TXMainBarWidget(
          title: "Sliding dimension",
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
//                      border: Border.all(
//                          width: 1, color: R.color.gray_darkest)),
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
                      _getCellsPage1(),
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
      R.image.slidingDimension,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  Widget _getCellsPage1() {
    final cellEditMode =
        widget.isEditable ? CellEditMode.input : CellEditMode.detail;
    return Column(
      children: <Widget>[
        TXItemCellEditWidget(
          value: widget.model?.dimensionA ?? '',
          title: "A",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model?.dimensionB ?? '',
          title: "B",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model?.dimensionC ?? '',
          title: "C",
          cellEditMode: cellEditMode,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model?.dimensionD ?? '',
          title: "D",
          cellEditMode: cellEditMode,
        ),
      ],
    );
  }
}
