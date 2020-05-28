/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'dart:io';

import 'package:bonsaicollectionmanager/trees/infrastructure/bonsai_tree_table.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/bonsai_collection.dart';
import '../model/bonsai_tree.dart';

class SQLBonsaiTreeRepository extends BonsaiTreeRepository {
  static const String db_name = 'bonsaiCollectionManager.db';

  final SpeciesRepository speciesRepository;
  SQLBonsaiTreeRepository(this.speciesRepository);

  bool initialized = false;
  Database _database;

  @override
  Future<BonsaiCollection> loadCollection() async {
    await init();
    return BonsaiCollection.withTrees(
        await BonsaiTreeTable.readAll(speciesRepository, _database),
        repository: this);
  }

  @override
  Future<void> update(BonsaiTree tree) async {
    await init();
    return BonsaiTreeTable.write(tree, _database);
  }

  init() async {
    if (!initialized) {
      await _init();
      initialized = true;
    }
  }

  Future _init() async {
    String path = await dbPath(db_name);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async =>
          await BonsaiTreeTable.createTable(db),
    );
  }

  Future<String> dbPath(String dbName) async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, dbName);
  }
}
