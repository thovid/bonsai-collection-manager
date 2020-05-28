/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:test/test.dart';

import '../../utils/test_data.dart';

main() {
  final Species mugo = Species(TreeType.conifer, latinName: "Pinus Mugo");

  final BonsaiTree firstMugo = (BonsaiTreeBuilder()
        ..species = mugo
        ..speciesOrdinal = 1)
      .build();

  final BonsaiTree secondMugo = (BonsaiTreeBuilder()
        ..species = mugo
        ..speciesOrdinal = 2)
      .build();

  test('a new collection is empty', () async {
    var collection = await TestBonsaiRepository([]).loadCollection();
    expect(collection.size, equals(0));
  });

  test('can add a tree to the collection', () async {
    var collection = await TestBonsaiRepository([]).loadCollection();
    var aTree = (BonsaiTreeBuilder()..treeName = "Test Tree").build();
    var savedTree = await collection.add(aTree);
    expect(collection.size, equals(1));
    expect(TestBonsaiRepository.lastUpdated, savedTree);
  });

  test('calculates next ordinal for added tree', () async {
    var collection = await TestBonsaiRepository([firstMugo, secondMugo]).loadCollection();
    var aTree = (BonsaiTreeBuilder()
          ..treeName = "Test Tree"
          ..species = mugo)
        .build();
    var addedTree = await collection.add(aTree);
    expect(addedTree.speciesOrdinal, equals(3));
  });

  test('can get a tree with a given id', () async {
    var collection = await TestBonsaiRepository([firstMugo, secondMugo]).loadCollection();
    var found = collection.findById(secondMugo.id);
    expect(found, equals(secondMugo));
  });

  test('can update a tree with new data', () async {
    var collection = await TestBonsaiRepository([firstMugo, secondMugo]).loadCollection();
    var id = secondMugo.id;
    var updated = (BonsaiTreeBuilder(fromTree: secondMugo)
          ..treeName = "Updated Tree Name")
        .build();
    await collection.update(updated);
    var found = collection.findById(id);
    expect(found.treeName, equals(updated.treeName));
    expect(found.speciesOrdinal, equals(2)); // ordinal should not change
    expect(TestBonsaiRepository.lastUpdated, equals(found));
  });
}
