/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import './bonsai_tree_data.dart';
import './species.dart';
import '../../shared/model/model_id.dart';

mixin BonsaiTreeRepository {
  Future<void> update(BonsaiTreeData tree);

  Future<BonsaiCollection> loadCollection();
}

class BonsaiCollection extends ChangeNotifier {
  final List<BonsaiTreeData> _trees = <BonsaiTreeData>[];
  final BonsaiTreeRepository _repository;

  BonsaiCollection({repository: BonsaiTreeRepository})
      : this.withTrees([], repository: repository);

  BonsaiCollection.withTrees(List<BonsaiTreeData> trees,
      {BonsaiTreeRepository repository})
      : _repository = repository {
    _trees.addAll(trees);
  }

  int get size => _trees.length;

  List<BonsaiTreeData> get trees => List<BonsaiTreeData>.unmodifiable(_trees);

  BonsaiTreeData findById(ModelID<BonsaiTreeData> id) {
    return _trees.firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<BonsaiTreeData> add(BonsaiTreeData tree) async {
    return update(tree);
  }

  Future<BonsaiTreeData> update(BonsaiTreeData tree) async {
    final int index = _trees.indexWhere((element) => element.id == tree.id);
    if (index < 0) return _insert(tree);
    return _updateAt(index, tree);
  }

  BonsaiTreeData _updateAt(int index, BonsaiTreeData tree) {
    final BonsaiTreeData oldVersion = _trees[index];
    if (oldVersion.species.latinName != tree.species.latinName) {
      tree = _updateSpeciesOrdinal(tree);
    }
    _trees[index] = tree;
    _repository.update(tree);
    notifyListeners();
    return tree;
  }

  BonsaiTreeData _insert(BonsaiTreeData tree) {
    tree = _updateSpeciesOrdinal(tree);
    _trees.add(tree);
    _repository.update(tree);
    notifyListeners();
    return tree;
  }

  BonsaiTreeData _updateSpeciesOrdinal(BonsaiTreeData tree) =>
      (BonsaiTreeDataBuilder(fromTree: tree)
            ..speciesOrdinal = _nextOrdinalFor(tree.species))
          .build();

  List<BonsaiTreeData> _findAll(Species species) =>
      _trees.fold(<BonsaiTreeData>[], (result, element) {
        if (element.species == species) result.add(element);
        return result;
      });

  int _nextOrdinalFor(Species species) => _findAll(species).fold(
      1,
      (result, tree) =>
          tree.speciesOrdinal >= result ? tree.speciesOrdinal + 1 : result);
}
