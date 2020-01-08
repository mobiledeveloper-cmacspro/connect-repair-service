
import 'package:repairservices/ui/marker_component/items/item_to_draw.dart';

class ItemsData {
  final List<ItemToDraw> items;
  final ItemToDraw selectedItem;

  ItemsData({
    this.items,
    this.selectedItem,
  });

  ItemsData.empty()
      : this(
          items: [],
          selectedItem: null,
        );

  ItemsData copyWith({
    List<ItemToDraw> items,
    ItemToDraw selectedItem,
  }) =>
      ItemsData(
        items: items ?? this.items,
        selectedItem: selectedItem ?? this.selectedItem,
      );
}
