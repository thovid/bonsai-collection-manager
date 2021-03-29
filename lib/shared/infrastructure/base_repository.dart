/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../logbook/infrastructure/logbook_entry_table.dart';
import '../../images/infrastructure/collection_item_image_table.dart';
import '../../reminder/infrastructure/reminder_configuration_table.dart';
import '../../trees/infrastructure/bonsai_tree_table.dart';
import '../../trees/infrastructure/species_table.dart';

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
          version: 4,
          onCreate: (Database db, int version) async {
            await SpeciesTable.createTable(db);
            await BonsaiTreeTable.createTable(db);
            await CollectionItemImageTable.createTable(db);
            await LogbookEntryTable.createTable(db);
            await ReminderConfigurationTable.createTable(db);
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            if (oldVersion == newVersion) return;
            if (newVersion >= 2 && oldVersion < 2)
              await LogbookEntryTable.createTable(db);
            if (newVersion >= 3 && oldVersion < 3)
              await SpeciesTable.createTable(db);
            if (newVersion >= 4 && oldVersion < 4) {
              await ReminderConfigurationTable.createTable(db);
            }
          },
        ));
    initialized = true;
    return _database;
  }

  Future<String> _dbPath(String dbName) async =>
      getApplicationDocumentsDirectory().then((dir) => join(dir.path, dbName));
}
