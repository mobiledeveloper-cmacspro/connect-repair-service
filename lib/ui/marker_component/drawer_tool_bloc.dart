import 'dart:io';
import 'dart:ui';

import 'package:repairservices/utils/calendar_utils.dart';
import 'package:repairservices/domain/article_local_model/article_local_model.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_repository.dart';
import 'package:repairservices/ui/article_resources/article_resource_model.dart';
import 'package:repairservices/ui/marker_component/drawer_mode.dart';
import 'package:repairservices/ui/marker_component/glass_data.dart';
import 'package:repairservices/ui/marker_component/items/item_to_draw.dart';
import 'package:repairservices/ui/marker_component/items_data.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';

import '../../utils/calendar_utils.dart';

class DrawerToolBloc extends BaseBloC {
  final IArticleLocalRepository _iArticleLocalRepository;

  BehaviorSubject<ItemsData> _itemsToDrawController =
      BehaviorSubject.seeded(ItemsData.empty());

  DrawerToolBloc(this._iArticleLocalRepository);

  ItemsData get itemsToDraw => _itemsToDrawController.value;

  Stream<ItemsData> get itemsToDrawStream => _itemsToDrawController.stream;

  BehaviorSubject<List<MemoModel>> _memoListController = new BehaviorSubject();

  Stream<List<MemoModel>> get memoListResult => _memoListController.stream;

  BehaviorSubject<Offset> _memoController = new BehaviorSubject();

  Stream<Offset> get memoResult => _memoController.stream;

  ArticleLocalModel articleModel;
  bool addingMemo = false;
  MemoType currentMemoType;

  void initArticleModel(String initialFilePath) {
    final File file = File(initialFilePath);
    articleModel = ArticleLocalModel(
        id: file.path.split("/").last,
        displayName: "Picture1",
        notes: [],
        audios: [],
        videos: [],
        createdOnImage: CalendarUtils.getDateTimeFromString(
            initialFilePath.split("/").last),
        filePath: initialFilePath);
    _selectedImageController.sink.add(File(initialFilePath));
  }

  _addItem(ItemToDraw item) {
    final items = itemsToDraw.items;
    if (!items.any((i) => i.id == item.id)) items.add(item);
    _itemsToDrawController.sink.add(itemsToDraw.copyWith(items: items));
  }

  deleteCurrentItem() {
    final itemData = itemsToDraw;
    final items = itemData.items;
    final selectedItem = itemData.selectedItem;
    items.removeWhere((i) => i.id == selectedItem?.id);
    currentDrawerMode = DrawerMode.nothing();
    _itemsToDrawController.sink.add(ItemsData(
      items: items,
      selectedItem: null,
    ));
  }

  set currentItemToDraw(ItemToDraw item) {
    _itemsToDrawController.sink.add(itemsToDraw.copyWith(selectedItem: item));
  }

  BehaviorSubject<DrawerMode> _currentDrawerModeController =
      BehaviorSubject.seeded(DrawerMode.nothing());

  DrawerMode get currentDrawerMode => _currentDrawerModeController.value;

  Stream<DrawerMode> get currentDrawerModeStream =>
      _currentDrawerModeController.stream;

  set currentDrawerMode(DrawerMode mode) {
    if (mode.modeType == ModeType.NOTHING) currentItemToDraw = null;
    _currentDrawerModeController.sink.add(mode);
  }

  BehaviorSubject<bool> _loadingController = BehaviorSubject.seeded(false);

  Stream<bool> get loadingStream => _loadingController.stream;

  bool get loading => _loadingController.value;

  set loading(bool l) {
    _loadingController.sink.add(l);
  }

  BehaviorSubject<GlassData> _glassDataController = BehaviorSubject();

  Stream<GlassData> get glassDataStream => _glassDataController.stream;

  set glassData(GlassData data) {
    _glassDataController.sink.add(data);
  }

