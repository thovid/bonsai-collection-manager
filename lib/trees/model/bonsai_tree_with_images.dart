/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:flutter/widgets.dart';

import 'bonsai_tree_data.dart';

class BonsaiTreeWithImages with ChangeNotifier {
  final BonsaiCollection _collection;
  BonsaiTreeData tree;
  Images images;

  BonsaiTreeWithImages({@required this.tree, this.images, @required BonsaiCollection collection})
      : _collection = collection;

  Future<BonsaiTreeData> updateTree(BonsaiTreeData tree) async {
    return _collection
        .update(tree)
        .then((updatedTree) => this.tree = updatedTree)
        .then((updatedTree) {
      notifyListeners();
      return updatedTree;
    });
  }
}
