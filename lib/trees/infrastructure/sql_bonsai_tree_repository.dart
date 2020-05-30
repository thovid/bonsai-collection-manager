/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/collection_item_image.dart';
import '../model/model_id.dart';
import '../model/species.dart';
import '../model/bonsai_collection.dart';
import '../model/bonsai_tree.dart';

import './collection_item_image_table.dart';
import './bonsai_tree_table.dart';

class SQLBonsaiTreeRepository extends BonsaiTreeRepository {
  static const String db_name = 'bonsaiCollectionManager.db';

  final SpeciesRepository speciesRepository;
  SQLBonsaiTreeRepository(this.speciesRepository);

  bool initialized = false;
  Database _database;

  @override
  Future<BonsaiCollection> loadCollection() =>
      init().then((_) async => BonsaiCollection.withTrees(
          await BonsaiTreeTable.readAll(speciesRepository, _database),
          repository: this));

  @override
  Future<void> update(BonsaiTree tree) async =>
      init().then((_) => BonsaiTreeTable.write(tree, _database));

  @override
  Future<List<CollectionItemImage>> loadImages(
          ModelID<BonsaiTree> treeId) async =>
      init()
          .then((_) => CollectionItemImageTable.readForItem(treeId, _database));

  Future init() async {
    if (initialized) {
      return;
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
  }

  Future<String> _dbPath(String dbName) async =>
      getApplicationDocumentsDirectory().then((dir) => join(dir.path, dbName));
}
