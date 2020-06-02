/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/images/model/collection_item_image.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_with_images.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';

import 'test_utils.dart';

final SpeciesRepository testSpecies = TestSpeciesRepository([
  Species(TreeType.tropical, latinName: 'test', informalName: 'tset'),
  Species(TreeType.tropical, latinName: 'other', informalName: 'rehto'),
  Species(TreeType.conifer, latinName: 'Pinus', informalName: 'Pine'),
  Species(TreeType.conifer,
      latinName: 'Pinus Silvestris', informalName: 'Scots Pine'),
  Species(TreeType.conifer,
      latinName: 'Pinus Mugo', informalName: 'Mountain Pine')
]);

// TODO make this a function!!!!!
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

// TODO make this a function!!!!!
final BonsaiTreeWithImages aBonsaiTreeWithImages = BonsaiTreeWithImages(
    treeData: aBonsaiTree,
    images: Images(repository: DummyImageRepository(), parent: aBonsaiTree.id));

class TestSpeciesRepository extends SpeciesRepository {
  final List<Species> species;
  TestSpeciesRepository(this.species);
}

class TestBonsaiRepository with BonsaiTreeRepository {
  List<BonsaiTreeData> trees;
  List<CollectionItemImage> images;
  static BonsaiTreeData lastUpdated;
  TestBonsaiRepository(this.trees, {this.images});

  @override
  Future<BonsaiCollection> loadCollection() async {
    return BonsaiCollection.withTrees(trees, repository: this);
  }

  @override
  Future<BonsaiTreeData> update(BonsaiTreeData tree) async {
    return lastUpdated = tree;
  }

  @override
  Future<List<BonsaiTreeData>> loadBonsaiCollection() async {
    return trees;
  }
}
