/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:test/test.dart';

import '../../utils/test_mocks.dart';
import '../../utils/test_utils.dart';

main() {
  final Species mugo = Species(TreeType.conifer, latinName: "Pinus Mugo");

  final BonsaiTreeData firstMugo = (BonsaiTreeDataBuilder()
        ..species = mugo
        ..speciesOrdinal = 1)
      .build();

  final BonsaiTreeData secondMugo = (BonsaiTreeDataBuilder()
        ..species = mugo
        ..speciesOrdinal = 2)
      .build();

  test('a new collection is empty', () async {
    var collection = await loadCollectionWith(<BonsaiTreeData>[]);
    expect(collection.size, equals(0));
  });

  test('can add a tree to the collection', () async {
    var collection = await loadCollectionWith(<BonsaiTreeData>[]);
    var aTree = (BonsaiTreeDataBuilder()..treeName = "Test Tree").build();
    var savedTree = await collection.add(aTree);
    expect(collection.size, equals(1));
    expect(TestBonsaiRepository.lastUpdated, savedTree.treeData);
  });

  test('calculates next ordinal for added tree', () async {
    var collection = await loadCollectionWith([firstMugo, secondMugo]);
    var aTree = (BonsaiTreeDataBuilder()
          ..treeName = "Test Tree"
          ..species = mugo)
        .build();
    var addedTree = await collection.add(aTree);
    expect(addedTree.treeData.speciesOrdinal, equals(3));
  });

  test('can get a tree with a given id', () async {
    var collection = await loadCollectionWith([firstMugo, secondMugo]);
    var found = collection.findById(secondMugo.id);
    expect(found.treeData, equals(secondMugo));
  });

  test('can update a tree with new data', () async {
    var collection = await loadCollectionWith([firstMugo, secondMugo]);
    var id = secondMugo.id;
    var updated = (BonsaiTreeDataBuilder(fromTree: secondMugo)
          ..treeName = "Updated Tree Name")
        .build();
    var toUpdate =  collection.findById(id);
    toUpdate.treeData = updated;
    await collection.update(toUpdate);
    var found = collection.findById(id);
    expect(found.treeData.treeName, equals(updated.treeName));
    expect(found.treeData.speciesOrdinal, equals(2)); // ordinal should not change
    expect(TestBonsaiRepository.lastUpdated, equals(found.treeData));
  });
}

