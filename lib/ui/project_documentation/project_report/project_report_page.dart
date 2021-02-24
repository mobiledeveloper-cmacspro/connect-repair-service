import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:repairservices/domain/project_documentation/project_document_models.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_cell_check_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_divider_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/project_documentation/project_report/add_edit_project_report_bloc.dart';
import 'package:repairservices/ui/project_documentation/project_report/add_edit_project_report_page.dart';
import 'package:repairservices/ui/project_documentation/project_report/project_report_bloc.dart';
import 'package:repairservices/utils/calendar_utils.dart';

class ProjectReportPage extends StatefulWidget {
  final ProjectDocumentModel projectDocumentModel;

  const ProjectReportPage({Key key, @required this.projectDocumentModel})
      : super(key: key);

  @override
  _ProjectReportPageState createState() => _ProjectReportPageState();
}

class _ProjectReportPageState
    extends StateWithBloC<ProjectReportPage, ProjectReportBloC> {
  void _navback() {
    NavigationUtils.pop(context, result: bloc.projectDocumentModel);
  }

  @override
  void initState() {
    super.initState();
    bloc.projectDocumentModel = widget.projectDocumentModel;
    bloc.loadProjectReports(bloc.projectDocumentModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navback();
        return false;
      },
      child: TXMainBarWidget(
          title: R.string.reportArchive,
          onLeadingTap: () {
            _navback();
          },
          body: Container(
            child: StreamBuilder<List<ProjectDocumentReportModel>>(
                stream: bloc.projectReportResult,
                initialData: [],
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      TXDividerWidget(),
                      Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (ctx, index) {
                                return _getReport(
                                    context, snapshot.data[index]);
                              }))
                    ],
                  );
                }),
          )),
    );
  }

  Widget _getReport(BuildContext context, ProjectDocumentReportModel report) {
    return Container(
        color: R.color.gray_light,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: Column(
            children: <Widget>[
              TXCellCheckWidget(
                checkMode: CellCheckMode.selector,
                title: report.category,
                subtitle: report.subTitleFixed != null
                    ? CalendarUtils.showInFormat(
                        R.string.dateFormat1, report.date)
                    : report.shortInfo ?? "",
                onTap: () async {
                  NavigationUtils.pushCupertino(
                      context,
                      AddEditProjectReportPage(
                        projectDocumentModel: bloc.projectDocumentModel,
                        projectDocumentReportModel: report,
                      )).then((value) {
                    if (value != null && value is ProjectDocumentModel) {
                      bloc.projectDocumentModel = value;
                      bloc.loadProjectReports(value.id);
                    }
                  });
                },
              ),
              TXDividerWidget()
            ],
          ),
          secondaryActions: [
            IconSlideAction(
              caption: R.string.delete,
              color: Colors.red,
              icon: CupertinoIcons.delete,
              onTap: () {
                bloc.deleteReport(report.projectId, report.id);
              },
            ),
          ],
        ));
  }
}
