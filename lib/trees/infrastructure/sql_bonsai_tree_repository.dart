/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/bonsai_collection.dart';
import '../model/bonsai_tree.dart';

class SQLBonsaiTreeRepository extends BonsaiTreeRepository {
  static final  String db_name = 'bonsaiCollectionManager.db';
  
  bool initialized = false;
  Database _database;

  @override
  Future<BonsaiCollection> loadCollection() {
    // TODO: implement loadCollection
    throw UnimplementedError();
  }

  @override
  Future<BonsaiTree> update(BonsaiTree tree) {
    // TODO: implement update
    throw UnimplementedError();
  }

  init() async {
    if (!initialized) {
      await _init();
      initialized = true;
    }
  }

  Future _init() async {
    String path = await dbPath(db_name);

    _database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {
      
        });
  }

  Future<String> dbPath(String dbName) async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, dbName);
  }
}
