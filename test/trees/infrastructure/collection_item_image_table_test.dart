/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/infrastructure/collection_item_image_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/trees/model/collection_item_image.dart';
import 'package:bonsaicollectionmanager/trees/model/model_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

main() {
  test('knows db table spec for collection item image', () {
    expect(CollectionItemImageTable.image_id, equals('id'));
    expect(CollectionItemImageTable.file_name, equals('file_name'));
    expect(CollectionItemImageTable.parent_id, equals('parent_id'));
  });

  test('can create table', () async {
    var db = await openTestDatabase(createTables: false);
    await CollectionItemImageTable.createTable(db);
    var allTables = await db.query('sqlite_master');
    var table = allTables.firstWhere((element) =>
        element['type'] == 'table' &&
        element['name'] == CollectionItemImageTable.table_name);
    print(table);
    expect(table, isNotNull);
  });

  test('can write, read and update item', () async {
    var db = await openTestDatabase();
    var anImage = (CollectionItemImageBuilder()
          ..fileName = 'test_file.jpg'
          ..parentId = ModelID<BonsaiTree>.newId())
        .build();

    await CollectionItemImageTable.write(anImage, db);
    var itemFromDB = await CollectionItemImageTable.read(anImage.id, db);
    expect(itemFromDB.parentId.value, equals(anImage.parentId.value));
    expect(itemFromDB.fileName, equals(anImage.fileName));
  });
}
