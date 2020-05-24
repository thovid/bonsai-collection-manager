import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:flutter/material.dart';

class BonsaiCollection extends ChangeNotifier {
  final List<BonsaiTree> _trees = <BonsaiTree>[];
  BonsaiCollection();
  BonsaiCollection.withTrees(List<BonsaiTree> trees) {
    _trees.addAll(trees);
  }

  num get size => _trees.length;
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
    if(index < 0) {
      _trees.add(tree);
    } else {
      _trees.removeAt(index);
      _trees.insert(index, tree);
    }

    notifyListeners();
  }
}
