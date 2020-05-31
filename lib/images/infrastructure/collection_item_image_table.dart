/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:sqflite_common/sqlite_api.dart';

import '../model/collection_item_image.dart';
import '../../shared/model/model_id.dart';

class CollectionItemImageTable {
  static const table_name = 'collection_item_image';

  static const image_id = 'id';
  static const file_name = 'file_name';
  static const parent_id = 'parent_id';
  static const is_main_image = 'is_main_image';

  static const List<String> columns = const [
    image_id,
    file_name,
    parent_id,
    is_main_image,
  ];

  static createTable(DatabaseExecutor db) async {
    await db.execute("CREATE TABLE $table_name (" +
        "$image_id STRING PRIMARY KEY," +
        "$file_name TEXT," +
        "$parent_id TEXT," +
        "$is_main_image INT"
            ")");
  }

  static Future<void> write(
      CollectionItemImage anImage, DatabaseExecutor db) async {
    Map<String, dynamic> data = {
      image_id: anImage.id.value,
      parent_id: anImage.parentId.value,
      file_name: anImage.fileName,
      is_main_image: anImage.isMainImage ? 1 : 0,
    };
    return db.insert(table_name, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<CollectionItemImage> read(
      ModelID<CollectionItemImage> id, DatabaseExecutor db) async {
    List<Map<String, dynamic>> data = await db.query(table_name,
        columns: columns, where: '$image_id = ?', whereArgs: [id.value]);
    if (data.length == 0) {
      return null;
    }

    return await _fromMap(data[0]);
  }

  static Future<CollectionItemImage> _fromMap(Map<String, dynamic> data) async {
    return (CollectionItemImageBuilder(id: data[image_id])
          ..parentId = ModelID.fromID(data[parent_id])
          ..fileName = data[file_name]
          ..isMainImage = data[is_main_image] > 0)
        .build();
  }

  static Future<List<CollectionItemImage>> readForItem(
      ModelID treeId, Database db) async {
    List<Map<String, dynamic>> data = await db.query(table_name,
        columns: columns, where: '$parent_id = ?', whereArgs: [treeId.value]);
    List<CollectionItemImage> result = List(data.length);
    for (var i = 0; i < data.length; i++) {
      CollectionItemImage t = await _fromMap(data[i]);
      result[i] = t;
    }
    return result;
  }

  static Future<void> delete(
      ModelID<CollectionItemImage> id, Database db) async {
    return db.delete(table_name, where: '$image_id = ?', whereArgs: [id.value]);
  }

  static Future<void> setMainImageFlag(
      ModelID<CollectionItemImage> id, bool flag, DatabaseExecutor db) async {
    return db.rawUpdate(
        'UPDATE $table_name SET $is_main_image = ${flag ? 1 : 0} WHERE $image_id = ?',
        [id.value]);
  }
}
