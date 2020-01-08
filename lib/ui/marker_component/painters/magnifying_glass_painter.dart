import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MagnifyingGlassPainter extends CustomPainter {
  final Offset position;
  final Offset maxPosition;
  final ui.Image image;
  final double circleSize;
  final double circleScale;
  Offset magnifyingGlassPosition;
  Paint _paint;
  Paint _paintBackground;

  MagnifyingGlassPainter({
    @required this.position,
    @required this.image,
    this.maxPosition,
    this.circleSize = 60,
    this.circleScale = 2,
  }) {
    final center = circleSize + 10;
    magnifyingGlassPosition = Offset(center, center);

    Matrix4 matrix = Matrix4.identity();
    matrix.scale(circleScale, circleScale);

    var translationOffset = Offset(
      min<double>(0, -1 * (position.dx - (center / circleScale))),
      min<double>(0, -1 * (position.dy - (center / circleScale))),
    );

    if (maxPosition != null) {
      translationOffset = Offset(
        max<double>(translationOffset.dx, -1 * (maxPosition.dx - center)),
        max<double>(translationOffset.dy, -1 * (maxPosition.dy - center)),
      );
    }

    matrix.translate(
      translationOffset.dx,
      translationOffset.dy,
    );

    this._paint = Paint()
      ..color = Colors.black
      ..shader = ImageShader(
        image,
        TileMode.clamp,
        TileMode.clamp,
        matrix.storage,
      );
    this._paintBackground = Paint()..color = Colors.black;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        magnifyingGlassPosition, circleSize + 2, _paintBackground);
    canvas.drawCircle(magnifyingGlassPosition, circleSize, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
