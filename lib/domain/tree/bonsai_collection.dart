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

  void add(BonsaiTree tree) {
    _trees.add(tree);
    notifyListeners();
  }

  List<BonsaiTree> findAll(Species species) {
    return _trees.fold(<BonsaiTree>[], (previousValue, element) {
      if (element.species == species) previousValue.add(element);
      return previousValue;
    });
  }

  BonsaiTree findById(BonsaiTreeID id) {
    return _trees.firstWhere((element) => element.id == id);
  }

  void update(BonsaiTree tree) {
    int index = _trees.indexWhere((element) => element.id == tree.id);
    if (index < 0) {
      _trees.add(tree);
    } else {
      _trees.removeAt(index);
      _trees.insert(index, tree);
    }

    notifyListeners();
  }

  Future<List<Species>> findSpeciesMatching(String pattern) async {
    var lowerCasePattern = pattern.toLowerCase();
    return Future(() {
      var result = <Species>[];
      species.forEach((element) {
        if (element.latinName.toLowerCase().contains(lowerCasePattern) ||
            element.informalName.toLowerCase().contains(lowerCasePattern)) {
          result.add(element);
        }
      });
      return result;
    });
  }
}
