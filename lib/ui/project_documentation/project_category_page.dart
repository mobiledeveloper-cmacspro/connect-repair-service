import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cell_check_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

enum CategoryType { project, report }

class ProjectCategoryPage extends StatefulWidget {
  final String currentCategory;
  final CategoryType categoryType;

  ProjectCategoryPage({this.currentCategory, @required this.categoryType});

  @override
  _ProjectCategoryPageState createState() => _ProjectCategoryPageState();
}

class _ProjectCategoryPageState extends State<ProjectCategoryPage> {
  String selectValue = '';

  @override
  void initState() {
    super.initState();
    selectValue = widget.currentCategory ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TXMainBarWidget(
        title: R.string.categories,
        onLeadingTap: () {
          NavigationUtils.pop(context, result: selectValue);
        },
        actions: [
          InkWell(
            onTap: () {
              NavigationUtils.pop(context, result: selectValue);
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
        body: Column(
          children: [TXDividerWidget(), _body()],
        ));

    Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
          title: Text('Project Category',
              style: Theme.of(context).textTheme.bodyText2),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              NavigationUtils.pop(context, result: selectValue);
            },
            color: Theme.of(context).primaryColor,
          ),
          actions: [
            InkWell(
              onTap: () {
                NavigationUtils.pop(context, result: selectValue);
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
        body: _body());
  }

  _body() {
    final List<String> list = [];
    widget.categoryType == CategoryType.project
        ? list.addAll([
            R.string.renovation,
            R.string.newBuild,
            R.string.maintenanceRepair
          ])
        : list.addAll([
            R.string.generalReport,
            R.string.jobSiteInstruction,
            R.string.jobSiteInspection,
            R.string.defectReport,
            R.string.acceptanceOfConstructionWork
          ]);
    return Expanded(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return item(list[index]);
          }),
    );
  }

  item(String category) {
    return InkWell(
      onTap: () {
        setState(() {
          if (selectValue == category)
            selectValue = '';
          else
            selectValue = category;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TXTextWidget(
                    text: category,
                  ),
                ),
                Container(
                  child: selectValue == category
                      ? Image.asset(
                          'assets/check_filled.png',
                          width: 25,
                          height: 25,
                        )
                      : Container(),
                )
              ],
            ),
          ),
          TXDividerWidget()
        ],
      ),
    );
  }
}
