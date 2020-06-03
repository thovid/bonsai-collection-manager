/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/trees/infrastructure/bonsai_tree_table.dart';
import 'package:bonsaicollectionmanager/images/infrastructure/collection_item_image_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_data.dart';
import 'test_mocks.dart';

Widget testAppWith(Widget widget,
        {BonsaiTreeCollection bonsaiCollection,
        NavigatorObserver navigationObserver}) =>
    WithAppContext(
        child: MaterialApp(
          home: ChangeNotifierProvider<BonsaiTreeCollection>.value(
            value: bonsaiCollection,
            builder: (context, child) => widget,
          ),
          navigatorObservers: [
            if (navigationObserver != null) navigationObserver
          ],
        ),
        testContext: AppContext(
            isInitialized: true,
            bonsaiCollection: bonsaiCollection,
            speciesRepository: testSpecies,
            imageRepository: DummyImageRepository()));

Future<Database> openTestDatabase(
    {bool createTables = true, bool dropAll = true}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (dropAll) {
    print('deleting test database...');
    await databaseFactoryFfi.deleteDatabase(inMemoryDatabasePath);
  }

  var database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  if (createTables) {
    print('creating tables in test database...');
    await BonsaiTreeTable.createTable(database);
    await CollectionItemImageTable.createTable(database);
  }
  return database;
}

Future<BonsaiTreeCollection> loadCollectionWith(
        List<BonsaiTreeData> trees) async =>
    await BonsaiTreeCollection.load(
        treeRepository: TestBonsaiRepository(trees),
        imageRepository: DummyImageRepository());
