/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/trees/infrastructure/bonsai_tree_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_data.dart';

Widget testAppWith(Widget widget, BonsaiCollection collection) =>
    WithAppContext(
        child: MaterialApp(home: widget),
        testContext: AppContext(
          isInitialized: true,
          collection: collection,
          speciesRepository: testSpecies,
        ));

Future<Database> openTestDatabase(
    {bool createTables = true, bool dropAll = true}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (dropAll) {
    await databaseFactoryFfi.deleteDatabase(inMemoryDatabasePath);
  }

  var database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  if (createTables) {
    await BonsaiTreeTable.createTable(database);
  }
  return database;
}
