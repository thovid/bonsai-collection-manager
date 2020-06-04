/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../images/infrastructure/collection_item_image_table.dart';
import '../../trees/infrastructure/bonsai_tree_table.dart';

class BaseRepository {
  static const String db_name = 'bonsaiCollectionManager.db';

  static Database _database;
  bool initialized = false;

  Future<Database> init() async {
    if (initialized) {
      return _database;
    }
    _database = await _dbPath(db_name).then((path) => openDatabase(
          path,
          version: 1,
          onCreate: (Database db, int version) async {
            await BonsaiTreeTable.createTable(db);
            await CollectionItemImageTable.createTable(db);
          },
        ));
    initialized = true;
    return _database;
  }

  Future<String> _dbPath(String dbName) async =>
      getApplicationDocumentsDirectory().then((dir) => join(dir.path, dbName));
}
