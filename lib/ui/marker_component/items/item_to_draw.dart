import 'package:flutter/material.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';

abstract class ItemToDraw {
  String id;
  Color color;
  String text;
  String creatingText;

  updateColor(Color color);

  bool onCreate(Offset point, EventType event);

  CloseToPoint isCloseToPoint(Offset point);

  bool onTouch(Offset point, EventType event);

  draw(Canvas canvas, bool isSelected, List<ItemToDraw> otherItems);
}

class CloseToPoint {
  bool isClose;
  double distance;

  CloseToPoint(this.isClose, this.distance);
}
