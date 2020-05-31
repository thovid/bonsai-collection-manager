/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import './bonsai_tree.dart';
import './species.dart';
import '../../shared/model/model_id.dart';

mixin BonsaiTreeRepository {
  Future<void> update(BonsaiTree tree);

  Future<BonsaiCollection> loadCollection();
}

class BonsaiCollection extends ChangeNotifier {
  final List<BonsaiTree> _trees = <BonsaiTree>[];
  final BonsaiTreeRepository _repository;

  BonsaiCollection({repository: BonsaiTreeRepository})
      : this.withTrees([], repository: repository);

  BonsaiCollection.withTrees(List<BonsaiTree> trees,
      {BonsaiTreeRepository repository})
      : _repository = repository {
    _trees.addAll(trees);
  }

  int get size => _trees.length;

  List<BonsaiTree> get trees => List<BonsaiTree>.unmodifiable(_trees);

  BonsaiTree findById(ModelID<BonsaiTree> id) {
    return _trees.firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<BonsaiTree> add(BonsaiTree tree) async {
    return update(tree);
  }

  Future<BonsaiTree> update(BonsaiTree tree) async {
    final int index = _trees.indexWhere((element) => element.id == tree.id);
    if (index < 0) return _insert(tree);
    return _updateAt(index, tree);
  }

  BonsaiTree _updateAt(int index, BonsaiTree tree) {
    final BonsaiTree oldVersion = _trees[index];
    if (oldVersion.species.latinName != tree.species.latinName) {
      tree = _updateSpeciesOrdinal(tree);
    }
    _trees[index] = tree;
    _repository.update(tree);
    notifyListeners();
    return tree;
  }

  BonsaiTree _insert(BonsaiTree tree) {
    tree = _updateSpeciesOrdinal(tree);
    _trees.add(tree);
    _repository.update(tree);
    notifyListeners();
    return tree;
  }

  BonsaiTree _updateSpeciesOrdinal(BonsaiTree tree) =>
      (BonsaiTreeBuilder(fromTree: tree)
            ..speciesOrdinal = _nextOrdinalFor(tree.species))
          .build();

  List<BonsaiTree> _findAll(Species species) =>
      _trees.fold(<BonsaiTree>[], (result, element) {
        if (element.species == species) result.add(element);
        return result;
      });

  int _nextOrdinalFor(Species species) => _findAll(species).fold(
      1,
      (result, tree) =>
          tree.speciesOrdinal >= result ? tree.speciesOrdinal + 1 : result);
}
