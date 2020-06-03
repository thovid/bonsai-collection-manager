/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_with_images.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';

import 'test_mocks.dart';

final SpeciesRepository testSpecies = TestSpeciesRepository([
  Species(TreeType.tropical, latinName: 'test', informalName: 'tset'),
  Species(TreeType.tropical, latinName: 'other', informalName: 'rehto'),
  Species(TreeType.conifer, latinName: 'Pinus', informalName: 'Pine'),
  Species(TreeType.conifer,
      latinName: 'Pinus Silvestris', informalName: 'Scots Pine'),
  Species(TreeType.conifer,
      latinName: 'Pinus Mugo', informalName: 'Mountain Pine')
]);

final BonsaiTreeData aBonsaiTree = (BonsaiTreeDataBuilder()
      ..species = Species(TreeType.conifer,
          latinName: 'Pinus Mugo', informalName: 'Mountain Pine')
      ..treeName = 'My Tree'
      ..speciesOrdinal = 1
      ..developmentLevel = DevelopmentLevel.refinement
      ..potType = PotType.bonsai_pot
      ..acquiredAt = DateTime(2020, 5, 20)
      ..acquiredFrom = 'Bonsai Shop')
    .build();

final BonsaiTreeWithImages aBonsaiTreeWithImages = BonsaiTreeWithImages(
    treeData: aBonsaiTree,
    images: Images(repository: DummyImageRepository(), parent: aBonsaiTree.id));

