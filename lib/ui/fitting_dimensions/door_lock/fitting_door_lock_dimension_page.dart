import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_page_indicator_widget.dart';
import 'package:repairservices/ui/fitting_dimensions/door_lock/fitting_door_lock_dimension_bloc.dart';

class FittingDoorLockDimensionPage extends StatefulWidget {
  final DoorLock model;
  final bool isEditable;

  const FittingDoorLockDimensionPage(
      {Key key, this.model, this.isEditable = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingDoorLockDimensionState();
}

class _FittingDoorLockDimensionState extends StateWithBloC<
    FittingDoorLockDimensionPage, FittingDoorLockDimensionBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainBarWidget(
          title: "Lock dimensions",
          onLeadingTap: () {
            NavigationUtils.pop(context);
          },
          body: Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (pageIndex) {
                    bloc.setIndicatorPage = pageIndex + 1;
                  },
                  itemBuilder: (ctx, index) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: TXDividerWidget()),
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            child: Container(
//                                decoration: BoxDecoration(
//                                    border: Border.all(
//                                        width: 1, color: R.color.gray_darkest)),
                                width: bloc.widthArea,
                                height: bloc.heightArea,
                                child: Stack(
                                  children: <Widget>[
                                    index == 0
                                        ? Center(
                                            child: _getDimension1(),
                                          )
                                        : index == 1
                                            ? Center(
                                                child: _getDimension2(),
                                              )
                                            : Center(
                                                child: _getDimension3(),
                                              ),
                                  ],
                                )),
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
                                index == 0
                                    ? _getCellsPage1()
                                    : (index == 1
                                        ? _getCellsPage2()
                                        : _getCellsPage3()),
                                TXDividerWidget(),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: 3,
                ),
              ),
              StreamBuilder<int>(
                stream: bloc.pageIndicatorResult,
                initialData: 1,
                builder: (ctx, snapshot) {
                  return TXPageIndicatorWidget(
                    currentSelected: snapshot.data,
                  );
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getDimension1() {
    return Image.asset(
      R.image.lockDimensionPage1,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  Widget _getDimension2() {
    return Image.asset(
      R.image.lockDimensionPage2,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  Widget _getDimension3() {
    return Image.asset(
      R.image.lockDimensionPage3,
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
          value: widget.model.dimensionA,
          title: "A",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model.dimensionB,
          title: "B",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model.dimensionC,
          title: "C",
          cellEditMode: cellEditMode,
        ),
      ],
    );
  }

  Widget _getCellsPage2() {
    final cellEditMode =
        widget.isEditable ? CellEditMode.input : CellEditMode.detail;
    return Column(
      children: <Widget>[
        TXItemCellEditWidget(
          value: widget.model.dimensionD,
          title: "D",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
        TXDividerWidget(),
        TXItemCellEditWidget(
          value: widget.model.dimensionE,
          title: "E",
          cellEditMode: cellEditMode,
        ),
      ],
    );
  }

  Widget _getCellsPage3() {
    final cellEditMode =
        widget.isEditable ? CellEditMode.input : CellEditMode.detail;
    return Column(
      children: <Widget>[
        TXItemCellEditWidget(
          value: widget.model.dimensionF,
          title: "F",
          cellEditMode: cellEditMode,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
