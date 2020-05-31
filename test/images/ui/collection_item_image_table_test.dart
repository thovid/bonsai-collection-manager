/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/collection_item_image_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/images/model/collection_item_image.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('can write and read item image', () async {
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

  test('can read all images for a single item', () async {
    var treeId = ModelID<BonsaiTree>.newId();
    var firstImage = (CollectionItemImageBuilder()
          ..fileName = 'first.jpg'
          ..parentId = treeId)
        .build();
    var secondImage = (CollectionItemImageBuilder()
          ..fileName = 'second.jpg'
          ..parentId = treeId)
        .build();
    var otherImage = (CollectionItemImageBuilder()
          ..fileName = 'third.jpg'
          ..parentId = ModelID<BonsaiTree>.newId())
        .build();

    var db = await openTestDatabase();
    await CollectionItemImageTable.write(firstImage, db)
        .then((_) => CollectionItemImageTable.write(secondImage, db))
        .then((value) => CollectionItemImageTable.write(otherImage, db));

    var imagesForTree = await CollectionItemImageTable.readForItem(treeId, db);
    expect(imagesForTree.length, equals(2));
  });
}
