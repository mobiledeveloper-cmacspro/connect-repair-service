import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/domain/project_documentation/project_documentation.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cell_check_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_gesture_hide_key_board.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_item_cell_edit_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_textfield_widget.dart';
import 'package:repairservices/ui/project_documentation/new_project/new_project_documentation_bloc.dart';
import 'package:repairservices/ui/project_documentation/new_project/project_category_page.dart';
import 'package:repairservices/ui/project_documentation/new_project/projecto_address_page.dart';

class NewProjectDocumentationPage extends StatefulWidget {
  final ProjectDocumentationModel model;

  NewProjectDocumentationPage({this.model});

  @override
  _NewProjectDocumentationPageState createState() =>
      _NewProjectDocumentationPageState();
}

class _NewProjectDocumentationPageState extends StateWithBloC<
    NewProjectDocumentationPage, NewProjectDocumentationBloC> {
  @override
  void initState() {
    super.initState();
    bloc.stream.listen((event) {
      if (event) NavigationUtils.pop(context);
    });
    if (widget.model != null) _initData();
  }

  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var abbreviationController = TextEditingController();
  var addressController = TextEditingController();
  var participantsController = TextEditingController();
  var totalCostsController = TextEditingController();
  String category;
  var infoController = TextEditingController();

  _initData() {
    nameController.text = widget.model.name;
    numberController.text = widget.model.number;
    abbreviationController.text = widget.model.abbreviation;
    addressController.text = widget.model.address;
    participantsController.text = widget.model.participants;
    totalCostsController.text = widget.model.totalCosts;
    category = widget.model.category;
    infoController.text = widget.model.info;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title:
            Text('New Project', style: Theme.of(context).textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Theme.of(context).primaryColor,
        ),
        actions: [
          InkWell(
            onTap: () {
              _safeProject();
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
      ),
      body: TXGestureHideKeyBoard(
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) => Container(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    // Stack(
                    //   children: [
                    //     TXTextFieldWidget(
                    //       placeholder: 'Project name',
                    //       fontSize: 18,
                    //       controller: nameController,
                    //     ),
                    //     Align(
                    //       alignment: Alignment.centerRight,
                    //       child: TXTextWidget(
                    //         text: '*',
                    //         color: Colors.red,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // TXDividerWidget(),
                    TXItemCellEditWidget(
                      title: R.string.projectName,
                      isMandatory: true,
                      controller: nameController,
                      cellEditMode: CellEditMode.input,
                      placeholder:
                          "${R.string.projectName} ${R.string.additions.toLowerCase()}",
                    ),
                    TXDividerWidget(),
                    TXItemCellEditWidget(
                      title: R.string.projectNumber,
                      controller: numberController,
                      cellEditMode: CellEditMode.input,
                      keyboardType: TextInputType.number,
                      placeholder:
                          "${R.string.projectNumber} ${R.string.additions.toLowerCase()}",
                    ),
                    TXDividerWidget(),
                    // TXTextFieldWidget(
                    //   placeholder: 'Project number',
                    //   fontSize: 18,
                    //   controller: numberController,
                    // ),
                    // _separator(),
                    TXItemCellEditWidget(
                      title: R.string.projectShortName,
                      controller: abbreviationController,
                      cellEditMode: CellEditMode.input,
                      placeholder:
                          "${R.string.projectShortName} ${R.string.additions.toLowerCase()}",
                    ),
                    TXDividerWidget(),
                    // TXTextFieldWidget(
                    //   placeholder: 'Project abbreviation',
                    //   fontSize: 18,
                    //   controller: abbreviationController,
                    // ),
                    // _separator(),
                    TXItemCellEditWidget(
                      title: R.string.address,
                      placeholder:
                          "${R.string.address} ${R.string.additions.toLowerCase()}",
                      controller: addressController,
                      value: addressController.text,
                      cellEditMode: CellEditMode.selector,
                      onSubmitted: (addresValue) {
                        NavigationUtils.pushCupertino(
                                context, ProjectAddressPage())
                            .then((newAddress) {
                          setState(() {
                            addressController.text = newAddress;
                          });
                        });
                      },
                    ),
                    TXDividerWidget(),
                    // TXTextFieldWidget(
                    //   placeholder: 'Address',
                    //   fontSize: 18,
                    //   controller: addressController,
                    // ),
                    // _separator(),
                    TXItemCellEditWidget(
                      title: R.string.participants,
                      controller: participantsController,
                      cellEditMode: CellEditMode.input,
                      placeholder: R.string.nothingDeposited,
                    ),
                    TXDividerWidget(),
                    // TXTextFieldWidget(
                    //   placeholder: 'Participants',
                    //   fontSize: 18,
                    //   controller: participantsController,
                    // ),
                    // _separator(),
                    TXItemCellEditWidget(
                      title: R.string.totalCost,
                      controller: totalCostsController,
                      cellEditMode: CellEditMode.input,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      placeholder: R.string.nothingDeposited,
                    ),
                    TXDividerWidget(),
                    // TXTextFieldWidget(
                    //   placeholder: 'Total costs',
                    //   fontSize: 18,
                    //   controller: totalCostsController,
                    // ),
                    // _separator(),
                    // _selectNavigationItem('Photo', () {
                    //   Fluttertoast.showToast(msg: 'Under Construction');
                    // }),
                    TXItemCellEditWidget(
                      title: "",
                      value: R.string.photo,
                      cellEditMode: CellEditMode.selector,
                      onSubmitted: (valueSubmitted) {
                        Fluttertoast.showToast(msg: 'Under Construction');
                      },
                    ),
                    TXDividerWidget(),
                    TXItemCellEditWidget(
                      title: "",
                      value: R.string.categories,
                      cellEditMode: CellEditMode.selector,
                      onSubmitted: (valueSubmitted) {
                        NavigationUtils.pushCupertino(
                            context,
                            ProjectCategoryPage(
                              currentCategory: category,
                            )).then((value) {
                          category = value;
                        });
                      },
                    ),
                    TXDividerWidget(),
                    // _separator(),
                    // _selectNavigationItem('Category', () {
                    //   NavigationUtils.push(
                    //       context,
                    //       ProjectCategoryPage(
                    //         currentCategory: category,
                    //       )).then((value) {
                    //     category = value;
                    //   });
                    // }),
                    // _separator(),
                    TXItemCellEditWidget(
                      title: R.string.projectInfo,
                      controller: infoController,
                      cellEditMode: CellEditMode.input,
                      placeholder:
                          "${R.string.projectInfo} ${R.string.additions.toLowerCase()}",
                      multiLine: true,
                    ),
                    TXDividerWidget(),
                    // TXTextFieldWidget(
                    //   placeholder: 'Info about the project',
                    //   fontSize: 18,
                    //   multiLine: true,
                    //   controller: infoController,
                    // ),
                    // _separator(),
                  ],
                ),
              ),
            )),
            Container(
              margin: EdgeInsets.only(bottom: 0),
              height: 70,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TXTextWidget(
                          text: R.string.edit,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TXTextWidget(
                          text: R.string.newReport,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () async {},
                  ),
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.filter_none,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TXTextWidget(
                          text: R.string.reportArchive,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () async {},
                  ),
                  InkWell(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child:
                          new Image.asset('assets/exportWhite.png'),
                        ),
                        TXTextWidget(
                          text: R.string.export,
                          maxLines: 1,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () async {},
                  )
                ],
              ),
            )
          ],
        ),
      );

  _separator() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
            height: 0.7, width: double.maxFinite, color: R.color.gray),
      );

  _selectNavigationItem(String text, Function action) => InkWell(
        onTap: action,
        child: Stack(
          children: [
            Container(
              height: 20,
              width: double.maxFinite,
              child: TXTextWidget(
                text: text,
                color: R.color.gray,
                size: 18,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                CupertinoIcons.chevron_forward,
                color: R.color.primary_color,
              ),
            ),
          ],
        ),
      );

  void _safeProject() {
    if (nameController.text?.isEmpty == true)
      _showDialog(context, 'Error', 'Project name is required');
    else
      bloc.save(ProjectDocumentationModel(
        name: nameController.text,
        abbreviation: abbreviationController.text,
        address: addressController.text,
        category: category,
        info: infoController.text,
        number: numberController.text,
        participants: participantsController.text,
        totalCosts: totalCostsController.text,
        id: widget.model != null ? widget.model.id : null,
      ));
  }

  _showDialog(BuildContext context, String title, String msg) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: msg.isNotEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Text(msg, style: TextStyle(fontSize: 17)),
                    )
                  : Container(),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("OK"),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
