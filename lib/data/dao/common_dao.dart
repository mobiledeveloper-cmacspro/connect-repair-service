import 'package:repairservices/domain/i_common_dao.dart';
import 'package:repairservices/local/app_database.dart';
import 'package:repairservices/local/db_constants.dart';

class CommonDao implements ICommonDao {
  final AppDatabase _appDatabase;

  CommonDao(this._appDatabase);

  @override
  Future<bool> cleanDB() async {
    try {
      await _appDatabase.deleteAll(DBConstants.article_image__table);
      ///Add here all lines for complete data remove by each table...
      return true;
    } catch (ex) {
      return false;
    }
  }
}
