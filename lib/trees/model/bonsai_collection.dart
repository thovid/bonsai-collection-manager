/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import './bonsai_tree.dart';
import './species.dart';

abstract class BonsaiTreeRepository {
  Future<BonsaiTree> update(BonsaiTree tree);
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

  Future<BonsaiTree> add(BonsaiTree tree) async {
    return update(tree);
  }

  BonsaiTree findById(BonsaiTreeID id) {
    return _trees.firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<BonsaiTree> update(BonsaiTree tree) async {
    int index = _trees.indexWhere((element) => element.id == tree.id);

    if (index < 0) {
      tree = _updateSpeciesOrdinal(tree);
      _trees.add(tree);
    } else {
      BonsaiTree oldVersion = _trees.removeAt(index);
      if (oldVersion.species.latinName != tree.species.latinName) {
        tree = _updateSpeciesOrdinal(tree);
      }
      _trees.insert(index, tree);
    }

    notifyListeners();
    return tree;
  }

  BonsaiTree _updateSpeciesOrdinal(BonsaiTree tree) {
    return (BonsaiTreeBuilder(fromTree: tree)
          ..speciesOrdinal = _nextOrdinalFor(tree.species))
        .build();
  }

  List<BonsaiTree> _findAll(Species species) {
    return _trees.fold(<BonsaiTree>[], (previousValue, element) {
      if (element.species == species) previousValue.add(element);
      return previousValue;
    });
  }

  int _nextOrdinalFor(Species species) {
    return _findAll(species).fold(
        1,
        (previousValue, element) => element.speciesOrdinal >= previousValue
            ? element.speciesOrdinal + 1
            : previousValue);
  }
}
