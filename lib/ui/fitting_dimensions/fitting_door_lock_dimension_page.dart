import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';

class FittingDoorLockDimensionPage extends StatefulWidget {
  final DoorLock doorLock;
  final bool isEditable;

  const FittingDoorLockDimensionPage({Key key, this.doorLock, this.isEditable})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FittingDoorLockDimensionState();
}

class _FittingDoorLockDimensionState
    extends State<FittingDoorLockDimensionPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainBarWidget(
          title: "Lock dimensions",
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
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: R.color.gray_darkest)),
                    width: 300,
                    height: 450,
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
                      TXItemCellEditWidget(
                        value: "temp",
                        title: "A",
                        cellEditMode: CellEditMode.input,
                        textInputAction: TextInputAction.next,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        value: "temp",
                        title: "A",
                        cellEditMode: CellEditMode.input,
                        textInputAction: TextInputAction.next,
                      ),
                      TXDividerWidget(),
                      TXItemCellEditWidget(
                        value: "temp",
                        title: "A",
                        cellEditMode: CellEditMode.input,
                      ),
                      TXDividerWidget(),
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
}
