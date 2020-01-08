


import 'package:repairservices/ui/marker_component/items/item_to_draw.dart';

class DrawerMode {

  ModeType modeType;
  ItemToDraw item;

  DrawerMode._({this.modeType, this.item});

  factory DrawerMode.add(ItemToDraw item) => DrawerMode._(
        modeType: ModeType.ADD,
        item: item,
      );

  factory DrawerMode.nothing() => DrawerMode._(
        modeType: ModeType.NOTHING,
      );

  factory DrawerMode.select() => DrawerMode._(
        modeType: ModeType.SELECT,
      );
}

enum ModeType { ADD, NOTHING, SELECT }

enum EventType { START, UPDATE, END }