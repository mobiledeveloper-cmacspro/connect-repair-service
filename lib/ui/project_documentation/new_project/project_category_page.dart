import 'package:flutter/material.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class ProjectCategoryPage extends StatefulWidget {
  final String currentCategory;

  ProjectCategoryPage({this.currentCategory});

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
    return Scaffold(
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

  _body() => ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      itemCount: categories.length,
      itemBuilder: (context, index) => item(categories[index]));

  item(String category) => InkWell(
        onTap: () {
          setState(() {
            selectValue = category;
          });
        },
        child: Stack(
          children: [
            Container(
              height: 50,
              width: double.maxFinite,
              alignment: Alignment.centerLeft,
              child: TXTextWidget(
                text: category,
                color: R.color.gray,
                size: 18,
              ),
            ),
            if (category?.compareTo(selectValue) == 0)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    R.image.checkGreen,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
          ],
        ),
      );
}

const categories = ['Renovation', 'New Build', 'Maintenance / Repairs'];
