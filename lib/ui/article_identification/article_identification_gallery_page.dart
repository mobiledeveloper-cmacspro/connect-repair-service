import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/domain/article_base.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/models/DoorHinge.dart';
import 'package:repairservices/models/DoorLock.dart';
import 'package:repairservices/models/Sliding.dart';
import 'package:repairservices/models/Windows.dart';
import 'package:repairservices/res/R.dart';
import 'package:repairservices/ui/0_base/navigation_utils.dart';
import 'package:repairservices/ui/1_tx_widgets/tx_main_bar_widget.dart';
import 'package:repairservices/ui/article_detail/article_detail_page.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_door_hinge_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_door_lock_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_sliding_detail_page.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_detail_page.dart';

import '../../DoorLockData.dart';

class ArticleIdentificationGalleryPage extends StatelessWidget {
  final List<ArticleBase> articles;

  const ArticleIdentificationGalleryPage({Key key, this.articles = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TXMainBarWidget(
      title: R.string.articleGallery,
      onLeadingTap: () {
        NavigationUtils.pop(context);
      },
      body: GridView.count(
        crossAxisCount: 3,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: <Widget>[..._articlesList(context)],
      ),
    );
  }

  List<Widget> _articlesList(BuildContext context) {
    List<Widget> list = [];
    articles.forEach((a) {
      final w = a is ArticleLocalModel
          ? _getLocalArticle(context, a)
          : _getFittings(context, a as Fitting);

      list.add(w);
    });
    return list;
  }

  Widget _getFittings(BuildContext context, Fitting fitting) {
    String img = R.image.windowsSunShading;
    if (fitting is DoorHinge) img = R.image.doorHinge;
    if (fitting is DoorLock) img = R.image.doorLock;
    if (fitting is Sliding) img = R.image.sliding;
    if (fitting is Windows && (fitting?.systemDepth?.isNotEmpty == true))
      img = R.image.windowsOther;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: Image.asset(
          img,
          fit: BoxFit.contain,
        ),
        onTap: () async {
          if (fitting is Windows) {
            await NavigationUtils.pushCupertino(
              context,
              FittingWindowsDetailPage(
                model: fitting,
                typeFitting: fitting.systemDepth?.isNotEmpty == true
                    ? TypeFitting.windows
                    : TypeFitting.sunShading,
              ),
            );
          } else if (fitting is Sliding) {
            await NavigationUtils.pushCupertino(
              context,
              FittingSlidingDetailPage(
                model: fitting,
              ),
            );
          } else if (fitting is DoorLock) {
            await NavigationUtils.pushCupertino(
              context,
              FittingDoorLockDetailPage(
                model: fitting,
              ),
            );
          } else if (fitting is DoorHinge) {
            await NavigationUtils.pushCupertino(
              context,
              FittingDoorHingeDetailPage(
                model: fitting,
              ),
            );
          } else {
            Fluttertoast.showToast(
                msg: R.string.objectNotRecognized
            );
          }
        },
      ),
    );
  }

  Widget _getLocalArticle(
      BuildContext context, ArticleLocalModel articleLocalModel) {
    return Container(
      child: InkWell(
        onTap: () {
          NavigationUtils.pushCupertino(
            context,
            ArticleLocalDetailPage(
              articleLocalModel: articleLocalModel,
              isForMail: true,
              navigateFromDetail: true,
            ),
          );
        },
        child: Image.file(File(articleLocalModel.filePath)),
      ),
    );
  }
}