  Future onTouchUpdate(Offset touchedPosition, EventType eventType) async {
    if (addingMemo) {
      addingMemo = false;
      _memoController.sink.add(touchedPosition);
    } else {
      final currentMode = currentDrawerMode;
      switch (currentMode.modeType) {
        case ModeType.ADD:
          {
            final item = currentMode.item;
            if (item != null) {
              final finished = item.onCreate(touchedPosition, eventType);
              currentItemToDraw = item;
              _addItem(item);
              if (finished) currentDrawerMode = DrawerMode.select();
            }
          }
          break;
        case ModeType.SELECT:
          {
            itemsToDraw?.selectedItem?.onTouch(touchedPosition, eventType);
            currentItemToDraw = itemsToDraw?.selectedItem;
          }
          break;
        case ModeType.NOTHING:
          {
            final filteredItems = itemsToDraw?.items
                ?.where((a) => a.isCloseToPoint(touchedPosition).isClose)
                ?.toList();
            filteredItems.sort(
              (a, b) {
                final distanceA = a.isCloseToPoint(touchedPosition);
                final distanceB = b.isCloseToPoint(touchedPosition);
                if (distanceA.distance == distanceB.distance) return 0;
                return distanceA.distance < distanceB.distance ? -1 : 1;
              },
            );
            if (filteredItems.isNotEmpty) {
              final closer = filteredItems[0];
              currentItemToDraw = closer;
              currentDrawerMode = DrawerMode.select();
            }
          }
          break;
      }
    }
  }

  addLine(ItemToDraw item) {
    currentDrawerMode = DrawerMode.add(item);
  }

  updateColor(Color color) {
    final item = itemsToDraw.selectedItem;
    item?.updateColor(color);
    currentItemToDraw = item;
  }

  updateText(String text) {
    final item = itemsToDraw.selectedItem;
    item?.text = text;
    currentItemToDraw = item;
  }

//  String screenShotFile;

  //File
  BehaviorSubject<File> _selectedImageController = BehaviorSubject();

//  File get selectedImage => _selectedImageController.value;

  Stream<File> get selectedImageStream => _selectedImageController.stream;

//  set selectedImage(File image) {
//    _selectedImageController.sink.add(image);
//  }

  //ScreenShot
  BehaviorSubject<bool> _savingScreenShotController =
      BehaviorSubject.seeded(false);

  bool get savingScreenShot => _savingScreenShotController.value;

  Stream<bool> get savingScreenShotStream => _savingScreenShotController.stream;

  set savingScreenShot(bool savingScreenShot) {
    _savingScreenShotController.sink.add(savingScreenShot);
  }

  //ViewMode
  BehaviorSubject<ViewMode> _viewModeController =
      BehaviorSubject.seeded(ViewMode.NOTHING);

  ViewMode get viewMode => _viewModeController.value;

  Stream<ViewMode> get viewModeStream => _viewModeController.stream;

  set viewMode(ViewMode vm) {
    _viewModeController.sink.add(vm);
  }

  Future<void> saveScreeShoot() async {
    await _iArticleLocalRepository.saveArticleLocal(articleModel);
  }

  void syncMemo(MemoModel model) {
    if (model is MemoNoteModel) {
      final res = articleModel.notes
          .firstWhere((element) => model.id == element.id, orElse: () {
        return null;
      });
      if (res == null && model.description.isNotEmpty) {
        articleModel.notes.add(model);
      } else if (res != null && model.description.isEmpty) {
        articleModel.notes.removeWhere((element) => element.id == res.id);
      }

    } else if (model is MemoAudioModel) {
      final res = articleModel.audios
          .firstWhere((element) => model.id == element.id, orElse: () {
        return null;
      });
      if (res == null && model.filePath.isNotEmpty) {
        articleModel.audios.add(model);
      } else if (res != null && model.filePath.isEmpty) {
        articleModel.audios.removeWhere((element) => element.id == res.id);
      }
    } else if (model is MemoVideoModel) {
      final res = articleModel.videos
          .firstWhere((element) => model.id == element.id, orElse: () {
        return null;
      });
      if (res == null && model.filePath.isNotEmpty) {
        articleModel.videos.add(model);
      } else if (res != null && model.filePath.isEmpty) {
        articleModel.videos.removeWhere((element) => element.id == res.id);
      }
    }
    _memoListController.sink.add([
      ...articleModel.audios,
      ...articleModel.notes,
      ...articleModel.videos,
    ]);
  }

  @override
  dispose() {
    _memoController.close();
    _memoListController.close();
    _loadingController.close();
    _itemsToDrawController.close();
    _currentDrawerModeController.close();
    _glassDataController.close();
    _savingScreenShotController.close();
    _viewModeController.close();
    _selectedImageController.close();
  }
}

enum ViewMode {
  NOTHING,
  ADD,
  COLOR,
}
