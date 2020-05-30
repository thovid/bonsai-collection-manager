/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import '../model/bonsai_tree.dart';
import '../model/collection_item_image.dart';
import '../model/model_id.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CollectionItemImageTable {
  static const table_name = 'collection_item_image';

  static const image_id = 'id';
  static const file_name = 'file_name';
  static const parent_id = 'parent_id';

  static const List<String> columns = const [
    image_id,
    file_name,
    parent_id,
  ];

  static createTable(Database db) async {
    await db.execute("CREATE TABLE $table_name (" +
        "$image_id STRING PRIMARY KEY," +
        "$file_name TEXT," +
        "$parent_id TEXT"
            ")");
  }

  static Future<void> write(CollectionItemImage anImage, Database db) async {
    Map<String, dynamic> data = {
      image_id: anImage.id.value,
      parent_id: anImage.parentId.value,
      file_name: anImage.fileName
    };
    return db.insert(table_name, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<CollectionItemImage> read(
      ModelID<CollectionItemImage> id, Database db) async {
    List<Map<String, dynamic>> data = await db.query(table_name,
        columns: columns, where: '$image_id = ?', whereArgs: [id.value]);
    if (data.length == 0) {
      return null;
    }

    return await _fromMap(data[0]);
  }

  static Future<CollectionItemImage> _fromMap(Map<String, dynamic> data) async {
    return (CollectionItemImageBuilder(id: data[image_id])
          ..parentId = ModelID<BonsaiTree>.fromID(data[parent_id])
          ..fileName = data[file_name])
        .build();
  }
}
