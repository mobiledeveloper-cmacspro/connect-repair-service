import 'package:flutter/material.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';

class FittingResourcePage extends StatelessWidget {
  final String title;
  final String resourceTitle;
  final String resource;

  const FittingResourcePage(
      {Key key, this.title, this.resourceTitle, this.resource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TXMainBarWidget(
      title: title,
      onLeadingTap: (){
        NavigationUtils.pop(context);
      },
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TXDividerWidget(),
            SizedBox(height: 10,),
            TXTextWidget(text: resourceTitle,),
            SizedBox(height: 10,),
            Image.asset(resource)
          ],
        ),
      ),
    );
  }
}
