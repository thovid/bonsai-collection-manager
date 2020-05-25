/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:flutter/material.dart';

class BonsaiCollection extends ChangeNotifier {
  final SpeciesRepository _allSpecies;
  final List<BonsaiTree> _trees = <BonsaiTree>[];

  BonsaiCollection({@required SpeciesRepository species})
      : this.withTrees([], species: species);

  BonsaiCollection.withTrees(List<BonsaiTree> trees,
      {@required SpeciesRepository species})
      : assert(species != null),
        _allSpecies = species {
    _trees.addAll(trees);
  }

  int get size => _trees.length;

  List<Species> get species => _allSpecies.species;

  List<BonsaiTree> get trees => List<BonsaiTree>.unmodifiable(_trees);

  BonsaiTree add(BonsaiTree tree) {
   return update(tree);
  }

  BonsaiTree findById(BonsaiTreeID id) {
    return _trees.firstWhere((element) => element.id == id);
  }

  BonsaiTree update(BonsaiTree tree) {
    tree = (BonsaiTreeBuilder(fromTree: tree)
          ..speciesOrdinal = _nextOrdinalFor(tree.species))
        .build();
    int index = _trees.indexWhere((element) => element.id == tree.id);
    if (index < 0) {
      _trees.add(tree);
    } else {
      _trees.removeAt(index);
      _trees.insert(index, tree);
    }

    notifyListeners();
    return tree;
  }

  Future<List<Species>> findSpeciesMatching(String pattern) async {
    return _allSpecies.findMatching(pattern);
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
