/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/infrastructure/bonsai_tree_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

main() {
  test('can create table', () async {
    var db = await openTestDatabase(createTables: false);
    await BonsaiTreeTable.createTable(db);
    var allTables = await db.query('sqlite_master');
    var table = allTables.firstWhere((element) =>
        element['type'] == 'table' &&
        element['name'] == BonsaiTreeTable.table_name);
    print(table);
    expect(table, isNotNull);
  });

  test('can write, read and update tree', () async {
    var db = await openTestDatabase();
    var aTree = await _aTree();

    await BonsaiTreeTable.write(aTree, db);

    var treeFromDB = await BonsaiTreeTable.read(aTree.id, testSpecies, db);
    expect(treeFromDB.acquiredFrom, equals('Test'));
    expect(treeFromDB.species.latinName, equals('Pinus Mugo'));
    expect(treeFromDB.treeName, equals('Test Tree'));
    expect(treeFromDB.developmentLevel, equals(DevelopmentLevel.refinement));
    expect(treeFromDB.potType, equals(PotType.bonsai_pot));

    var updatedTree = (BonsaiTreeBuilder(fromTree: treeFromDB)
          ..treeName = 'Updated tree')
        .build();

    await BonsaiTreeTable.write(updatedTree, db);
    treeFromDB = await BonsaiTreeTable.read(aTree.id, testSpecies, db);
    expect(treeFromDB.treeName, equals('Updated tree'));
  });

  test('can read all trees', () async {
    var db = await openTestDatabase();
    await _createTestTrees(db, count: 5);
    List<BonsaiTree> trees = await BonsaiTreeTable.readAll(testSpecies, db);
    expect(trees.length, equals(5));
  });
}

Future<BonsaiTree> _aTree() async {
  return (BonsaiTreeBuilder()
        ..treeName = 'Test Tree'
        ..species = await testSpecies.findOne(latinName: 'Pinus Mugo')
        ..acquiredFrom = 'Test'
        ..potType = PotType.bonsai_pot
        ..developmentLevel = DevelopmentLevel.refinement)
      .build();
}

Future _createTestTrees(Database db, {int count = 1}) async {
  for (var i = 0; i < count; i++) {
    var tree = (BonsaiTreeBuilder()
          ..species = await testSpecies.findOne(latinName: 'Pinus Mugo')
          ..speciesOrdinal = i + 1)
        .build();
    BonsaiTreeTable.write(tree, db);
  }
}
