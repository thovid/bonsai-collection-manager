/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/widgets.dart';

import '../../shared/model/model_id.dart';
import '../../images/model/images.dart';
import './bonsai_tree_with_images.dart';
import './species.dart';
import './bonsai_tree_data.dart';

mixin BonsaiTreeRepository {
  Future<void> update(BonsaiTreeData tree);

  Future<List<BonsaiTreeData>> loadBonsaiCollection();

  Future<void> delete(ModelID<BonsaiTreeData> id);
}

class BonsaiTreeCollection with ChangeNotifier {
  static Future<BonsaiTreeCollection> load(
      {@required BonsaiTreeRepository treeRepository,
      @required ImageRepository imageRepository}) async {
    final BonsaiTreeCollection result = BonsaiTreeCollection._internal(
        treeRepository: treeRepository, imageRepository: imageRepository);
    final List<BonsaiTreeData> treeData =
        await treeRepository.loadBonsaiCollection();
    treeData.forEach((tree) {
      result._trees.add(BonsaiTreeWithImages(
        treeData: tree,
        images: Images(parent: tree.id, repository: imageRepository),
      ));
    });
    return result;
  }

  final BonsaiTreeRepository _treeRepository;
  final ImageRepository _imageRepository;
  final List<BonsaiTreeWithImages> _trees = [];

  BonsaiTreeCollection._internal(
      {@required BonsaiTreeRepository treeRepository,
      @required ImageRepository imageRepository})
      : assert(treeRepository != null && imageRepository != null),
        _treeRepository = treeRepository,
        _imageRepository = imageRepository;

  int get size => _trees.length;

  List<BonsaiTreeWithImages> get trees => List.unmodifiable(_trees);

  Future<BonsaiTreeWithImages> add(BonsaiTreeData treeData) async {
    BonsaiTreeWithImages newTree = BonsaiTreeWithImages(
        treeData: treeData,
        images: Images(parent: treeData.id, repository: _imageRepository));
    return _insert(newTree);
  }

  Future<BonsaiTreeWithImages> update(BonsaiTreeWithImages tree) async {
    final int index = _trees.indexWhere((element) => element.id == tree.id);
    if (index < 0) return _insert(tree);
    return _updateAt(index, tree);
  }

  BonsaiTreeWithImages findById(ModelID<BonsaiTreeData> id) =>
      _trees.firstWhere((element) => element.id == id, orElse: () => null);

  Future<void> delete(BonsaiTreeWithImages tree) async {
    await tree.images
        .deleteAll()
        .then((_) => _treeRepository.delete(tree.id))
        .then((_) => _trees.removeWhere((element) => element.id == tree.id));
    notifyListeners();
  }

  Future<BonsaiTreeWithImages> _insert(BonsaiTreeWithImages newTree) async {
    newTree.treeData = (BonsaiTreeDataBuilder(fromTree: newTree.treeData)
          ..speciesOrdinal = _nextOrdinalFor(newTree.treeData.species))
        .build();
    await _addTreeToCacheAndRepository(newTree);
    notifyListeners();
    return newTree;
  }

  // does not notifyListeners() because we do not want to update the whole collection
  Future<BonsaiTreeWithImages> _updateAt(
      int index, BonsaiTreeWithImages tree) async {
    _updateSpeciesOrdinal(index, tree);
    await _addTreeToCacheAndRepository(tree);
    return tree;
  }

  List<BonsaiTreeWithImages> _findAll(Species species) =>
      _trees.fold(<BonsaiTreeWithImages>[], (result, element) {
        if (element.treeData.species == species) result.add(element);
        return result;
      });

  Future _addTreeToCacheAndRepository(BonsaiTreeWithImages tree) async {
    _trees.add(tree);
    _trees.sort(
        (a, b) => -a.treeData.acquiredAt.compareTo(b.treeData.acquiredAt));
    _treeRepository.update(tree.treeData);
  }

  void _updateSpeciesOrdinal(int index, BonsaiTreeWithImages tree) {
    final BonsaiTreeWithImages oldVersion = _trees[index];
    if (oldVersion.treeData.species.latinName !=
        tree.treeData.species.latinName) {
      tree.treeData = (BonsaiTreeDataBuilder(fromTree: tree.treeData)
            ..speciesOrdinal = _nextOrdinalFor(tree.treeData.species))
          .build();
    }
  }

  int _nextOrdinalFor(Species species) => _findAll(species).fold(
      1,
      (result, tree) => tree.treeData.speciesOrdinal >= result
          ? tree.treeData.speciesOrdinal + 1
          : result);
}
