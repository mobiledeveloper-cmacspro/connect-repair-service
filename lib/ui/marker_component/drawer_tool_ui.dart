import 'dart:io';

import 'package:flutter/material.dart';
import 'package:repairservices/di/bloc_provider.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_bloc.dart';
import 'package:repairservices/ui/marker_component/glass_data.dart';
import 'package:repairservices/ui/marker_component/items_data.dart';
import 'package:repairservices/ui/marker_component/painters/drawer_canvas_painter.dart';
import 'package:repairservices/ui/marker_component/painters/magnifying_glass_painter.dart';
import 'package:repairservices/ui/marker_component/utils/take_screenshoot.dart';

class DrawerToolUI extends StatelessWidget {
  final File selectedImage;
  final GlobalKey previewContainer;
  final double topOffset;
  final Color backgroundColor;
  final List<Positioned> memos;

  DrawerToolUI({
    this.selectedImage,
    this.previewContainer,
    this.topOffset = 70,
    this.backgroundColor = Colors.black,
    this.memos = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onPanStart: (d) {
          onTouchUpdate(context, d.globalPosition, EventType.START);
        },
        onPanUpdate: (d) {
          onTouchUpdate(context, d.globalPosition, EventType.UPDATE);
        },
        onPanCancel: () {
          onTouchUpdate(context, null, EventType.END);
        },
        onPanEnd: (d) {
          onTouchUpdate(context, null, EventType.END);
        },
        child: Stack(
          children: [
            RepaintBoundary(
                key: previewContainer,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: backgroundColor,
                  child: Stack(
                    children: [
                      getImageView(),
                      ...memos,
                      getPainter(context),
                    ],
                  ),
                )),
            getMagnifierGlass(context),
          ],
        ),
      ),
    );
  }

  onTouchUpdate(
      BuildContext context, Offset touchedPosition, EventType eventType) async {
    DrawerToolBloc bloc = BlocProvider.of<DrawerToolBloc>(context);

    await bloc.onTouchUpdate(
      touchedPosition?.translate(0, -topOffset),
      eventType,
    );

    bloc.glassData = GlassData(
      circlePosition: touchedPosition,
      previewImage: await getBitmap(
        context: context,
        previewContainer: previewContainer,
      ),
    );
  }

  Widget getImageView() => selectedImage != null
      ? Image.file(
          selectedImage,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.contain,
        )
      : Container();

  Widget getPainter(BuildContext context) => StreamBuilder<ItemsData>(
        stream: BlocProvider.of<DrawerToolBloc>(context).itemsToDrawStream,
        initialData: ItemsData.empty(),
        builder: (c, snapshot) {
          return CustomPaint(
            painter: DrawerCanvasPainter(
              items: snapshot.data.items,
              selectedItem: snapshot.data.selectedItem,
            ),
          );
        },
      );

  Widget getMagnifierGlass(BuildContext context) => StreamBuilder<GlassData>(
        stream: BlocProvider.of<DrawerToolBloc>(context).glassDataStream,
        builder: (c, snapshot) {
          return snapshot.data?.circlePosition != null &&
                  snapshot.data?.previewImage != null
              ? CustomPaint(
                  painter: MagnifyingGlassPainter(
                    position:
                        snapshot.data?.circlePosition?.translate(0, -topOffset),
                    image: snapshot.data?.previewImage,
                    maxPosition: MediaQuery.of(context).size.bottomRight(
                          Offset(0, 0).translate(0, -topOffset),
                        ),
                  ),
                )
              : Container();
        },
      );
}
