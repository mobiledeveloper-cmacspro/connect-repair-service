import 'package:flutter/cupertino.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';

class ProjectReportPage extends StatefulWidget {

  const ProjectReportPage({Key key,}) : super(key: key);
  @override
  _ProjectReportPageState createState() => _ProjectReportPageState();
}

class _ProjectReportPageState extends State<ProjectReportPage> {

  @override
  Widget build(BuildContext context) {
    return TXMainBarWidget(title: R.string.newReport, body: Container());
  }
}
