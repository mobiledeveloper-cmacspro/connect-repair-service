import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/items/item_to_draw.dart';
import 'package:repairservices/ui/marker_component/utils/draw_utils.dart';
import 'package:repairservices/ui/marker_component/utils/math.dart';

class ItemLine implements ItemToDraw {
  @override
  Color color;

  @override
  String id;

  @override
  String text;

  @override
  String creatingText;

  Offset startPoint;
  Offset endPoint;

  bool startArrow;
  bool endArrow;

  Paint _paint;
  Paint _selectedPaint;

  ItemLine({
    this.color,
    this.text = '',
    this.creatingText = '',
    this.startPoint,
    this.endPoint,
    this.startArrow = false,
    this.endArrow = false,
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
  updateColor(Color color) {
    this.color = color;
    _paint.color = color;
  }

  @override
  draw(Canvas canvas, bool isSelected, List<ItemToDraw> otherItems) async {
    if (startPoint != null && endPoint != null) {
      if (isSelected) {
        canvas.drawLine(startPoint, endPoint, _selectedPaint);
        drawArrow(
          startPoint: startPoint,
          endPoint: endPoint,
          canvas: canvas,
          paint: _selectedPaint,
          drawStart: startArrow,
          drawEnd: endArrow,
        );
      }
      canvas.drawLine(startPoint, endPoint, _paint);
      drawArrow(
        startPoint: startPoint,
        endPoint: endPoint,
        canvas: canvas,
        paint: _paint,
        drawStart: startArrow,
        drawEnd: endArrow,
      );
      final cpoint = centerPoint(startPoint, endPoint);
      final rotation = horizontalAngle(startPoint, endPoint);
      drawText(
        point: cpoint,
        rotation: rotation,
        canvas: canvas,
        color: color,
        text: text,
      );
    }
  }

  @override
  CloseToPoint isCloseToPoint(Offset point) {
    if (startPoint == null || endPoint == null || point == null)
      return CloseToPoint(false, double.infinity);

    final distance1 = distance(startPoint, point);
    if (distance1 <= 15) return CloseToPoint(true, distance1);
    final distance2 = distance(endPoint, point);
    if (distance2 <= 15) return CloseToPoint(true, distance2);

    return CloseToPoint(false, double.infinity);
  }

  @override
  bool onCreate(Offset point, EventType event) {
    switch (event) {
      case EventType.START:
        startPoint = point;
        endPoint = point;
        break;
      case EventType.UPDATE:
        endPoint = point;
        break;
      case EventType.END:
        return true;
    }
    return false;
  }

  @override
  bool onTouch(Offset point, EventType event) {
    if (startPoint == null || endPoint == null || point == null) return false;

    final distance1 = distance(startPoint, point);
    final distance2 = distance(endPoint, point);

    if (distance1 < distance2)
      startPoint = point;
    else
      endPoint = point;
    return true;
  }
}
