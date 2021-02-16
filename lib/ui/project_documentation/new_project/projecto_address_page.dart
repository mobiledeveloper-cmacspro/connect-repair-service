import 'package:flutter/material.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';

class ProjectAddressPage extends StatefulWidget {
  final ProjectDocumentAddressModel currentAddress;

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
  void initState() {
    super.initState();
    streetController.text = widget.currentAddress?.street;
    numberController.text = widget.currentAddress?.houseNumber?.toString() ?? "";
    extraController.text = widget.currentAddress?.extraAddressLine;
    postCodeController.text = widget.currentAddress?.postCode?.toString() ?? "";
    locationController.text = widget.currentAddress?.location;
  }
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
              final newAddress = widget.currentAddress ?? ProjectDocumentAddressModel();
              newAddress.street = streetController.text;
              newAddress.houseNumber = int.tryParse(numberController.text);
              newAddress.extraAddressLine = extraController.text;
              newAddress.postCode = int.tryParse(postCodeController.text);
              newAddress.location = locationController.text;
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
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.street,
                  cellEditMode: CellEditMode.input,
                  controller: streetController,
                  value: streetController.text,
                  placeholder: "${R.string.street} ${R.string.additions.toLowerCase()}",
                  onChanged: (value){
                    streetController.text = value;
                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.houseNumber,
                  controller: numberController,
                  value: numberController.text,
                  keyboardType: TextInputType.number,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.houseNumber} ${R.string.additions.toLowerCase()}",
                  onChanged: (value){
                    numberController.text = value;
                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.extraAddressLine,
                  controller: extraController,
                  multiLine: true,
                  value: extraController.text,
                  cellEditMode: CellEditMode.input,
                  placeholder: "${R.string.extraAddressLine} ${R.string.additions.toLowerCase()}",
                  onChanged: (value){
                    extraController.text = value;
                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.postcode,
                  controller: postCodeController,
                  keyboardType: TextInputType.number,
                  cellEditMode: CellEditMode.input,
                  value: postCodeController.text,
                  placeholder: "${R.string.postcode} ${R.string.additions.toLowerCase()}",
                  onChanged: (value){
                    postCodeController.text = value;
                  },
                ),
                TXDividerWidget(),
                TXItemCellEditWidget(
                  title: R.string.location,
                  controller: locationController,
                  cellEditMode: CellEditMode.input,
                  value: locationController.text,
                  placeholder: "${R.string.location} ${R.string.additions.toLowerCase()}",
                  onChanged: (value){
                    locationController.text = value;
                  },
                ),
                TXDividerWidget(),
              ],
            ),
          ),
        ));
  }
}
