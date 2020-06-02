/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:bonsaicollectionmanager/images/model/collection_item_image.dart';
import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/trees/infrastructure/bonsai_tree_table.dart';
import 'package:bonsaicollectionmanager/images/infrastructure/collection_item_image_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_data.dart';

Widget testAppWith(Widget widget, BonsaiCollection collection,
        {BonsaiTreeCollection bonsaiCollection,
        NavigatorObserver navigationObserver}) =>
    WithAppContext(
        child: MaterialApp(
          home: widget,
          navigatorObservers: [
            if (navigationObserver != null) navigationObserver
          ],
        ),
        testContext: AppContext(
            isInitialized: true,
            collection: collection,
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

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class DummyImageRepository extends ImageRepository {
  List<CollectionItemImage> _images;

  DummyImageRepository({List<CollectionItemImage> images})
      : _images = (images == null ? [] : images);

  @override
  Future<CollectionItemImage> add(
      File imageFile, bool isMainImage, ModelID parent) async {
    var image = (CollectionItemImageBuilder()
          ..fileName = imageFile.path
          ..parentId = parent
          ..isMainImage = isMainImage)
        .build();
    _images.add(image);
    return image;
  }

  @override
  Future<void> remove(ModelID<CollectionItemImage> id) async {
    return;
  }

  @override
  Future<void> toggleIsMainImage(
      {ModelID<CollectionItemImage> newMainImageId,
      ModelID<CollectionItemImage> oldMainImageId}) async {}

  @override
  Future<List<CollectionItemImage>> loadImages(ModelID parent) async {
    return _images;
  }
}

Future<BonsaiTreeCollection> createTestBonsaiCollection(
    List<BonsaiTreeData> trees) async {
  var repo = TestBonsaiRepository(trees);
  return BonsaiTreeCollection.load(
      treeRepository: repo, imageRepository: DummyImageRepository());
}
