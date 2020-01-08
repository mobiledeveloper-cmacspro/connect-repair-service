
import 'package:flutter/material.dart';
import 'package:repairservices/ui/marker_component/items/item_to_draw.dart';

class DrawerCanvasPainter extends CustomPainter {
  final List<ItemToDraw> items;
  final ItemToDraw selectedItem;

  DrawerCanvasPainter({
    @required this.items,
    this.selectedItem,
  });

  @override
  void paint(Canvas canvas, Size size) {
    items.forEach((item) {
      item.draw(canvas, item.id == selectedItem?.id, items);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
