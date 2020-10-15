import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/qr_scan/qr_scan_page_bloc.dart';
import 'package:repairservices/ui/qr_scan/qr_scan_widget.dart';

import '../../ArticleDetails.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends StateWithBloC<QRScanPage, QRScanPageBloc> {
  GlobalKey key = new GlobalKey();

  @override
  void initState() {
    super.initState();

    bloc.scanResultStream.listen((result) {
      if (result == null) {
        showInSnackBar(R.string.connectionProblems);
        bloc.initCamera();
      } else {
        NavigationUtils.push(context, ArticleDetailsV(result, false)).then((value) => bloc.initCamera());
      }
    });

    bloc.initCamera();
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

  Future onScan(String value) async {
    print("QR Scan: $value");
    bloc.getArticleDetails(value);
  }

  Widget _getQRScanTab() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<bool>(
        stream: bloc.showCameraResult,
        initialData: true,
        builder: (context, snapshot) {
          return snapshot.data
              ? QrCodeReaderView(
                  onScan: onScan,
                  initialOrientation: MediaQuery.of(context).orientation,
                )
              : Center(
                  child: Text('Getting Article details...'),
                );
        },
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.isLoadingStream,
      initialData: false,
      builder: (context, snapshot) {
        return ModalProgressHUD(
          inAsyncCall: snapshot.data,
          progressIndicator: CupertinoActivityIndicator(radius: 20),
          child: TXMainBarWidget(
            title: "QR Scan",
            onLeadingTap: () {
              NavigationUtils.pop(context);
            },
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: _getQRScanTab(),
            ),
          ),
        );
      },
    );
  }

  void showInSnackBar(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}
