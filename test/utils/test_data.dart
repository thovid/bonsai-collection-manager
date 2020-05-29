/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';

final SpeciesRepository testSpecies = TestSpeciesRepository([
  Species(TreeType.tropical, latinName: 'test', informalName: 'tset'),
  Species(TreeType.tropical, latinName: 'other', informalName: 'rehto'),
  Species(TreeType.conifer, latinName: 'Pinus', informalName: 'Pine'),
  Species(TreeType.conifer,
      latinName: 'Pinus Silvestris', informalName: 'Scots Pine'),
  Species(TreeType.conifer,
      latinName: 'Pinus Mugo', informalName: 'Mountain Pine')
]);

final BonsaiTree aBonsaiTree = (BonsaiTreeBuilder()
      ..species = Species(TreeType.conifer,
          latinName: 'Pinus Mugo', informalName: 'Mountain Pine')
      ..treeName = 'My Tree'
      ..speciesOrdinal = 1
      ..developmentLevel = DevelopmentLevel.refinement
      ..potType = PotType.bonsai_pot
      ..acquiredAt = DateTime(2020, 5, 20)
      ..acquiredFrom = 'Bonsai Shop')
    .build();

class TestSpeciesRepository extends SpeciesRepository {
  final List<Species> species;
  TestSpeciesRepository(this.species);
}

class TestBonsaiRepository extends BonsaiTreeRepository {
  List<BonsaiTree> trees;
  static BonsaiTree lastUpdated;
  TestBonsaiRepository(this.trees);

  @override
  Future<BonsaiCollection> loadCollection() async {
    return BonsaiCollection.withTrees(trees, repository: this);
  }

  @override
  Future<BonsaiTree> update(BonsaiTree tree) async {
    return lastUpdated = tree;
  }
}
