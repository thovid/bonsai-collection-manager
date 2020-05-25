/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:test/test.dart';

import 'test_data.dart';

main() {
  final Species silvestris =
      Species(TreeType.conifer, latinName: "Pinus Silvestris");

  final Species mugo = Species(TreeType.conifer, latinName: "Pinus Mugo");

  final BonsaiTree firstMugo = (BonsaiTreeBuilder()
        ..species = mugo
        ..speciesCounter = 1)
      .build();

  final BonsaiTree secondMugo = (BonsaiTreeBuilder()
        ..species = mugo
        ..speciesCounter = 2)
      .build();

  test('a new collection is empty', () {
    var collection = BonsaiCollection(species: testSpecies);
    expect(collection.size, 0);
  });

  test('can add a tree to the collection', () {
    var collection = BonsaiCollection(species: testSpecies);
    var aTree = (BonsaiTreeBuilder()..treeName = "Test Tree").build();
    collection.add(aTree);
    expect(collection.size, 1);
    expect(collection.trees, contains(aTree));
  });

  test('can get all trees for a given species', () {
    var collection = BonsaiCollection.withTrees([firstMugo, secondMugo], species: testSpecies);

    var foundMugos = collection.findAll(mugo);
    expect(foundMugos.length, 2);
    var foundSilvestris = collection.findAll(silvestris);
    expect(foundSilvestris.length, 0);
  });

  test('can get a tree with a given id', () {
    var collection = BonsaiCollection.withTrees([firstMugo, secondMugo], species: testSpecies);
    var found = collection.findById(secondMugo.id);
    expect(found, equals(secondMugo));
  });

  test('can update a tree with new data', () {
    var collection = BonsaiCollection.withTrees([firstMugo, secondMugo], species: testSpecies);
    var id = secondMugo.id;
    var updated = (BonsaiTreeBuilder(fromTree: secondMugo)
          ..treeName = "Updated Tree Name")
        .build();
    collection.update(updated);
    var found = collection.findById(id);
    expect(found, equals(updated));
  });
}
