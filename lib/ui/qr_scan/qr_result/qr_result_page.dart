import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/bloc_state.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_button_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_text_widget.dart';
import 'package:repairservices/ui/qr_scan/qr_result/qr_result_page_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../ArticleDetails.dart';

class QRResultPage extends StatefulWidget {
  final String value;

  QRResultPage({this.value});

  @override
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends StateWithBloC<QRResultPage, QRResultPageBloc> {
  GlobalKey key = new GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc.getArticleDetails(widget.value);
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
            title: "QR Scan Result",
            onLeadingTap: () {
              NavigationUtils.pop(context);
            },
            body: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.qr_code_outlined,
                        size: 100,
                        color: R.color.primary_dark_color,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TXTextWidget(
                              text: 'URL',
                              size: 20,
                              color: R.color.primary_dark_color,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: _launchURL,
                              child: TXTextWidget(
                                text: widget.value,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  StreamBuilder<Product>(
                      initialData: null,
                      stream: bloc.productStream,
                      builder: (context, snapshot) {
                        return Center(
                          child: TXButtonWidget(
                            title: R.string.articleDetails,
                            onPressed: snapshot.data != null
                                ? () {
                                    NavigationUtils.push(context,
                                        ArticleDetailsV(snapshot.data, false));
                                  }
                                : null,
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _launchURL() async {
    if (await canLaunch(widget.value)) {
      await launch(widget.value);
    } else {
      print('Could not launch ${widget.value}');
    }
  }

  void showInSnackBar(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}
