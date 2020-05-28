export 'package:repairservices/di/bloc_provider.dart';

import 'package:kiwi/kiwi.dart';
import 'package:repairservices/data/dao/article_local_dao.dart';
import 'package:repairservices/data/dao/common_dao.dart';
import 'package:repairservices/data/json/article_local_model_converter.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_dao.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_model_converter.dart';
import 'package:repairservices/domain/article_local_model/i_article_local_repository.dart';
import 'package:repairservices/domain/i_common_dao.dart';
import 'package:repairservices/local/app_database.dart';
import 'package:repairservices/repositories/article_local_repository.dart';
import 'package:repairservices/ui/article_detail/article_detail_bloc.dart';
import 'package:repairservices/ui/article_identification/article_identification_bloc.dart';
import 'package:repairservices/ui/article_local_detail/article_local_detail_bloc.dart';
import 'package:repairservices/ui/article_resources/audio/audio_bloc.dart';
import 'package:repairservices/ui/article_resources/note/note_bloc.dart';
import 'package:repairservices/ui/article_resources/video/video_bloc.dart';
import 'package:repairservices/ui/fitting_detail/fitting_windows_bloc.dart';
import 'package:repairservices/ui/fitting_dimensions/door_hinge/fitting_door_hinge_dimension_bloc.dart';
import 'package:repairservices/ui/fitting_dimensions/door_lock/fitting_door_lock_dimension_bloc.dart';
import 'package:repairservices/ui/fitting_dimensions/sliding/fitting_sliding_dimension_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_container_bloc.dart';
import 'package:repairservices/ui/marker_component/drawer_tool_bloc.dart';
import 'package:repairservices/ui/0_base/bloc_base.dart';
import 'package:repairservices/ui/pdf_viewer/pdf_viewer_bloc.dart';

///Part dependency injector engine and Part service locator.
///The main purpose of [Injector] is to provide bloCs instances and initialize the app components depending the current scope.
///To reuse a bloc instance in the widget's tree feel free to use the [BlocProvider] mechanism.
class Injector {
  ///Singleton instance
  static Injector instance;

  Container container = Container();

  ///Init the injector with prod configurations
  static initProd() {
    if (instance == null) instance = Injector._init();
  }

  ///Init the injector with demo configurations
  static initDemo() {
    if (instance == null) instance = Injector._demo();
  }

  ///Init
  Injector._init() {
    _registerLocalAuth();
    _registerCommonImpl();
    _registerModelConverters();
    _registerDaoLayer();
    _registerApiLayer();
    _registerBloCs();
    //repositories
    _registerRepositoryLayer();
  }

  ///Init Demo
  Injector._demo() {
    _registerLocalAuth();
    _registerCommonImpl();
    _registerModelConverters();
    _registerDaoLayer();
    _registerApiLayer();
    _registerBloCs();
    //demo repositories
    _registerDemoRepositoryLayer();
  }

  _registerDemoRepositoryLayer() {}

  _registerLocalAuth() {}

  _registerApiLayer() {}

  _registerDaoLayer() {
    container.registerSingleton((c) => AppDatabase.instance);

    container.registerSingleton<ICommonDao, CommonDao>(
        (c) => CommonDao(container.resolve()));

    container.registerSingleton<IArticleLocalDao, ArticleLocalDao>(
        (c) => ArticleLocalDao(container.resolve(), container.resolve()));
  }

  _registerRepositoryLayer() {
    container
        .registerSingleton<IArticleLocalRepository, ArticleLocalRepository>(
            (c) => ArticleLocalRepository(container.resolve()));
  }

  ///Register the blocs here
  _registerBloCs() {
    container.registerFactory((c) => DrawerToolBloc(container.resolve()));
    container.registerFactory((c) => DrawerContainerBloC());
    container
        .registerFactory((c) => ArticleIdentificationBloC(container.resolve()));
    container.registerFactory((c) => ArticleLocalDetailBloC(container.resolve()));
    container.registerFactory((c) => ArticleDetailBloC());
    container.registerFactory((c) => PDFViewerBloC());
    container.registerFactory((c) => FittingWindowsBloC());
    container.registerFactory((c) => FittingDoorLockDimensionBloC());
    container.registerFactory((c) => FittingSlidingDimensionBloC());
    container.registerFactory((c) => FittingDoorHingeDimensionBloC());
    container.registerFactory((c) => NoteBloC());
    container.registerFactory((c) => AudioBloC());
    container.registerFactory((c) => VideoBloC());
  }

  _registerModelConverters() {
    container.registerSingleton<IArticleLocalModelConverter,
        ArticleLocalModelConverter>((c) => ArticleLocalModelConverter());
  }

  ///Register common components
  _registerCommonImpl() {}

  ///returns the current instance of the logger

  ///returns a new bloc instance
  T getNewBloc<T extends BaseBloC>() => container.resolve();

  T getDependency<T>() => container.resolve();
}
