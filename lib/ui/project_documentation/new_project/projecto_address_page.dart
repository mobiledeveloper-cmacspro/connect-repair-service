import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';

class ProjectAddressPage extends StatefulWidget {
  final String currentAddress;

  const ProjectAddressPage({Key key, this.currentAddress}) : super(key: key);

  @override
  _ProjectAddressPageState createState() => _ProjectAddressPageState();
}

class _ProjectAddressPageState extends State<ProjectAddressPage> {
  var streetController = TextEditingController();
  var numberController = TextEditingController();
  var extraController = TextEditingController();
  var postCodeController = TextEditingController();
  var locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TXMainBarWidget(
        title: R.string.address,
        onLeadingTap: () {
          NavigationUtils.pop(context);
        },
        actions: [
          InkWell(
            onTap: () {
              final newAddress = "";
              NavigationUtils.pop(context, result: newAddress);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                R.image.checkGreen,
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TXItemCellEditWidget(
                  title: R.string.street,
                  controller: streetController,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.street} ${R.string.additions.toLowerCase()}",
                  onChanged: (address){

                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.houseNumber,
                  controller: numberController,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.houseNumber} ${R.string.additions.toLowerCase()}",
                  onChanged: (address){

                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.extraAddressLine,
                  controller: extraController,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.extraAddressLine} ${R.string.additions.toLowerCase()}",
                  onChanged: (address){

                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.postcode,
                  controller: postCodeController,
                  keyboardType: TextInputType.number,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.postcode} ${R.string.additions.toLowerCase()}",
                  onChanged: (address){

                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.location,
                  controller: locationController,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.location} ${R.string.additions.toLowerCase()}",
                  onChanged: (address){

                  },
                ),
                TXDividerWidget(),
              ],
            ),
          ),
        ));
  }
}
