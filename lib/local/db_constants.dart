class DBConstants {
  static final String db_name = 'connect_app_db';
  static final int db_version = 1;

  ///Common table schema
  static final Map<String, String> table_cols = {
    DBConstants.id_key: DBConstants.text_type,
    DBConstants.data_key: DBConstants.text_type,
    DBConstants.parent_key: DBConstants.text_type,
  };

  static final Map<String, String> table_offline_cols = {
    DBConstants.id_key: DBConstants.text_type,
    DBConstants.data_key: DBConstants.text_type,
    DBConstants.parent_key: DBConstants.text_type,
  };

  ///columns names
  static final String id_key = 'id';
  static final String data_key = 'data';
  static final String parent_key = 'parent_id';

  ///columns types
  static final String text_type = 'TEXT';
  static final String real_type = 'REAL';
  static final String int_type = 'INTEGER';

  ///table names
  static final String article_image__table = 'article_image__table';


  static final String id = "id";
  static final String display_name = "display_name";
  static final String file_path = "file_path";
  static final String screenshoot_file_path = "screenshoot_file_path";
  static final String created_on_image = "created_on_image";
  static final String created_on_screen_shoot = "created_on_screen_shoot";
  static final String notes = "notes";
  static final String audios = "audios";
  static final String videos = "videos";

}
