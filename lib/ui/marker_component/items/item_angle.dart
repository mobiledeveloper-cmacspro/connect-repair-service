import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/items/item_to_draw.dart';
import 'package:repairservices/ui/marker_component/utils/draw_utils.dart';
import 'package:repairservices/ui/marker_component/utils/math.dart';

class ItemAngle implements ItemToDraw {
  @override
  Color color;

  @override
  String creatingText;

  @override
  String id;

  @override
  String text;

  Offset point1;
  Offset point2;
  Offset point3;

  Paint _paint;
  Paint _selectedPaint;

  ItemAngle({
    this.color,
    this.text = '',
    this.creatingText = '',
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    _selectedPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
  }

  @override
  draw(Canvas canvas, bool isSelected, List<ItemToDraw> otherItems) {
    if (point1 == null || point2 == null) return;

    final path = Path()
      ..moveTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy);
    if (point3 != null) path.lineTo(point3.dx, point3.dy);

    if (isSelected) canvas.drawPath(path, _selectedPaint);

    canvas.drawPath(path, _paint);

    final textToDraw =
        text.isEmpty ? '${getAngle(point1, point2, point3).toInt()}°' : text;
    final cpoint = centerPoint(point1, point2);
    final rotation = horizontalAngle(point1, point2);
    drawText(
      point: cpoint,
      rotation: rotation,
      canvas: canvas,
      color: color,
      text: textToDraw,
    );
  }

  @override
  CloseToPoint isCloseToPoint(Offset point) {
    if (point1 == null || point2 == null || point3 == null || point == null)
      return CloseToPoint(false, double.infinity);

    final distance1 = distance(point1, point);
    if (distance1 <= 15) return CloseToPoint(true, distance1);
    final distance2 = distance(point2, point);
    if (distance2 <= 15) return CloseToPoint(true, distance2);
    final distance3 = distance(point3, point);
    if (distance3 <= 15) return CloseToPoint(true, distance3);

    return CloseToPoint(false, double.infinity);
  }

  var creatingSteep2 = false;

  @override
  bool onCreate(Offset point, EventType event) {
    switch (event) {
      case EventType.START:
        if (creatingSteep2)
          point3 = point;
        else {
          point1 = point;
          point2 = point;
        }
        break;
      case EventType.UPDATE:
        if (creatingSteep2)
          point3 = point;
        else
          point2 = point;
        break;
      case EventType.END:
        if (creatingSteep2)
          return true;
        else
          creatingSteep2 = true;
    }
    return false;
  }

  @override
  bool onTouch(Offset point, EventType event) {
    if (point1 == null || point1 == null || point3 == null || point == null)
      return false;

    final distance1 = distance(point1, point);
    final distance2 = distance(point2, point);
    final distance3 = distance(point3, point);

    if (distance1 < distance2 && distance1 < distance3) point1 = point;
    if (distance2 < distance1 && distance2 < distance3) point2 = point;
    if (distance3 < distance1 && distance3 < distance2) point3 = point;
    return true;
  }

  @override
  updateColor(Color color) {
    this.color = color;
    _paint.color = color;
  }
}
